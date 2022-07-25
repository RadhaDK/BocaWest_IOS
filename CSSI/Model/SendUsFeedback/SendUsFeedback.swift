//
//  SendUsFeedback.swift
//  CSSI
//
//  Created by apple on 11/26/18.
//  Copyright © 2018 yujdesigns. All rights reserved.
//

import Foundation
import ObjectMapper

class SenUsFeedback: NSObject, Mappable {
    var brokenRules: BrokenRules?
    var details: [DetailDuplicate]?
    
    
    var responseCode: String?
    var responseMessage: String?

    //Added on 22nd June 2020 BMS
    var imagePath : String?
    
    
    convenience required init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        details <- map["Details"]
        brokenRules <- map["BrokenRules"]
        responseCode <- map["ResponseCode"]
        responseMessage <- map["ResponseMessage"]
        //Added on 22nd June 2020 BMS
        imagePath <- map["ImagePath"]
    }
}


class DetailDuplicate: NSObject, Mappable  {
    
    var memberID: String?
    var memberName: String?
    var memberFullName: String?
   
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        memberID <- map["MemberID"]
        memberName <- map["MemberName"]
        memberFullName <- map["MemberFullName"]
       
        
        
    }
    
    
}
//class BrokenRules: NSObject, Mappable  {
//    
//    var message: String
//    var fields: [String]
//
//    
//    convenience required init?(map: Map) {
//        self.init()
//    }
//    
//    func mapping(map: Map) {
//        message <- map["Message"]
//        fields <- map["Fields"]
// 
//    }
//    
//    
//}
