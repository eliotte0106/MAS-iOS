//
//  ViewFinderView.swift
//  mas-ios
//
//  Created by JihongPark on 1/23/24.
//

import Foundation
import SwiftUI

struct ViewFinderView: View {
    @Binding var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct ViewFinderView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFinderView(image: .constant(Image(systemName: "pencil")))
    }
}
