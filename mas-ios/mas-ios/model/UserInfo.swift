//
//  UserInfo.swift
//  mas-ios
//
//  Created by JihongPark on 1/19/24.
//

import Foundation

struct UserInfo: Codable {
    let submitterName: String
    let submitterPhone: String
    let submitterEmail: String
    let agreeToTerms: Bool
    let latlong: LatLong
}
