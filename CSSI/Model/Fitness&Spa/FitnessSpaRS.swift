//
//  FitnessSpaRS.swift
//  CSSI
//
//  Created by Kiran on 19/03/20.
//  Copyright © 2020 yujdesigns. All rights reserved.
//

import Foundation


struct FitnessSpaRS : Codable
{
    let upComingEvent: [UpComingFitness]
    let clubNews: [RecentNewsFitness]
    let rulesEtiquette: [RulesEtiquette]
    let fitnessSpaFiles: [FitnessSpaFile]
    let responseCode, responseMessage: String
    let importantContacts : [ImportantContactFitnessSpa]
    let instructionalVideos : [InstructionalVideo]
    let enableAppointment : String
    //Added on 14th October 2020 V2.3
    let enableFitnessActivity : String
    
    enum CodingKeys: String, CodingKey {
        case upComingEvent = "UpComingEvent"
        case clubNews = "ClubNews"
        case rulesEtiquette = "RulesEtiquette"
        case responseCode = "ResponseCode"
        case responseMessage = "ResponseMessage"
        case fitnessSpaFiles = "GetFitnessSpaFiles"
        case importantContacts = "ImportantContacts"
        case instructionalVideos = "InstructionalVideos"
        case enableAppointment = "EnableAppointment"
        case enableFitnessActivity = "EnableFitnessActivity"
    }
    
}

struct UpComingFitness : Codable
{
    let image : String
    let imageThumb : String
    
    enum CodingKeys: String, CodingKey{
        case image = "ImageLarge"
        case imageThumb = "ImageThumb"
    }
}

struct RecentNewsFitness : Codable
{
    let id, newsTitle, date, description: String
    let newsImage: String
    let newsVideoURL, departmentName, author: String
    let newsImageList : [ImageData]
   
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case newsTitle = "NewsTitle"
        case date = "Date"
        case description = "Description"
        case newsImage = "NewsImage"
        case newsVideoURL = "NewsVideoUrl"
        case departmentName = "DepartmentName"
        case author = "Author"
        case newsImageList = "NewsImageList"
    }
}

struct FitnessSpaFile : Codable {
    
    let id,name,image,path,businessUrl,categoryName,fileType,videoURL,sectionName : String
    enum CodingKeys: String , CodingKey
    {
        case id = "FileID"
        case name = "FileName"
        case image = "FileImage"
        case path = "FileExtension"
        case businessUrl = "BusinessUrl"
        case categoryName = "CategoryName"
        case fileType = "FileType"
        case videoURL = "VideoURL"
        case sectionName = "SectionName"
    }
}

struct ImportantContactFitnessSpa: Codable {
    let displayName, activity: String
    let icon, icon2X, icon3X: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "DisplayName"
        case activity = "Activity"
        case icon = "Icon"
        case icon2X = "Icon2x"
        case icon3X = "Icon3x"
    }
}
