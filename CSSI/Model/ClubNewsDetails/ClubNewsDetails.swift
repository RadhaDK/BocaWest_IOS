//
//  ClubNewsDetails.swift
//  CSSI
//
//  Created by apple on 10/31/18.
//  Copyright © 2018 yujdesigns. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let clubNewsDetails = try? newJSONDecoder().decode(ClubNewsDetails.self, from: jsonData)

import UIKit
import Foundation
import ObjectMapper

class ClubNewsDetails : NSObject , Mappable{

    var clubNews: [AllClubNew]!
    var responseCode, responseMessage : String!

    override init() {
        super.init()
    }

    required convenience init(map : Map) {
        self.init()
    }

    func mapping(map: Map) {
        clubNews <- map["ClubNews"]
        responseCode <- map["ResponseCode"]
        responseMessage <- map["ResponseMessage"]
    }

}

class AllClubNew: NSObject , Mappable {

    var date: String!
    var clubNewsDetails: [ClubNewsDetail]!

    override init() {
        super.init()
    }

    required convenience init(map : Map) {
        self.init()
    }

     func mapping(map: Map) {
        date <- map["Date"]
        clubNewsDetails <- map["ClubNewsDetails"]
    }
}

class ClubNewsDetail : NSObject , Mappable{
    var id, newsTitle, date, descrption : String!
    var newsImage: String!
    var newsVideoURL: String!
    var departmentName, authorPretest,author: String!
    //Modified mediaDetails type from Dictionary on 14th May 2020 v2.1
    var newsImageList : [MediaDetails]?


    override init() {
        super.init()
    }

    required convenience init(map : Map) {
        self.init()
    }


     func mapping(map: Map) {
        id <- map["ID"]
        newsTitle <- map["NewsTitle"]
        date <- map["Date"]
        descrption <- map["Description"]
        newsImage <- map["NewsImage"]
        newsVideoURL <- map["NewsVideoUrl"]
        departmentName <- map["DepartmentName"]
        authorPretest <- map["AuthorPretext"]
        author <- map["Author"]
        newsImageList <- map["NewsImageList"]
    }
}

//Added on 14th May 2020 v2.1

///Details of the file
class MediaDetails : NSObject , Mappable
{
    var newsImagePath,ID,newsImage : String?
    var type : MediaType?
    var sequence : Int?
    override init() {
        super.init()
    }
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        newsImagePath <- map["NewsImagePath"]
        ID <- map["ImageID"]
        newsImage <- map["NewsImage"]
        type <- (map["Type"],EnumTransform<MediaType>())
        sequence <- map["Sequence"]
    }
    
    
}


//MARK:- Codable
/*
struct ClubNewsDetails: Codable {
    let clubNews: [AllClubNew]
    let responseCode, responseMessage: String
    
    enum CodingKeys: String, CodingKey {
        case clubNews = "ClubNews"
        case responseCode = "ResponseCode"
        case responseMessage = "ResponseMessage"
    }
}

struct AllClubNew: Codable {
    let date: String
    let clubNewsDetails: [ClubNewsDetail]
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case clubNewsDetails = "ClubNewsDetails"
    }
}

struct ClubNewsDetail : Codable {
    let id, newsTitle, date, description: String
    let newsImage: String
    let newsVideoURL: String
    let departmentName, authorPretest,author: String
    let newsImages: [[String : Any]]
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case newsTitle = "NewsTitle"
        case date = "Date"
        case description = "Description"
        case newsImage = "NewsImage"
        case newsVideoURL = "NewsVideoUrl"
        case departmentName = "DepartmentName"
        case author = "Author"
        case authorPretest = "AuthorPretext"
        case newsImages = "NewsImageList"
    }
}
*/
