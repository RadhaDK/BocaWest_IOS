//
//  MemberInfo.swift
//  CSSI
//
//  Created by MACMINI13 on 05/07/18.
//  Copyright © 2018 yujdesigns. All rights reserved.
//

import Foundation
import ObjectMapper

class ParentMemberInfo: NSObject, Mappable {
    var memberID: String?
    var memberName: String?
    var prefix: String?
    var profilePic: String?
    var responseCode: String?
    var responseMessage: String?
    var brokenrules: String?
    var message: String?
    var fields: [Fields]?
    var parentId: String?
    var id: String?
    var culturecode: String?
    var status: String?
    var firstName: String?
    var lastName: String?
    var isAdminvalue: String?
    var userName: String?
    var displayName: String?
    var role: String?
    var fullName: String?
    var memberNameDisplay: String?
    var isFirstTime: String?
    var masterMemberID: String?
    var memberUserName: String?
    var isSpouse: Int?
    convenience required init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        isSpouse <- map["IsSpouse"]
        memberUserName <- map["MemberUserName"]
        isFirstTime <- map["IsFirstTime"]
        memberNameDisplay <- map["MemberNameDisplay"]
        fullName <- map["FullName"]
        memberID <- map["MemberID"]
        memberName <- map["MemberName"]
        prefix <- map["Prefix"]
        profilePic <- map["ProfilePic"]
        responseCode <- map["ResponseCode"]
        responseMessage <- map["ResponseMessage"]
        masterMemberID <- map["ID"]
        brokenrules <- map["BrokenRules"]
        message <- map["Message"]
        fields <- map["Fields"]
        parentId <- map["ParentID"]
        culturecode <- map["CultureCode"]
        status <- map["Status"]
        id <- map["ID"]
        firstName <- map["FirstName"]
        lastName <- map["LastName"]
        isAdminvalue <- map["IsAdmin"]
        role <- map["Role"]
        userName <- map["UserName"]
        displayName <- map["DisplayName"]
    }
}
class Fields: NSObject, Mappable  {
    
   // var memberID: Int?
    var password: String?
   
    
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
       // memberID <- map["Member ID"]
        password <- map["Password"]
      
        
    }
    
}



