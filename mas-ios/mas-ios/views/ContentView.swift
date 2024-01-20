//
//  ContentView.swift
//  mas-ios
//
//  Created by JihongPark on 1/19/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                Image("car")
                Spacer()
                Button {
                    print("Take a photo of your car")
                } label: {
                    Text("Take a photo of your car")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .font(.system(size: 24))
                        .background(Color("Button"))
                        .foregroundColor(.white)
                        .clipShape(.capsule)
                        
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
