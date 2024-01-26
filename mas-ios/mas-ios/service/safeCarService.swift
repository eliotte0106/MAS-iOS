//
//  safeCarService.swift
//  mas-ios
//
//  Created by JihongPark on 1/23/24.
//

import Foundation
import SwiftUI

class SafeCarService {
    let BASE_URL = "http://[END-POINT-URL]:3000/api/request"
    
    init() {}
    
    func submitInfo(endPoint: String, carImage: CarImage, uploadData: Data) async throws -> NetworkResponse {
        
        let url = URL(string: "\(BASE_URL)")!
        let requestUrl = url.appendingPathComponent(endPoint)
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var postData = Data()
        
        let filename = "image.jpg"
        let mimetype = "image/jpeg"
        
        postData.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        postData.append("Content-Disposition: form-data; name=\"userinfo\"\r\n".data(using: .utf8)!)
        postData.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        postData.append(uploadData)
        postData.append("\r\n".data(using: .utf8)!)
        
        postData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        postData.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        postData.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        postData.append(carImage.uiImage.jpegData(compressionQuality: 0.8)!)
        
        postData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        
        request.httpBody = postData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            print(response)
            return NetworkResponse(code: 1, message: "Server error", data: nil)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(NetworkResponse.self, from: data)
            print("Got data: \(decodedResponse)")
            return decodedResponse
            
        } catch {
            print("Error parsing JSON: \(error)")
            return NetworkResponse(code: 1, message: "Failed to decode response", data: nil)

        }
    }
    
}

struct NetworkResponse: Codable {
    let code: Int
    let message: String
    let data: String?
}

enum NetworkError: Error {
    case invalidResponse(Int)
    case emptyResponse
    case invalidRequestBody
    case invalidResponseData
}
