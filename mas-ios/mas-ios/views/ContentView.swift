//
//  ContentView.swift
//  mas-ios
//
//  Created by JihongPark on 1/19/24.
//

import SwiftUI
import PhotosUI

struct Order: Codable {
    let customerId: String
    let items: [String]
}

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    private var service = SafeCarService()
    
    @State var isPresented = false

    private static let barHeightFactor = 0.15
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Image("car")
                    .frame(width: 200, height: 200)
                    .scaledToFill()
                SelectedPhotoView(imageState: viewModel.imageState)
                
                Spacer()
                
                HStack {
                    Button {
                        viewModel.takePhoto.toggle()
                    } label: {
                        Text("Take a photo")
                            .padding(16)
                            .font(.system(size: 24))
                            .background(.black)
                            .foregroundColor(.white)
                            .clipShape(.capsule)
                    }
                    
                }.padding()
                
                Spacer()
                
                if viewModel.imageSelected {
                    NavigationLink {
                        switch viewModel.imageState {
                        case .success(let carImage):
                            SubmitterInfoView(carImage: carImage)
                        case .empty:
                            Text("Empty")
                        case .loading(_):
                            ProgressView()
                        case .failure(_):
                            Text("Failed")
                        }
                        
                    } label: {
                        Text("Next")
                            .frame(width: 300, height: 40)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(6)
                    }
                }
            }
            .sheet(isPresented: $viewModel.takePhoto, onDismiss: didDismiss) {
                GeometryReader { geometry in
                    
                    ViewFinderView(image: $viewModel.viewfinderImage)
                        .frame(height: geometry.size.height)
                        .overlay(alignment: .bottom) {
                            
                            buttonsView()
                                .frame(height: geometry.size.height * Self.barHeightFactor)
                                .background(.black.opacity(0.75))
                        }.overlay(alignment: .topLeading) {
                            Button {
                                viewModel.takePhoto.toggle()
                            } label: {
                                Label {
                                    Text("Close live photo")
                                } icon: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 28))
                                        .foregroundColor(.blue)
                                        .opacity(0.85)
                                    }
                            }
                            .padding()
                        }
                        .labelStyle(.iconOnly)
                }
                .task {
                    await viewModel.camera.start()
                }
            }
            
        }
        
    }
    
    func didDismiss() {
        viewModel.camera.stop()
    }
    
    private func buttonsView() -> some View {
        
        HStack {
                        
            Spacer()
            
            Button {
                viewModel.camera.takePhoto()
            } label: {
                Label {
                    Text("Take a photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Spacer()
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
