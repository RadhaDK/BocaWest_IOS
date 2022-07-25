//
//  AppVersion.swift
//  CSSI
//
//  Created by apple on 11/11/19.
//  Copyright © 2019 yujdesigns. All rights reserved.
//

import Foundation

struct AppVersion: Codable {
    let responseCode, responseMessage, currentAppVersion : String
    let memberStatus : Int
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "ResponseCode"
        case responseMessage = "ResponseMessage"
        case currentAppVersion = "CurrentAppVersion"
        case memberStatus = "MemberStatus"
    }
}
