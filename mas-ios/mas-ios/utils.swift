//
//  utils.swift
//  mas-ios
//
//  Created by JihongPark on 1/22/24.
//

import Foundation
import PhotosUI
import SwiftUI
import os.log
import CoreTransferable

enum alertType {
    case error
    case info
    var title: String {
        switch self {
        case .error:
            return "Error"
        case .info:
            return "Info"
        }
    }
}

enum validationErrorEnum {
    case invalidName
    case invalidPhone
    case invalidEmail
    case invalidTac
}

enum TransferError: Error {
    case importFailed
}

struct Validator {
    static func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "[0-9]{10}"
        let unwantedCharacters = "[-() ]"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone.replacingOccurrences(of: unwantedCharacters, with: "", options: .regularExpression))
    }
}

struct CarImage: Transferable {
    let image: Image
    let uiImage: UIImage
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data),
                      let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
            return PetImage(image: image, uiImage: uiImage)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return CarImage(image: image, uiImage: uiImage)
            #else
                throw TransferError.importFailed
            #endif
        }
    }
}

let logger = Logger(subsystem: "mas-ios", category: "mas-ios")
