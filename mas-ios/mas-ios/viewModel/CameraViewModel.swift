//
//  CameraViewModel.swift
//  mas-ios
//
//  Created by JihongPark on 1/22/24.
//

import Foundation
import AVFoundation
import PhotosUI
import SwiftUI

class CameraViewModel: ObservableObject {
    let camera = Camera()
    
    @Published var viewfinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published private(set) var imageState: ImageState = .empty
    @Published var imageSelected = false
    @Published var takePhoto = false
    
    @Published var selectedPhoto: PhotosPickerItem? {
        didSet {
            if let selectedPhoto {
                let progress = loadTransferable(from: selectedPhoto)
                imageState = .loading(progress)
                imageSelected = true
            } else {
                imageState = .empty
                imageSelected = false
            }
        }
    }
    
    enum ImageState {
        case empty, loading(Progress), success(CarImage), failure(Error)
    }
    
    private var isPhotosLoaded = false
    
    private func loadTransferable(from imageSelection: PhotosPickerItem)-> Progress {
        return (selectedPhoto?.loadTransferable(type: CarImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.selectedPhoto else { return }
                switch result {
                case .success(let petImage?):
                    logger.debug("Image selection completed")
                    self.imageState = .success(petImage)
                case .success(nil):
                    logger.debug("no image has been selected")
                    self.imageState = .empty
                case .failure(let error):
                    logger.debug("image selection failed")
                    self.imageState = .failure(error)
                }
            }
        })!
    }
    
    init() {
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }
        
        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackPhotoStream = camera.photoStream.compactMap {
            self.unpackPhoto($0)
        }
        
        for await photoData in unpackPhotoStream {
            Task {@MainActor in
                self.imageState = .success( CarImage(image: photoData.thumbnailImage, uiImage: UIImage(data: photoData.imageData)!))
                takePhoto.toggle()
                imageSelected = true
            }
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto)-> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }

        guard let previewCGImage = photo.previewCGImageRepresentation(),
           let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))
        
        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
    }
    
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
