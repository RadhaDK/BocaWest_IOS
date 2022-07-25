//
//  CourtTimeDetails.swift
//  CSSI
//
//  Created by apple on 11/21/18.
//  Copyright © 2018 yujdesigns. All rights reserved.
//

import Foundation

struct CourtTimeDetails: Codable {
    let upComingEvent: [UpComingCourt]
    let clubNews: [RecentNewsCourt]
    let importantContacts, memberDirectory: [ImportantContactCourt]
    let instructionalVideos: [InstructionalVideoCourt]
    let tournamentForms: [TournamentFormsCourt]
    let rulesEtiquette: [RulesEtiquette]

    let responseCode, responseMessage: String
    
    enum CodingKeys: String, CodingKey {
        case upComingEvent = "UpComingEvent"
        case clubNews = "ClubNews"
        case importantContacts = "ImportantContacts"
        case memberDirectory = "MemberDirectory"
        case instructionalVideos = "InstructionalVideos"
        case tournamentForms = "TournamentForms"
        case rulesEtiquette = "RulesEtiquette"
        case responseCode = "ResponseCode"
        case responseMessage = "ResponseMessage"
    }
}

struct UpComingCourt: Codable {
    let image: String
    let imgthumb: String

    
    enum CodingKeys: String, CodingKey {
        case image = "ImageLarge"
        case imgthumb = "ImageThumb"

    }
}

struct RecentNewsCourt: Codable {
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

struct ImportantContactCourt: Codable {
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

struct InstructionalVideoCourt: Codable {
    let title: String
    let imageThumbnail: String
    let videoURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case imageThumbnail = "ImageThumbnail"
        case videoURL = "VideoUrl"
    }
}
struct TournamentFormsCourt: Codable {
    let title: String
    let TformID: String
    let URL: String
    
    enum CodingKeys: String, CodingKey {
        case TformID = "TournamentFormsID"
        case title = "Title"
        case URL = "FilePath"
    }
}

struct RulesEtiquette: Codable {
    let title: String
    let REID: String
    let URL: String
    
    enum CodingKeys: String, CodingKey {
        case REID = "RulesEtiquetteID"
        case title = "Title"
        case URL = "FilePath"
    }
}


