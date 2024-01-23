//
//  SubmitterInfoViewModel.swift
//  mas-ios
//
//  Created by JihongPark on 1/19/24.
//

import Foundation
import SwiftUI


class SubmitterInfoViewModel: ObservableObject {
    
    @Published var submitterName: String
    @Published var submitterPhone: String
    @Published var submitterEmail: String
    @Published var alertMessage: String = ""
    @Published var showAlert = false
    @Published var isEmailValid = false
    @Published var isPhoneValid = false
    @Published var inProgress = false
    
    init() {
        self.submitterName = ""
        self.submitterPhone = ""
        self.submitterEmail = ""
    }
    
    func submitInfo() {
        let userInfo = UserInfo(submitterName: self.submitterName,
                                submitterPhone: self.submitterPhone,
                                submitterEmail: self.submitterEmail)
        
        guard let uploadData = try? JSONEncoder().encode(userInfo) else {
            return
        }
    }
}
