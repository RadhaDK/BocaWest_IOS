//
//  TeeTimesDetails.swift
//  CSSI
//
//  Created by apple on 11/15/18.
//  Copyright © 2018 yujdesigns. All rights reserved.
//

import Foundation
import ObjectMapper
struct TeeTimesDetails: Codable
{
    let upComingEvent: [UpComing]
    let clubNews: [RecentNews]
    let importantContacts, memberDirectory: [ImportantContact]
    let instructionalVideos: [InstructionalVideo]
    let tournamentForms: [TournamentForms]
    let rulesEtiquette: [RulesEtiquetteTeeTimes]
    let reservationDateList: [ReservationDateList]
    let responseCode, responseMessage: String
    //Added by kiran V2.9 -- ENGAGE0012268 -- Lightning Warning button url
    //ENGAGE0012268 -- Start
    let lightningUrl : String?
    //ENGAGE0012268 -- End
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
        case reservationDateList = "ReservationDateList"
        //Added by kiran V2.9 -- ENGAGE0012268 -- Lightning Warning button url
        //ENGAGE0012268 -- Start
        case lightningUrl = "LightningUrl"
        //ENGAGE0012268 -- End
    }
    
}

struct UpComing: Codable {
    let image: String
    let imgthumb: String

    enum CodingKeys: String, CodingKey {
        case image = "ImageLarge"
        case imgthumb = "ImageThumb"
    }
}
struct ReservationDateList: Codable {
    let date: String
    let month: String
    let lotteryDate: String
    enum CodingKeys: String, CodingKey {
        case date = "DateDay"
        case month = "DateMonth"
        case lotteryDate = "LotteryDate"
    }
}
struct RecentNews: Codable {
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

struct ImportantContact: Codable {
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

struct InstructionalVideo: Codable {
    let title: String
    let imageThumbnail: String
    let videoURL: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case imageThumbnail = "ImageThumbnail"
        case videoURL = "VideoUrl"
    }
}
struct RulesEtiquetteTeeTimes: Codable {
    let title: String
    let REID: String
    let URL: String

    enum CodingKeys: String, CodingKey {
        case REID = "RulesEtiquetteID"
        case title = "Title"
        case URL = "FilePath"
    }
}
struct TournamentForms: Codable {
    let title: String
    let TformID: String
    let URL: String

    enum CodingKeys: String, CodingKey {
        case TformID = "TournamentFormsID"
        case title = "Title"
        case URL = "FilePath"
    }
}

//Modified to include type,sequence and newsIMagePath on 14th May 2020 v2.1
struct ImageData : Codable{
    let ImageID ,NewsImage,type: String
    let newsImagePath : String?
    let sequence : Int?
    enum CodingKeys: String, CodingKey {
        case ImageID = "ImageID"
        case NewsImage = "NewsImage"
        case type = "Type"
        case sequence = "Sequence"
        case newsImagePath = "NewsImagePath"
    }
}

//struct TeeTimesDetails: Codable {
//    let upComingEvent: [UpComing]
//    let clubNews: [RecentNews]
//    let importantContacts, memberDirectory: [ImportantContact]
//    let instructionalVideos: [InstructionalVideo]
//    let tournamentForms: [TournamentForms]
//    let rulesEtiquette: [RulesEtiquetteTeeTimes]
//    let reservationDateList: [ReservationDateList]
//    let responseCode, responseMessage: String
//
//    enum CodingKeys: String, CodingKey {
//        case upComingEvent = "UpComingEvent"
//        case clubNews = "ClubNews"
//        case importantContacts = "ImportantContacts"
//        case memberDirectory = "MemberDirectory"
//        case instructionalVideos = "InstructionalVideos"
//        case tournamentForms = "TournamentForms"
//        case rulesEtiquette = "RulesEtiquette"
//        case responseCode = "ResponseCode"
//        case responseMessage = "ResponseMessage"
//        case reservationDateList = "ReservationDateList"
//    }
//}
//
//struct UpComing: Codable {
//    let image: String
//    let imgthumb: String
//
//    enum CodingKeys: String, CodingKey {
//        case image = "ImageLarge"
//        case imgthumb = "ImageThumb"
//    }
//}
//struct ReservationDateList: Codable {
//    let date: String
//    let month: String
//    let lotteryDate: String
//    enum CodingKeys: String, CodingKey {
//        case date = "DateDay"
//        case month = "DateMonth"
//        case lotteryDate = "LotteryDate"
//    }
//}
//struct RecentNews: Codable {
//    let id, newsTitle, date, description: String
//    let newsImage: String
//    let newsVideoURL, departmentName, author: String
//    let newsImages : [String]
//    enum CodingKeys: String, CodingKey {
//        case id = "ID"
//        case newsTitle = "NewsTitle"
//        case date = "Date"
//        case description = "Description"
//        case newsImage = "NewsImage"
//        case newsVideoURL = "NewsVideoUrl"
//        case departmentName = "DepartmentName"
//        case author = "Author"
//        case newsImages = "NewsImageList"
//    }
//}
//
//struct ImportantContact: Codable {
//    let displayName, activity: String
//    let icon, icon2X, icon3X: String
//
//    enum CodingKeys: String, CodingKey {
//        case displayName = "DisplayName"
//        case activity = "Activity"
//        case icon = "Icon"
//        case icon2X = "Icon2x"
//        case icon3X = "Icon3x"
//    }
//}
//
//struct InstructionalVideo: Codable {
//    let title: String
//    let imageThumbnail: String
//    let videoURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case title = "Title"
//        case imageThumbnail = "ImageThumbnail"
//        case videoURL = "VideoUrl"
//    }
//}
//struct RulesEtiquetteTeeTimes: Codable {
//    let title: String
//    let REID: String
//    let URL: String
//
//    enum CodingKeys: String, CodingKey {
//        case REID = "RulesEtiquetteID"
//        case title = "Title"
//        case URL = "FilePath"
//    }
//}
//struct TournamentForms: Codable {
//    let title: String
//    let TformID: String
//    let URL: String
//
//    enum CodingKeys: String, CodingKey {
//        case TformID = "TournamentFormsID"
//        case title = "Title"
//        case URL = "FilePath"
//    }
//}




