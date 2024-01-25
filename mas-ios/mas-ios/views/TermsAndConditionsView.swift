//
//  TermsAndConditionsView.swift
//  mas-ios
//
//  Created by JihongPark on 1/23/24.
//

import Foundation
import SwiftUI

struct TermsAndConditionsView: View {
    
    @Binding var agreeToTerms: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        
        VStack {
            ScrollView {
                Text("This is for MAS course.")
            }.padding(12)
            
            Button {
                agreeToTerms = true
                isPresented = false
            } label: {
                Text("Agree")
                    .frame(width: 300, height: 40)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(6)
            }
            Button {
                agreeToTerms = false
                isPresented = false
            } label: {
                Text("Disagree")
                    .frame(width: 300, height: 40)
                    .foregroundColor(.blue)
                    .cornerRadius(6)
            }
        }

    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView(agreeToTerms: .constant(false), isPresented: .constant(true))
    }
}
