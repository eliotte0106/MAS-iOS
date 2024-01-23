//
//  SelectedPhotoView.swift
//  mas-ios
//
//  Created by JihongPark on 1/22/24.
//

import Foundation
import SwiftUI

struct SelectedPhotoView: View {
    let imageState: CameraViewModel.ImageState
    var body: some View {
        switch imageState {
        case .success(let carImage):
            carImage
                .image
                .resizable()
                .scaledToFit()
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 2)
                    )
        case .empty:
            Text("Take a photo of your car")
                .font(.system(size: 28))
        case .loading:
            ProgressView()
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct SelectedPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPhotoView(imageState: .empty)
    }
}
