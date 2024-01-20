//
//  SubmitterInfoView.swift
//  mas-ios
//
//  Created by JihongPark on 1/19/24.
//

import SwiftUI
import iPhoneNumberField

struct SubmitterInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = SubmitterInfoViewModel()
    
    @State var isPresented = false
    

    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $viewModel.submitterName, prompt: Text("First Last").italic())
                
                if viewModel.validationErrors.contains(.invalidName) {
                    Text("Please enter a name")
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
                
                if viewModel.validationErrors.contains(.invalidPhone) {
                    Text("Please enter a valid 10 digit phone")
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
                
                TextField("Email", text: $viewModel.submitterEmail,
                          prompt: Text("pjh@email.com")
                    .italic())
                .textInputAutocapitalization(.never)
                
                if viewModel.validationErrors.contains(.invalidEmail) {
                    Text("Please enter a correct from of email")
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
            }
            .disableAutocorrection(true)
            Spacer()
        }
        .navigationTitle("User info")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}

