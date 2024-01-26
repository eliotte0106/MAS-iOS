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
    @Published var agreeToTerms: Bool
    @Published var alertMessage: String = ""
    @Published var showAlert = false
    @Published var alertType: alertType = .info
    @Published var validationErrors: [validationErrorEnum] = [validationErrorEnum]()
    @Published var isEmailValid = false
    @Published var isPhoneValid = false
    @Published var inProgress = false
    
    let safeCarService = SafeCarService();
    
    init() {
        self.submitterName = ""
        self.submitterPhone = ""
        self.submitterEmail = ""
        self.agreeToTerms = false
    }
    
    func validateInfo()-> Bool {
        self.validationErrors.removeAll()
        
        if self.submitterName.isEmpty {
            self.validationErrors.append(.invalidName)
        }
        
        if !Validator.isValidPhone(phone: self.submitterPhone) {
            self.validationErrors.append(.invalidPhone)
        }
        
        if !Validator.isValidEmail(email: self.submitterEmail) {
            self.validationErrors.append(.invalidEmail)
        }
        
        if !self.agreeToTerms {
            self.validationErrors.append(.invalidTac)
        }
        
        return self.validationErrors.count == 0
    }
    
    func submitInfo(_ carImage: CarImage,_ latLong: LatLong) {
        let userInfo = UserInfo(submitterName: self.submitterName,
                                submitterPhone: self.submitterPhone,
                                submitterEmail: self.submitterEmail,
                                agreeToTerms: self.agreeToTerms,
                                latlong: latLong)
        
        guard let uploadData = try? JSONEncoder().encode(userInfo) else {
            return
        }
        
        Task {
            do {
                
                DispatchQueue.main.async {
                    self.inProgress.toggle()
                }
                
                let response = try await safeCarService.submitInfo(endPoint: "new", carImage: carImage, uploadData: uploadData)
                
                DispatchQueue.main.async {
                    if response.code == 0 {
                        
                        self.submitterName = ""
                        self.submitterPhone = ""
                        self.submitterEmail = ""
                        self.agreeToTerms = false
                        
                        self.alertType = .info
                    } else {
                        self.alertType = .error
                    }
                    
                    self.alertMessage = response.message
                    self.showAlert = true
                }
            } catch {
                self.alertType = .error
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                print("\(error)")
            }
            
            do {
                DispatchQueue.main.async {
                    self.inProgress.toggle()
                }
            }
        }

    }
}
