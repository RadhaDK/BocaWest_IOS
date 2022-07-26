import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Toaster

struct Response: Codable {
    
    let responseCode, responseMessage: String
    
    enum CodingKeys: String, CodingKey {
        
        case responseCode = "ResponseCode"
        case responseMessage = "ResponseMessage"
    }
    
    
}



class APIHandler: NSObject
{
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /**Production*/
    //let baseURL = "https://api.bocawestcc.org/app.wrapper/api/"
    
    /**UAT*/

    //Added on 20th August 2020
    //let baseURL = "https://api.mycobaltsoftware.com/App.Wrapper.BW/api/"
    
    /**Test*/
    //let baseURL = "https://cobaltportal.mycobaltsoftware.com/cssi.cobalt.member.wrapper.test/api/"
    
    /**Dev*/
    //let baseURL = "https://cobaltportal.mycobaltsoftware.com/cssi.cobalt.member.wrapper.dev/api/"
    
    //Added on 4th September 2020
    //Demo Links
    //Boca west App
    //let baseURL = "https://api.mycobaltsoftware.com/App.Wrapper.BW/api/"
    //Cobalt Member App
    //let baseURL = "https://api.mycobaltsoftware.com/App.Wrapper.CSSI/api/"
    
    //BMS training Link
    //let baseURL = "https://api.mycobaltsoftware.com/App.Wrapper.BWBMS/api/"

    
    //Cobalt Engage App Prod Link. CSSIC3
    //let engageProd = "https://api.mycobaltsoftware.com/App.Wrapper.CSSI/api/"
    
    
    let productionURL = "https://api.bocawestcc.org/app.wrapper/api/"
    
    let preProductionURL = "https://api.mycobaltsoftware.com/App.Wrapper.PreProd/api/"
    
    //Added on 20th August 2020
    let UATURL = "https://api.mycobaltsoftware.com/App.Wrapper.BW/api/"
    
    let testURL = "https://cobaltportal.mycobaltsoftware.com/cssi.cobalt.member.wrapper.test/api/"
    
    let devURL = "https://cobaltportal.mycobaltsoftware.com/cssi.cobalt.member.wrapper.dev/api/"
    
    //Added on 4th September 2020
    //Demo Links
    let bocaWestDemoURL = "https://api.mycobaltsoftware.com/App.Wrapper.BW/api/"
    let cobaltMemberDemoURL = "https://api.mycobaltsoftware.com/App.Wrapper.CSSI/api/"
    
    //BMS training Link
    let BMSTrainingURL = "https://api.mycobaltsoftware.com/App.Wrapper.BWBMS/api/"
    
    //Note:- Use for internal only. User below code for production
    //when using this comment generateBaseURL() method call in app delegate applicationWillFinishLaunching with options method.
    lazy var baseURL : String = self.devURL
    
    //MARK:- API Switch Variable
    //This is only implemented only for Boca West app as of now.
    
    //Change the url here to switch between environments.Use this for live version
    ///If isChangeBaseURL true will point to pre production and if false will point to production
    //Id urls are changed then do the same in generateBaseURL function
    //Note:- when commenting/Uncommenting this do the same with generateBaseURL() method call in app delegate application will finish launching with options methods.
    //lazy var baseURL : String = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isChangeBaseURL.rawValue) ? self.preProductionURL : self.productionURL
    
    
    let loginheaders: HTTPHeaders = [
        APIHeader.kusername: APIHeader.kusernamevalue,
        APIHeader.kpassword: APIHeader.kpasswordvalue,
        ]
    
    //let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String

    static let devicedict:[String: Any] = [
    
        APIKeys.kDeviceType: DeviceInfo.iosType,
        APIKeys.kOSVersion: DeviceInfo.iosVersion,
        //Added by kiran V2.9 -- ENGAGE0011722 -- Safely unwrapped the strings so optional(string) is not passed to backend.
        //ENGAGE0011722 -- Start
        APIKeys.kOriginatingIP : (getIP() ?? "") as Any,
        "AppVersion" : ((Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String) ?? "") as Any,
        //ENGAGE0011722 -- End
        "SessionID": NSUUID().uuidString,
        "Browser" : DeviceInfo.iosType,
        "SourcePortNo" : "",
        //Added by kiran V2.7 -- ENGAGE0011658 -- Get identifier for device modle
        //ENGAGE0011658 -- Start
        APIKeys.kDeviceIdentifier: UIDevice.modelIdentifier
        //ENGAGE0011658 -- End
    ]
    
    let dict:[String: Any] = [
        APIKeys.kMemberId: UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue),
        APIKeys.kdeviceInfo: APIHandler.devicedict
    ]
    
//    static let labelling = "http://crif.uxdesigndevelopment.com/api/CSSI_labels.json"
    static let labelling = "http://uxdesigndevelopment.com/crif/api/CSSI_labels.json"
    
    
     //MARK:- Member App links
    static let sharedInstance = APIHandler()
    
    //Added on 17th October 2020 V2.3
    static let baseURLEndPoint = "Member/GetBaseURLCheck"
    
    static let getPostsEndpoint = "Member/GetEvents"
    static let getEvent = "Member/GetEvent"
    static let cancelEvent = "Member/CancelEventRegistration"
    static let postauthenticateUser = "Account/AuthenticateUser"
    static let getGetEventDetails = "Member/GetEventDetails"
    static let getGetGolfCalendarEventDetails = "Member/GetTeeTimeDetails"
    static let getGetTennisCalendarEventDetails = "Member/GetTennisDetails"
    static let getGetDiningCalendarEventDetails = "Member/GetDiningDetails"
    static let getRequestTeeTimeDetails = "Member/GetRequestTeeTimeDetails"
    static let getRequestTennisDetails = "Member/GetRequestTennisDetails"
    static let getRequestDiningDetails = "Member/GetRequestDiningDetails"
    static let getSpaFitness = "Member/GetFitnessAndSpa"
    static let getSpaFitnessDetails = "Member/GetFitnessAndSpaDetails"
    
    static let getGetDashboard = "Member/GetDashboard"
    static let getStatementCategory = "Member/GetStatementCategory"
    static let getStatement = "Member/GetStatement"
    static let getStatementDetail = "Member/GetStatementDetail"
    static let getMemberInfo = "Member/GetMemberInfo"
    static let getMemberDirectoryApp = "Member/GetMemberDirectoryApp"
    static let getMemberSpouseList = "Member/GetMemberSpouseList"
    static let getBuddyList = "Member/GetBuddyList"
    static let getMyGroupsList = "Member/GetMyGroups"
    static let removeMyGroup = "Member/DeleteMyGroup"
    static let saveMyGroup = "Member/SaveMyGroup"
    static let getMyGroupDetails = "Member/GetMyGroupDetails"
    static let cancelRequest = "Member/CancelReservation"

    static let addToBuddyList = "Member/AddBuddy"
    static let saveEventRegistration = "Member/SaveEventRegistration"
    static let saveTeeTimeRequest = "Member/SaveTeeTimeRequest"
    static let saveDiningRequest = "Member/SaveDiningRequest"
    static let saveTennisRequest = "Member/SaveTennisRequest"
    static let getGuestList = "Member/GetGuestList"
    static let getAllGuestCardRequests = "Member/GetAllGuestCardRequests"
    static let getGetGuestCardDetails = "Member/GetGuestCardDetails"
    static let getGetImportantNumber = "Member/GetImportantNumber"
    static let addGuest = "Member/AddGuest"
    static let getInterestsList = "Member/GetMasterList"
    static let getOnlyInterestsList = "Member/GetInterestsList"
    static let getNotificationDetails = "Member/GetAllMessageNotificationDetail"
    static let getGiftCard = "Member/GetGiftCard"
    static let getGlanceDetails = "Member/GetGlanceDetails"
    static let postForgotPassword = "Member/ForgotPassword"
    static let postOTPVerify = "Member/ValidateOTP"
    static let getPreviousStatements = "Member/GetPreviousStatements"
    static let CancelGuestCard = "Member/CancelGuestCard"
    static let SaveMemberInfo = "Member/SaveMemberInfo"
    static let getIcon = "Member/GetIcons"
    static let saveGuestcard = "Member/SaveGuestCard"
    static let uploadProfileImage = "Member/ProfileUploadImage"
    static let getRestaurantMenuDetail = "Member/GetRestaurantMenuDetail"
    static let getDownloadStatements = "Member/DownloadStatement"
    static let getRestaurantDetail = "Member/GetRestaurantDetail"
    static let resetPassword = "Member/ResetPassword"
    static let changePassword = "Member/ChangePassword"
    static let saveSettings = "Member/SaveSettings"
    static let getSettings = "Member/GetSettings"

    static let notificationRead = "Member/MarkNotificationAsRead"
    static let getMultiLingualData = "Member/GetMultiLingualData"
    static let myGuestList = "Member/MyGuestCardList"
    static let requestGuestCard = "Member/RequestGuestCard"
    static let addOrModifyGuestCard = "Member/ModifyGuestCard"
    static let cancelGestCards = "Member/CancelGuestCard"
    static let guestHistory = "Member/GuestCardHistory"
    static let registerYourDevice = "Member/RegisterDevice"
    static let beacondIdentification = "Member/RecordDistance"
    static let clubNewsDetails = "Member/GetClubNewsDetails"
    static let getEventCategory   = "Member/GetEventCategory"
    static let getGlanceCategory   = "Member/GetGlanceCategory"
    static let getTeeTimes = "Member/GetTeeTimes"
    static let getCourtTimes = "Member/GetCourtTimes"
    static let getDiningReservations = "Member/GetDiningReservations"
    static let sendUsFeedBack = "Member/SaveMemberFeedback"
    
    static let playHistory = "Member/GetHistory"
    static let getGolfCategory = "Member/GetReservationCategory"
    static let getUpcomingTeeTimes = "Member/GetUpcomingDetails"
    static let removeBuddy = "Member/RemoveBuddy"
    static let getplayHistoryDetails = "Member/GetHistoryDetails"
    
    static let getReservationSettings = "Member/GetReservationSettings"
    static let getAnnualPlayHistoryDetails = "Member/GetAnnualPlayHistory"
    static let getMemberCategory = "Member/GetMemberCategory"
    static let getReservationGuestList = "Member/GetReservationGuestList"
    static let getUserActivity = "Member/SaveUserActivityInfo"
    static let getLogOut = "Member/LogOutUser"
    static let getGuestValidation = "Member/GetGuestValidation"
    static let getMemberValidation = "Member/GetMemberValidation"
    static let getGetGolfAlphadata = "Member/GetGolfAlphadata"
    static let getVersion = "Member/GetAppVersion"
    static let getLeagueURL = "Member/ExternalRedirect"
    
    
    //Added by kiran -- ENGAGE0011226 -- added for Covid rules
    static let getCovidRules = "Member/GetCovidRules"

   // ReservationGuestList
    //MARK:- BMS
    //Added by CSSI on 27th May 2020 BMS
    /// Used to get fitness and spa departments list, settings and screen flow per department
    static let getDepartmentDetails = "Member/GetDepartmentDetails"
    /// Used to get Service type list
    static let getProductionClassDetails = "Member/GetProductionClassDetails"
    ///Gets the list of service
    static let getServiceDetails = "Member/GetServiceDetails"
    ///Gets the list of providers
    static let getProviderDetails = "Member/GetProviderDetails"

    ///Available times to select from. currently used for Fitness only
    static let getAppointmentAvailableTime = "Member/GetAppointmentAvailableTime"
    
    ///Gives the list of unAvailable times.
    static let getAppointmentAvailableDate = "Member/GetAppointmentAvailableDate"
    
    ///Validates the Members of appointment
    static let getAppointmentValidation = "Member/GetAppointmentValidation"
    
    ///Saves the BMS appointment
    static let saveAppointment = "Member/SaveAppointment"
    ///Fetches the appointment details
    static let getAppointment = "Member/GetAppointment"
    
    static let cancelAppointment = "Member/CancelAppointment"
    
    static let getAppointmentHistory = "Member/GetAppointmentHistory"
    
    
    //Added by kiran V2.3
    //MARK:- Fitness App links
    static let fitnesssActivity = "Member/GetFitnessActivity"
    static let fitnessProfile = "Member/GetFitnessProfile"
    static let saveFitnessProfile = "Member/SaveFitnessProfile"
    static let getGoalsAndChallenges = "Member/GetGoalsAndChallenges"
    //Added by kiran V2.4 -- GATHER0000176
    //Start
    static let getFitnessActivityCheckin = "Member/GetFitnessActivityCheckin"
    static let saveFitnessActivityCheckin = "Member/SaveFitnessActivityCheckin"
    //Gets videos catrgoty list
    static let getFitnessVideoCategory = "Member/GetFitnessVideoCategory"
    //Gets fitness Groups
    static let getVideoSubCategories = "Member/GetVideoSubCategories"
    //Gets videos list
    static let getAudienceVideoPreference = "Member/GetAudienceVideoPreference"
    //Saves preference
    static let saveVideoPreference = "Member/SaveVideoPreference"
    //End
    
    //Added by kiran V2.8 -- ENGAGE0011784 -- Existing guest API
    //ENGAGE0011784 -- Start
    static let getMemberExistingGuestList = "Member/GetMemberExistingGuestList"
    //ENGAGE0011784 -- End
    
    //Added by kiran V2.9 -- ENGAGE0011898 -- Added support for GuestCard PDF instead of fetching details from API
    //ENGAGE0011898 -- Start
    static let getMobileConfigurations = "Member/GetMobileConfigurations"
    //ENGAGE0011898 -- End
    
    //Added by kiran V2.9 -- ENGAGE0011722 -- Apple wallet functionality
    //ENGAGE0011722 -- Start
    static let getWalletPass = "Member/GetWalletPass"
    //ENGAGE0011722 -- End
    
    //Added on 17th October 2020 V2.3
    //MARK:- BASE URL Handler
    func generateBaseURL()
    {
        let url : String = self.baseURL + APIHandler.baseURLEndPoint
        
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        let paramater : [String : Any] = [
            APIKeys.kdeviceInfo: [APIHandler.devicedict],
            APIKeys.kAppVersion: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                
                do{
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        let isChangeBaseURL = jsonDict["IsChangeBaseURL"] as? Int == 1
                        
                        if isChangeBaseURL
                        {
                            self.baseURL = self.preProductionURL
                        }
                        
                        UserDefaults.standard.set(isChangeBaseURL, forKey: UserDefaultsKeys.isChangeBaseURL.rawValue)
                    }
                    else
                    {
//                        //In this case default should always be false. adding this as Fail safe.
//                        UserDefaults.standard.set(isChangeBaseURL, forKey: UserDefaultsKeys.isChangeBaseURL.rawValue)
                    }
                    
                }
                catch _ as NSError {
//                    //In this case default should always be false. adding this as Fail safe.
//                    UserDefaults.standard.set(isChangeBaseURL, forKey: UserDefaultsKeys.isChangeBaseURL.rawValue)
                }

                
            case .failure( _):
//                //In this case default should always be false. adding this as Fail safe.
//                UserDefaults.standard.set(isChangeBaseURL, forKey: UserDefaultsKeys.isChangeBaseURL.rawValue)
            break
            }
            
            UserDefaults.standard.synchronize()
        }
        
    }
    
    //MARK:- Member App API methods
    
    func reservationGuestList(paramater: [String: Any]?, onSuccess: @escaping(ReservationGuestList) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url : String = baseURL + APIHandler.getReservationGuestList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                               //print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(ReservationGuestList.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    
    func getMemberCategory(paramater: [String: Any]?, onSuccess: @escaping(AddBuddyCategory) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getMemberCategory
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            self.appDelegate.hideIndicator()
                            let dashboardDict = try JSONDecoder().decode(AddBuddyCategory.self, from: response.data!)
                            self.appDelegate.hideIndicator()
                            onSuccess(dashboardDict)
                        }
                        
                    }
                    else {
                        
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func getReservationSettings(paramater: [String: Any], onSuccess: @escaping(RequestSettings) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getReservationSettings

        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                //print(response)
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<RequestSettings>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
  
    
    func getEventsList(paramaterDict: [String: Any]?, onSuccess: @escaping(EventsLists) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getGetEventDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<EventsLists>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    func getGolfCalendarList(paramaterDict: [String: Any]?, onSuccess: @escaping(EventsLists) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getGetGolfCalendarEventDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<EventsLists>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func getTennisCalendarList(paramaterDict: [String: Any]?, onSuccess: @escaping(EventsLists) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getGetTennisCalendarEventDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<EventsLists>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    func getDiningCalendarList(paramaterDict: [String: Any]?, onSuccess: @escaping(EventsLists) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getGetDiningCalendarEventDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        print(jsonDict)
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<EventsLists>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    func getRequestTeeTimeDetails(paramaterDict: [String: Any]?, onSuccess: @escaping(TeeTimeDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getRequestTeeTimeDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<TeeTimeDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    func getRequestTennisDetails(paramaterDict: [String: Any]?, onSuccess: @escaping(TeeTimeDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getRequestTennisDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<TeeTimeDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    func getRequestDiningDetails(paramaterDict: [String: Any]?, onSuccess: @escaping(TeeTimeDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getRequestDiningDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        print(jsonDict)
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<TeeTimeDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    func getFitnessAndSpaDetails(paramaterDict : [String : Any]?, onSuccess: @escaping(EventsLists) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url : String = baseURL + APIHandler.getSpaFitnessDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
               // print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<EventsLists>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
                break
            default:
                print("error")
            }

        }
    }
    
    func getGolfPlayHistory(paramaterDict: [String: Any]?, onSuccess: @escaping(PlayHistory) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.playHistory
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<PlayHistory>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    func getUpcomingTeeTimes(paramaterDict: [String: Any]?, onSuccess: @escaping(UpComingTeeTimes) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getUpcomingTeeTimes
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<UpComingTeeTimes>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }

    func getPlayHistoryDetails(paramaterDict: [String: Any]?, onSuccess: @escaping(HistoryDetails) -> Void, onFailure: @escaping(Error) -> Void) {

        let url : String = baseURL + APIHandler.getplayHistoryDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""

        ]

        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString eventlist= \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<HistoryDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }

        }


    }

//    func getPlayHistoryDetails(paramater: [String: Any]?, onSuccess: @escaping(PlayHistorydetails) -> Void, onFailure: @escaping(Error) -> Void) {
//        let url : String = baseURL + APIHandler.getplayHistoryDetails
//
//        let headers: HTTPHeaders = [
//            APIHeader.kusername: APIHeader.kusernamevalue,
//            APIHeader.kpassword: APIHeader.kpasswordvalue,
//            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
//            APIHeader.kContentType : "application/json"
//        ]
//
//        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//
//            switch response.result {
//            case .success:
//                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString = \(String(describing: responseString))")
//                do {
//                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
//                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
//                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
//                            let currentViewController = UIApplication.topViewController()
//                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
//                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
//                        }
//                        else
//                        {
//
//                            let response = try JSONDecoder().decode(PlayHistorydetails.self, from: response.data!)
//
//                            onSuccess(response)
//                        }
//                    }
//                }
//                catch let error as NSError {
//                    // print(error)
//                    onFailure(error)
//                }
//            case .failure(let error):
//                // print(error)
//                debugPrint(error)
//                onFailure(error)
//
//            }
//        }
//    }
//
//
    func getGuestList(paramater: [String: Any]?, onSuccess: @escaping(GuestList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getGuestList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<GuestList>().map(JSONObject: jsonDict)

                            onSuccess(dashboardDict!)
                        }
                    }
                    else {
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
        }
    }
    
    func getHistory(paramater: [String: Any]?, onSuccess: @escaping(GuestCardsHistoryResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.guestHistory
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //print(response.data!)
                            let response = try JSONDecoder().decode(GuestCardsHistoryResponse.self, from: response.data!)
                            
                            onSuccess(response)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    func cancelGuestCards(paramater: [String: Any]?, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.cancelGestCards
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                                //print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                            DispatchQueue.main.async {
                                self.appDelegate.hideIndicator()
                            }
                            
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!)
                            
                            onSuccess()
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    func getClubNewsDetails(paramater: [String: Any]?, onSuccess: @escaping(ClubNewsDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.clubNewsDetails
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                        
                            let response = Mapper<ClubNewsDetails>().map(JSON: jsonDict)//try JSONDecoder().decode(ClubNewsDetails.self, from: response.data!)
                                                
                            onSuccess(response!)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    
    func getEventCategory(paramater: [String: Any]?, onSuccess: @escaping(EventsCategoryList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getEventCategory
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseStringcategory = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<EventsCategoryList>().map(JSONObject: jsonDict)
                            print("getStatement")
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    func getGolfCalendarCategory(paramater: [String: Any]?, onSuccess: @escaping(EventsCategoryList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getGolfCategory        
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseStringcategory = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<EventsCategoryList>().map(JSONObject: jsonDict)
                            //print("getStatement")
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    func getGlanceCategory(paramater: [String: Any]?, onSuccess: @escaping(TodayAtGlanceCategoryList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getGlanceCategory
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseStringcategory = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<TodayAtGlanceCategoryList>().map(JSONObject: jsonDict)
                            //print("getStatement")
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    func annualPlayHistoryDetails(paramater: [String: Any]?, onSuccess: @escaping(AnualCourtBookingsResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getAnnualPlayHistoryDetails
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(AnualCourtBookingsResponse.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    func teeTimeDetails(paramater: [String: Any]?, onSuccess: @escaping(TeeTimesDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getTeeTimes
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(TeeTimesDetails.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }

    
    func courtTimeDetails(paramater: [String: Any]?, onSuccess: @escaping(CourtTimeDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getCourtTimes
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(CourtTimeDetails.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    
    func diningReservationDetails(paramater: [String: Any]?, onSuccess: @escaping(DiningRS) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getDiningReservations
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(DiningRS.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    func getFitnessSpa(paramater : [String : Any]?, onSuccess : @escaping(FitnessSpaRS) -> Void ,onFailure : @escaping(Error)-> Void )
    {
        let url : String = baseURL + APIHandler.getSpaFitness
        
        let headers : HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in

            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(FitnessSpaRS.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }

        }
    }
    
    func sendUsFeedback(paramater: [String: Any]?, onSuccess: @escaping(SenUsFeedback) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.sendUsFeedBack
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let dashboardDict = Mapper<SenUsFeedback>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    func getGuestValidation(paramater: [String: Any]?, onSuccess: @escaping(SenUsFeedback) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getGuestValidation
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             self.appDelegate.hideIndicator()
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let dashboardDict = Mapper<SenUsFeedback>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    func getAppVersion(paramater: [String: Any]?, onSuccess: @escaping(AppVersion) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getVersion
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            self.appDelegate.hideIndicator()
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(AppVersion.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    func getMemberValidation(paramater: [String: Any]?, onSuccess: @escaping(SenUsFeedback) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getMemberValidation
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) < 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            self.appDelegate.hideIndicator()
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
//                            let response = try JSONDecoder().decode(SenUsFeedback.self, from: response.data!)
//
//                            onSuccess(response)
                            
                            let dashboardDict = Mapper<SenUsFeedback>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
            
        }
    }
   
    func getLeagueUrl(paramater: [String: Any]?, onSuccess: @escaping(LeagueFiles) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getLeagueURL
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            self.appDelegate.hideIndicator()
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(LeagueFiles.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    func registerYourDevice(paramater: [String: Any]?, onSuccess: @escaping(RegisterYourDeviceResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.registerYourDevice
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                            let response = try JSONDecoder().decode(RegisterYourDeviceResponse.self, from: response.data!)
                            
                            onSuccess(response)
                            
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    
    
    func beaconIdentification(paramater: [String: Any]?, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.beacondIdentification
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
                            
                         
                            
                        }
                        
                    }
                    onSuccess()
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    func addOrModifyGuestCard(paramater: [String: Any]?, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.addOrModifyGuestCard
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            self.appDelegate.hideIndicator()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
//                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!)
                            
                            onSuccess()
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
    func requestGuestCard(paramater: [String: Any]?, onSuccess: @escaping(Response) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.requestGuestCard
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kContentType : "application/json",
        ]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = 150
        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers) .responseJSON { (response) in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            self.appDelegate.hideIndicator()

                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!)
                            
                            onSuccess(dashboardDict)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    
//    func alphaDetails(paramater: [String: Any]?, onSuccess: @escaping(AlphaDetails) -> Void, onFailure: @escaping(Error) -> Void) {
//
//
//        let url : String = baseURL + APIHandler.getGetGolfAlphadata
//
//        let headers: HTTPHeaders = [
//            APIHeader.kusername: APIHeader.kusernamevalue,
//            APIHeader.kpassword: APIHeader.kpasswordvalue,
//            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
//            //            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
//            APIHeader.kContentType : "application/json"
//
//        ]
//
//        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
//            switch response.result {
//
//            case.success(let result):
//                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                   print("responseString = \(String(describing: responseString))")
//                do {
//                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
//                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
//                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
//                            self.appDelegate.hideIndicator()
//                            let currentViewController = UIApplication.topViewController()
//                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
//                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
//                        }
//                        else{
//                            let dashboardDict = try JSONDecoder().decode(AlphaDetails.self, from: response.data!)
//                            print(dashboardDict)
//                            onSuccess(dashboardDict)
//                        }
//
//                    }
//                    else {
//                    }
//                }
//                catch let error as NSError {
//                    // print(error)
//                }
//            case .failure(let error):
//                // print(error)
//                onFailure(error)
//            default:
//                print("error")
//            }
//
//        }
//
//
//    }
    
    func alphaDetailsList(paramaterDict: [String: Any]?, onSuccess: @escaping(AlphaDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getGetGolfAlphadata
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                // print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<AlphaDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }

    func getMyGuestList(paramater: [String: Any]?, onSuccess: @escaping(GuestListResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.myGuestList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
//            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            APIHeader.kContentType : "application/json"
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
             //   print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = try JSONDecoder().decode(GuestListResponse.self, from: response.data!)
                            print(dashboardDict)
                            onSuccess(dashboardDict)
                        }
                        
                    }
                    else {
                    }
                }
                catch let error as NSError {
                     //print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    //MARK:- Get Localization
    func getLocalizationData(paramater: [String: Any]?, onSuccess: @escaping(Labelling, String, [String: AnyObject]) -> Void, onFailure: @escaping(Error) -> Void) {

        let url : String = baseURL + APIHandler.getMultiLingualData
       



        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""

        ]
        //print("lang\(headers)")

        Alamofire.request(url, method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response in

            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("localization\(responseString)")
                
                UserDefaults.standard.set(responseString, forKey: UserDefaultsKeys.masterList.rawValue)
                UserDefaults.standard.synchronize()
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDict = Mapper<Labelling>().map(JSONObject: jsonDict)
                        onSuccess(dashboardDict!, responseString! as String,jsonDict)
                    }
                }
                catch let error as NSError {
                    //                   // print(Erro)
                    let errors:Int? = response.response?.statusCode
                    // print(errors)
                                        onFailure(error)
                    //    onFailure(error, response.data!)
                }

            case .failure(let error):
                // print(error)
                debugPrint(error)
                //                onFailure(error)
                //    onFailure(error, response.response!)



            }
        }


    }
    
//    func getLocalizationData(paramater: [String: Any]?, onSuccess: @escaping(Labelling, String, [String: AnyObject]) -> Void, onFailure: @escaping(Error) -> Void) {
//
//        //    let url : String = baseURL + APIHandler.getMultiLingualData
//        let url : String = APIHandler.labelling
//
//
//
//        let headers: HTTPHeaders = [
//            APIHeader.kusername: APIHeader.kusernamevalue,
//            APIHeader.kpassword: APIHeader.kpasswordvalue,
//            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
//            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
//
//        ]
//        print("lang\(headers)")
//
//         Alamofire.request(url).responseJSON { response in
//
//            switch response.result {
//            case .success:
//                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("localization\(responseString)")
//                do {
//                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
//                        let dashboardDict = Mapper<Labelling>().map(JSONObject: jsonDict)
//                        onSuccess(dashboardDict!, responseString! as String,jsonDict)
//                    }
//                }
//                catch let error as NSError {
//                    //                   // print(Erro)
//                    let errors:Int? = response.response?.statusCode
//                    // print(errors)
//                    onFailure(error)
//                    //    onFailure(error, response.data!)
//                }
//
//            case .failure(let error):
//                // print(error)
//                debugPrint(error)
//                //                onFailure(error)
//                //    onFailure(error, response.response!)
//
//
//
//            }
//        }
//
//
//    }
    
    
    
    //MARK:-  Get Auth token
//    func getTokenApi(paramater: [String: Any]?, onSuccess: @escaping(TokenDetails) -> Void, onFailure: @escaping(Error) -> Void) {
//
//        let parameterToken:[String:Any] = [
//            APIKeys.kclient_id: "Cobalt",
//            APIKeys.kclient_secret: "CSSICobalt&BW",
//            APIKeys.kgrant_type: "client_credentials",
//            APIKeys.kscope: "Member"
//        ]
//
//        let url : String = tokenAPI
//
//        Alamofire.request(url, method: .post, parameters: parameterToken, encoding: URLEncoding()).response { response in
//            if(response.response?.statusCode == 200){
//                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                do {
//                    let jsonDic = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as? [String:AnyObject]
//                    let dashboardDict = Mapper<TokenDetails>().map(JSONObject: jsonDic)
//                    onSuccess(dashboardDict!)
//
//                    var time_expire = dashboardDict?.expires_in ?? 1800
//                    time_expire = time_expire - 60
//
//                    if #available(iOS 10.0, *) {
//                        let validtimer = self.appDelegate.authTokenTimer.isValid
//                        if(validtimer == false){
//                            self.appDelegate.authTokenTimer.invalidate()
//
//
//                            self.appDelegate.authTokenTimer = Timer.scheduledTimer(withTimeInterval:Double(time_expire), repeats: true, block: { (timer) in
//                                self.getRefreshedAPIToken()
//                                self.appDelegate.authTokenTimer.invalidate()
//                            })
//                        }
//
//                    }
//
//
//
//                } catch {
//                    print(error as NSError)
//                }
//            }
//            else{
//                onFailure(response.error!)
//            }
//        }
//
//
//
//    }
//
    
    //Mark- Notification Read
    func getNotificationStatus(paramater: [String: Any]?, onSuccess: @escaping(NotificationRead) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.notificationRead
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringnotificationstatus = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<NotificationRead>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                        
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    
    //Mark- Get Restaurant Menu
    func getRestaurentMenus(paramater: [String: Any]?, onSuccess: @escaping(Restaurants) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getRestaurantMenuDetail
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString menu = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<Restaurants>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                        
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    //Mark- Get Download Statements
    func getDownloadStatements(paramater: [String: Any]?, onSuccess: @escaping(DownloadStatement) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getDownloadStatements
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString menu = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<DownloadStatement>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                        
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
//    func getDownloadStatementsFile(paramater: [String: Any]?, onSuccess: @escaping(DownloadStatement) -> Void, onFailure: @escaping(Error) -> Void) {
//
//
//        let url : String = "http://hydcobaltportal.solutionsoftware.com:443/services.test/api/Member/GetStatementFile"
//
//        let headers: HTTPHeaders = [
//            APIHeader.kusername: APIHeader.kusernamevalue,
//            APIHeader.kpassword: APIHeader.kpasswordvalue,
//            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
//            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
//
//        ]
//        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
//            switch response.result {
//            case.success(let result):
//                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                //                print("responseString menu = \(String(describing: responseString))")
//                do {
//                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
//                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
//                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
//                            self.appDelegate.hideIndicator()
//                            let currentViewController = UIApplication.topViewController()
//                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
//                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
//                        }
//                        else{
//                            let dashboardDict = Mapper<DownloadStatement>().map(JSONObject: jsonDict)
//                            onSuccess(dashboardDict!)
//                        }
//
//                    }
//                }
//                catch let error as NSError {
//                    // print(error)
//                }
//            case .failure(let error):
//                // print(error)
//                onFailure(error)
//            default:
//                print("error")
//            }
//
//        }
//
//
//    }
//
//
    //Mark- Get Restaurant Details
    func getRestaurentDetails(paramater: [String: Any]?, onSuccess: @escaping(RestaurentsDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getRestaurantDetail
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString restdetails = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<RestaurentsDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    //MARK:- Get tabbar
    func getTabbar(paramater: [String: Any]?, onSuccess: @escaping(TabbarModel, String) -> Void, onFailure: @escaping(Error) -> Void) {
        let parameterDict:[String:Any] = [
            APIKeys.kMemberId: UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue) ?? "",
            APIKeys.kdeviceInfo: APIHandler.devicedict,
            APIKeys.kID : UserDefaults.standard.string(forKey: UserDefaultsKeys.id.rawValue) ?? "",
            APIKeys.kParentId: UserDefaults.standard.string(forKey: UserDefaultsKeys.parentID.rawValue) ?? "",
            //            id
            //            pare
        ]
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        
        let url : String = baseURL + APIHandler.getIcon
        Alamofire.request(url, method:.post, parameters:parameterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                do {
                    
                    let defaults = UserDefaults.standard
                    defaults.set(responseString, forKey: "getTabbar")
                    defaults.synchronize()
                    
                    let decoded  = defaults.object(forKey: "getTabbar") as! String
                    // print("responseString = \(String(describing: decoded))")
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<TabbarModel>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!, responseString as! String)
                        }
                    }
                }
                catch let error as NSError {
                    //                   // print(Erro)
                    let errors:Int? = response.response?.statusCode
                    // print(errors)
                    //                    onFailure(error)
                    //    onFailure(error, response.data!)
                }
                
            case .failure(let error):
                // print(error)
                debugPrint(error)
                //                onFailure(error)
                //    onFailure(error, response.response!)
                
            }
        }
        
        
    }
    
    
    
    //MARK:- Today at glance
    func getGlanceDetails(paramater: [String: Any]?, onSuccess: @escaping(Glance) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getGlanceDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringglancedetails = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<Glance>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    //MARK:- Notification Details
    func getNotificationDetails(paramater: [String: Any]?, onSuccess: @escaping(NotificationDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getNotificationDetails
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
          //      print("responseStringnotification = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<NotificationDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    //MARK:- get All card Request
    func getAllCardRequests(paramater: [String: Any]?, onSuccess: @escaping(AllGuestCardRequest) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getAllGuestCardRequests
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringall = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<AllGuestCardRequest>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    //MARK:- get Previous statement
    func getPreviosStatement(paramater: [String: Any]?, onSuccess: @escaping(PreviousStatement) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getPreviousStatements
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("getPreviosStatement = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<PreviousStatement>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func getImportantNumbers(paramater: [String: Any]?, onSuccess: @escaping(ImportantNumber) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getGetImportantNumber
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringimpno = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<ImportantNumber>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func getGetGuestCardDetails(paramater: [String: Any]?, onSuccess: @escaping(GuestCardList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getGetGuestCardDetails
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print(responseString)
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<GuestCardList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    
    func getMemberDirectoryList(paramaterDict: [String: Any]?, onSuccess: @escaping(MemberDirectory) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getMemberDirectoryApp
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                // print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MemberDirectory>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    func getMemberList(paramaterDict: [String: Any]?, onSuccess: @escaping(MembersList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getMemberDirectoryApp
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
               // print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MembersList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    func getMemberSpouseList(paramaterDict: [String: Any]?, onSuccess: @escaping(MembersList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getMemberSpouseList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        print(paramaterDict)
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        print(jsonDict)
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MembersList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    func getBuddyList(paramaterDict: [String: Any]?, onSuccess: @escaping(MembersList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getBuddyList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MembersList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func getMyGroupDetails(paramaterDict: [String: Any]?, onSuccess: @escaping(MyGroupDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getMyGroupDetails
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MyGroupDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func getMyGroupsList(paramaterDict: [String: Any]?, onSuccess: @escaping(MyGroupList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getMyGroupsList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MyGroupList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func addToBuddyList(paramaterDict: [String: Any]?, onSuccess: @escaping(MembersList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.addToBuddyList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MembersList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    func saveEventRegistration(paramaterDict: [String: Any]?, onSuccess: @escaping(MembersList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.saveEventRegistration
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MembersList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    func saveTeeTime(paramaterDict: [String: Any]?, onSuccess: @escaping(MembersList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.saveTeeTimeRequest
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) < 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MembersList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    func getGiftCard(paramaterDict: [String: Any]?, onSuccess: @escaping(GiftCard) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        let url : String = baseURL + APIHandler.getGiftCard
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
               //print("responseStringgiftcard = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<GiftCard>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func saveDiningReservationRequest(paramaterDict: [String: Any]?, onSuccess: @escaping(MembersList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.saveDiningRequest
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) < 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MembersList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    func saveCourtRequest(paramaterDict: [String: Any]?, onSuccess: @escaping(MembersList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.saveTennisRequest
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmemberdirect = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) < 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<MembersList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
//    func getGiftCard(paramaterDict: [String: Any]?, onSuccess: @escaping(GiftCard) -> Void, onFailure: @escaping(Error) -> Void) {
//
//
//        let headers: HTTPHeaders = [
//            APIHeader.kusername: APIHeader.kusernamevalue,
//            APIHeader.kpassword: APIHeader.kpasswordvalue,
//            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
//            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
//
//        ]
//
//        let url : String = baseURL + APIHandler.getGiftCard
//        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
//            switch response.result {
//            case.success(let result):
//                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringgiftcard = \(String(describing: responseString))")
//                do {
//                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
//                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
//                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
//                            self.appDelegate.hideIndicator()
//                            let currentViewController = UIApplication.topViewController()
//                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
//                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
//                        }
//                        else{
//                            let dashboardDict = Mapper<GiftCard>().map(JSONObject: jsonDict)
//                            onSuccess(dashboardDict!)
//                        }
//                    }
//                }
//                catch let error as NSError {
//                    // print(error)
//                }
//            case .failure(let error):
//                // print(error)
//                onFailure(error)
//            default:
//                print("error")
//            }
//
//        }
//
//
//    }
    
    
    func getIndividualGuest(paramaterDict: [String: Any]?, onSuccess: @escaping(GuestCardList) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let url : String = baseURL + APIHandler.getMemberDirectoryApp
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                // print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<GuestCardList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    func getStatement(paramater: [String: Any]?, onSuccess: @escaping(StatementCategories) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getStatementCategory
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringcategory = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<StatementCategories>().map(JSONObject: jsonDict)
                            //print("getStatement")
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    func getCurrentStatement(paramater: [String: Any], onSuccess: @escaping(CurrentStatement) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getStatement
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {

            case.success(let result):
                //print("dictData: \(response)")

                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringcurrent = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<CurrentStatement>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    func getStatementDetails(paramater: [String: Any], onSuccess: @escaping(StatementDetails) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.getStatementDetail
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("getStatementDetails:\(responseString)")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<StatementDetails>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
    }
 
    func getDashBoardData(paramaterDict: [String: Any]?, onSuccess: @escaping(Dashboard) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getGetDashboard
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringDash = \(String(describing: responseString))")
                
                //                if(responseString == "")
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            
                            let dashboardDict = Mapper<Dashboard>().map(JSONObject: jsonDict)
                            //print("getDashBoardData")
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    
    func getUserActivity(paramaterDict: [String: Any]?, onSuccess: @escaping(Dashboard) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getUserActivity
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseStringDash = \(String(describing: responseString))")
                
                //                if(responseString == "")
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<Dashboard>().map(JSONObject: jsonDict)
                            //print("getDashBoardData")
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    func getUserLogout(paramaterDict: [String: Any]?, onSuccess: @escaping(Dashboard) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getLogOut
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseStringDash = \(String(describing: responseString))")
                
                //                if(responseString == "")
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<Dashboard>().map(JSONObject: jsonDict)
                            //print("getDashBoardData")
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
        
        
    }
    
    
    func addGuestApi(paramaterDict: [String: Any]?, onSuccess: @escaping(AddGuest) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.addGuest
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper< AddGuest >().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
        
        
    }
    
    
    func resetPasswordApi(paramaterDict: [String: Any]?, onSuccess: @escaping(ResetPassword) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.resetPassword
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        
        ]
        
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                            self.appDelegate.hideIndicator()

                        }
                        else
                        {
                            let dashboardDict = Mapper<ResetPassword>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
        
        
    }
    
    // Change password API
    
    func changePasswordApi(paramaterDict: [String: Any]?, onSuccess: @escaping(ResetPassword) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.changePassword
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        print(paramaterDict)
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                            self.appDelegate.hideIndicator()
                            
                        }
                        else
                        {
                            let dashboardDict = Mapper<ResetPassword>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
    }
    // Save settings API
    func saveSettingsApi(paramaterDict: [String: Any]?, onSuccess: @escaping(ResetPassword) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.saveSettings
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                            self.appDelegate.hideIndicator()
                        }
                        else
                        {
                            let dashboardDict = Mapper<ResetPassword>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
        
        
    }
    
    
    // Get settings API
    
    func getSettingsApi(paramaterDict: [String: Any]?, onSuccess: @escaping(GetSettingsValues) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getSettings
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        print(jsonDict)
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                            self.appDelegate.hideIndicator()
                            
                        }
                        else
                        {
                            let dashboardDict = Mapper<GetSettingsValues>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
        
        
    }
    //MARK:- Modify guest
    func modifyGuestApi(paramaterDict: [String: Any]?, onSuccess: @escaping(GuestDetailsModify) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.saveGuestcard
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper<GuestDetailsModify>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
        
        
    }
    
    
    func requestNewGuestCard(paramaterDict: [String: Any]?, onSuccess: @escaping(GuestCardModify) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.saveGuestcard
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                 print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper<GuestCardModify>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                        
                        
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
        
        
    }
    
    
    
    
    
    func saveMemberInfo(paramaterDict: [String: Any]?, onSuccess: @escaping(SaveMemberInfo) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.SaveMemberInfo
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                // print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + "" + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper<SaveMemberInfo>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                    onFailure(error)
                }
                
                
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
        
        
    }
    
    
    
    //MARK:- Login API
    
    func postAuthenticateUserApi(paramaterDict: [String: Any]?, onSuccess: @escaping(ParentMemberInfo) -> Void, onFailure: @escaping(Error,  HTTPURLResponse) -> Void) {
        
        let url : String = baseURL + APIHandler.postauthenticateUser
        
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:loginheaders).responseJSON { response in
            // print(response.response?.statusCode)
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//               print("responseStringlogin = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper<ParentMemberInfo>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                        
                    }
                    else {
                        // print("error")
                    }
                }
                catch let error as NSError {
                    //                   // print(Erro)
                    let errors:Int? = response.response?.statusCode
                    // print(errors)
                    //                    onFailure(error)
                    onFailure(error, response.response!)
                }
                
            case .failure(let error):
                // print(error)
                debugPrint(error)
                //                onFailure(error)
                onFailure(error, response.response!)
                
                
                
            }
        }
        
        
    }
    
    
    
    func cancelGuestCardApi(paramaterDict: [String: Any]?, onSuccess: @escaping(GuestCardList) -> Void, onFailure: @escaping(Error,  HTTPURLResponse) -> Void) {
        
        let url : String = baseURL + APIHandler.CancelGuestCard
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            // print(response.response?.statusCode)
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                // print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let dashboardDict = Mapper<GuestCardList>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                        
                    }
                }
                catch let error as NSError {
                    //                   // print(Erro)
                    let errors:Int? = response.response?.statusCode
                    // print(errors)
                    //                    onFailure(error)
                    onFailure(error, response.response!)
                }
                
            case .failure(let error):
                // print(error)
                debugPrint(error)
                //                onFailure(error)
                onFailure(error, response.response!)
                
                
                
            }
        }
        
        
    }
    
    
//    func registerYourDevice(paramater: [String: Any]?, onSuccess: @escaping(RegisterYourDeviceResponse) -> Void, onFailure: @escaping(Error) -> Void) {
//        let url : String = baseURL + APIHandler.registerYourDevice
//        
//        let headers: HTTPHeaders = [
//            APIHeader.kusername: APIHeader.kusernamevalue,
//            APIHeader.kpassword: APIHeader.kpasswordvalue,
//            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
//            APIHeader.kContentType : "application/json"
//        ]
//        
//        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//            switch response.result {
//            case .success:
//                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                //                print("responseString = \(String(describing: responseString))")
//                do {
//                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
//                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
//                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
//                            let currentViewController = UIApplication.topViewController()
//                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
//                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
//                        }
//                        else
//                        {
//                            //                            let dashboardDict = try JSONDecoder().decode(Response.self, from: response.data!
//                            
//                            let response = try JSONDecoder().decode(RegisterYourDeviceResponse.self, from: response.data!)
//                            
//                            onSuccess(response)
//                            
//                        }
//                    }
//                }
//                catch let error as NSError {
//                    // print(error)
//                    onFailure(error)
//                }
//            case .failure(let error):
//                // print(error)
//                debugPrint(error)
//                onFailure(error)
//                
//            }
//        }
//    }
    func postForgotPasswordApi(paramaterDict: [String: Any]?, onSuccess: @escaping(ForgotPassword) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.postForgotPassword
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue
        ]
        
        
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            // print(response.response?.statusCode)
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                // print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper<ForgotPassword>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    
                   onFailure(error)
                }
                
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
                
                
            }
        }
        
        
    }
    
    func validateOTPApi(paramaterDict: [String: Any]?, onSuccess: @escaping(ForgotPassword) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.postOTPVerify
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue
        ]
        
        
        Alamofire.request(url, method:.post, parameters:paramaterDict, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            // print(response.response?.statusCode)
            switch response.result {
            case .success:
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                // print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + " " + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper<ForgotPassword>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                    }
                }
                catch let error as NSError {
                    
                    onFailure(error)
                }
                
            case .failure(let error):
                // print(error)
                debugPrint(error)
                onFailure(error)
                
            }
        }
        
        
    }
    
    
    
    func getMemberInfoApi(paramater: [String: Any], onSuccess: @escaping(GetMemberInfo) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getMemberInfo
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("responseStringmeminfo = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<GetMemberInfo>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    
    
    func getMemebrDirectoryInterest(paramater: [String: Any], onSuccess: @escaping(MemberDirectoryInterest) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getInterestsList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<MemberDirectoryInterest>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    
    func getInterest(paramater: [String: Any], onSuccess: @escaping(MyInterest) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getOnlyInterestsList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<MyInterest>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    func getEventDetails(paramater: [String: Any], onSuccess: @escaping(EventDetail) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getEvent
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                //print(response)
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                       print(jsonDict)
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<EventDetail>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    func removeBuddyFromList(paramater: [String: Any], onSuccess: @escaping(EventDetail) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.removeBuddy
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                //print(response)
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<EventDetail>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    func removeMyGroup(paramater: [String: Any], onSuccess: @escaping(EventDetail) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.removeMyGroup
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                //print(response)
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<EventDetail>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    func saveMyGroup(paramater: [String: Any], onSuccess: @escaping(EventDetail) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.saveMyGroup
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                //print(response)
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<EventDetail>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    func getRequestCancel(paramater: [String: Any], onSuccess: @escaping(EventDetail) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.cancelRequest
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                //print(response)
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<EventDetail>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    
    func getEventCancelReservation(paramater: [String: Any], onSuccess: @escaping(EventDetail) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.cancelEvent
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                //print(response)
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //                print("responseString = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let getmemberDict = Mapper<EventDetail>().map(JSONObject: jsonDict)
                            onSuccess(getmemberDict!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    //MARK:- - Master list api
    
    func getMasterList(paramater: [String: Any], onSuccess: @escaping(MemberDirectoryInterest) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url : String = baseURL + APIHandler.getInterestsList
        
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
        
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseStringmasster = \(String(describing: responseString))")
                //print(response)
                //save master list
                
                UserDefaults.standard.set(responseString, forKey: UserDefaultsKeys.masterList.rawValue)
                UserDefaults.standard.synchronize()
                
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let getmemberDict = Mapper<MemberDirectoryInterest>().map(JSONObject: jsonArray)
                        
                        onSuccess(getmemberDict!)
                    }
                    else {
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    
    
    
    
    
    
    //MARK:- Upload Profile picture
    
    func uploadProfilePicture(paramater: [String: Any], onSuccess: @escaping(ProfileUplodSuccessfull) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = baseURL + APIHandler.uploadProfileImage
        let headers: HTTPHeaders = [
            "Content-Type" : "application/x-www-foprm-urlencoded",
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        //print("headers:\(headers)")
        
        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result {
            case.success(let result):
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
              //  print("responseStringprofile = \(String(describing: responseString))")
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)! + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else{
                            let profileDetails = Mapper<ProfileUplodSuccessfull>().map(JSONObject: jsonDict)
                            onSuccess(profileDetails!)
                        }
                    }
                }
                catch let error as NSError {
                    // print(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            default:
                print("error")
            }
            
        }
    }
    
    
    //    func uploadProfilePicture(paramater: [String: Any], onSuccess: @escaping(String) -> Void, onFailure: @escaping(Error) -> Void) {
    //        let url : String = baseURL + APIHandler.uploadProfileImage
    //        let headers: HTTPHeaders = [
    //            APIHeader.kusername: APIHeader.kusernamevalue,
    //            APIHeader.kpassword: APIHeader.kpasswordvalue,
    //            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
    //            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
    //
    //        ]
    //
    //        Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
    //            switch response.result {
    //            case.success(let result):
    //                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
    //                print("responseStringprofile = \(String(describing: responseString))")
    //                do {
    //                    if let jsonArray = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
    //                        print("jsonArray:\(jsonArray)")
    //
    //                        onSuccess(responseString as! String)
    //                    }
    //                    else {
    //                    }
    //                }
    //                catch let error as NSError {
    //                    // print(error)
    //                }
    //            case .failure(let error):
    //                // print(error)
    //                onFailure(error)
    //            default:
    //                print("error")
    //            }
    //
    //        }
    //    }
//    func getRefreshedAPIToken(){
//        APIHandler.sharedInstance.getTokenApi(paramater: nil , onSuccess: { tokenList in
//            let access_token = tokenList.access_token
//            let expires_in = tokenList.expires_in
//            let token_type = tokenList.token_type
//            let jointToken = (token_type ?? "") + " " + (access_token ?? "")
//            UserDefaults.standard.set(access_token, forKey: UserDefaultsKeys.access_token.rawValue)
//            UserDefaults.standard.set(expires_in, forKey: UserDefaultsKeys.expires_in.rawValue)
//            UserDefaults.standard.set(token_type, forKey: UserDefaultsKeys.token_type.rawValue)
//            UserDefaults.standard.set(jointToken, forKey: UserDefaultsKeys.apiauthtoken.rawValue)
//            
//            
//            
//        },onFailure: { error  in
//            
//            
//        })
//    }
//    
    
     //Added by CSSI on 27th May 2020 BMS
     //MARK:- BMS
     func getDepartmentDetails(paramater: [String: Any], onSuccess: @escaping(Departments) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getDepartmentDetails

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(let result):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                         
                         let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                         if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let getmemberDict = Mapper<Departments>().map(JSONObject: jsonDict)
                             onSuccess(getmemberDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)
             default:
                 print("error")
             }
             
         }
     }
     
     
     
     func getProductionClassDetails(paramater: [String: Any], onSuccess: @escaping(ProductionClassDetails) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getProductionClassDetails

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(let result):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                         
                         let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                         if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let getmemberDict = Mapper<ProductionClassDetails>().map(JSONObject: jsonDict)
                             onSuccess(getmemberDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)
             default:
                 print("error")
             }
             
         }
     }
     
     
     
     func getServiceDetails(paramater: [String: Any], onSuccess: @escaping(ServiceDetails) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getServiceDetails

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(let result):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                         
                         let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                         if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let getmemberDict = Mapper<ServiceDetails>().map(JSONObject: jsonDict)
                             onSuccess(getmemberDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)
             default:
                 print("error")
             }
             
         }
     }
     
     func getProviderDetails(paramater: [String: Any], onSuccess: @escaping(ProviderDetails) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getProviderDetails

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(let result):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                         
                         let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                         if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let getmemberDict = Mapper<ProviderDetails>().map(JSONObject: jsonDict)
                             onSuccess(getmemberDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)
             default:
                 print("error")
             }
             
         }
     }
     
     func getAppointmentAvailableTimes(paramater: [String: Any], onSuccess: @escaping(AvailableTimes) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getAppointmentAvailableTime

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(let result):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                         
                         let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                         if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let getmemberDict = Mapper<AvailableTimes>().map(JSONObject: jsonDict)
                             onSuccess(getmemberDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)
             default:
                 print("error")
             }
             
         }
     }
     
     func getAppointmentAvailableDates(paramater: [String: Any], onSuccess: @escaping(AvailableDates) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getAppointmentAvailableDate

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(let result):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
//                         print(jsonDict)
                         let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                         if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let getmemberDict = Mapper<AvailableDates>().map(JSONObject: jsonDict)
                             onSuccess(getmemberDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)
             default:
                 print("error")
             }
             
         }
     }
     
     
     func getAppointmentValidation(paramater: [String: Any], onSuccess: @escaping(SenUsFeedback) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getAppointmentValidation

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(let result):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                         
                         let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                         if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let getmemberDict = Mapper<SenUsFeedback>().map(JSONObject: jsonDict)
                             onSuccess(getmemberDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)
             default:
                print("error")
             }
             
         }
     }
     
     func saveAppointment(paramater: [String: Any], onSuccess: @escaping(SenUsFeedback) -> Void, onFailure: @escaping(Error) -> Void)
      {
          
          let url : String = baseURL + APIHandler.saveAppointment

          let headers: HTTPHeaders = [
              APIHeader.kusername: APIHeader.kusernamevalue,
              APIHeader.kpassword: APIHeader.kpasswordvalue,
              APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
              APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
              
          ]
          
          Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
              switch response.result {
              case.success(let result):
                  
                  do {
                      if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                      {
                          
                          
                          if let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict),(((dashboardDicterror.brokenRules?.fields?.count) ?? 0) > 0 )
                          {
                              self.appDelegate.hideIndicator()
                              let currentViewController = UIApplication.topViewController()
                              let brokenMessage = (dashboardDicterror.brokenRules?.message)!  + (dashboardDicterror.brokenRules?.fields?.joined(separator: ","))!
                              SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                          }
                          else{
                              let getmemberDict = Mapper<SenUsFeedback>().map(JSONObject: jsonDict)
                              onSuccess(getmemberDict!)
                          }
                      }
                  }
                  catch let error as NSError {
                      onFailure(error)
                  }
              case .failure(let error):
                  onFailure(error)
              default:
                print("error")
              }
              
          }
      }
     
     func getAppointment(paramater: [String: Any], onSuccess: @escaping(AppointmentDetails) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getAppointment

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(_):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                     {
                         
                         if let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict),(((dashboardDicterror.brokenRules?.fields?.count) ?? 0) > 0 )
                         {
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror.brokenRules?.message)!  + (dashboardDicterror.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let getmemberDict = Mapper<AppointmentDetails>().map(JSONObject: jsonDict)
                             onSuccess(getmemberDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)
             }
             
         }
     }
     
     
    func cancelAppointment(paramater: [String: Any], onSuccess: @escaping(_ imgPath : String?) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.cancelAppointment

         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramater, encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success(_):
                 
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                     {
                         
                         if let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict),(((dashboardDicterror.brokenRules?.fields?.count) ?? 0) > 0 )
                         {
                             self.appDelegate.hideIndicator()
                             let brokenMessage = (dashboardDicterror.brokenRules?.message)!  + (dashboardDicterror.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:UIApplication.shared.keyWindow?.rootViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else
                         {
                             
                            onSuccess(jsonDict["ImagePath"] as? String)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 onFailure(error)

             }
             
         }
     }
     
     func getAppointmentHistory(paramaterDict: [String: Any]?, onSuccess: @escaping(AppointmentHistory) -> Void, onFailure: @escaping(Error) -> Void)
     {
         
         let url : String = baseURL + APIHandler.getAppointmentHistory
         let headers: HTTPHeaders = [
             APIHeader.kusername: APIHeader.kusernamevalue,
             APIHeader.kpassword: APIHeader.kpasswordvalue,
             APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
             APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
             
         ]
         
         Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
             switch response.result {
             case.success( _):
                 let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                 //print("responseString eventlist= \(String(describing: responseString))")
                 do {
                     if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] {
                         let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                         if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 ){
                             self.appDelegate.hideIndicator()
                             let currentViewController = UIApplication.topViewController()
                             let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                             SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                         }
                         else{
                             let dashboardDict = Mapper<AppointmentHistory>().map(JSONObject: jsonDict)
                             onSuccess(dashboardDict!)
                         }
                     }
                 }
                 catch let error as NSError {
                     onFailure(error)
                 }
             case .failure(let error):
                 // print(error)
                 onFailure(error)
             }
             
         }
         
         
     }

    //Added on 16th October 2020 V2.3
    //MARK:- Fitness App Api methods
    
    func getFitnessActivity(paramaterDict: [String: Any]?, onSuccess: @escaping(FitnessActivities) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.fitnesssActivity
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper<FitnessActivities>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    //Added on 23rd October 2020 V2.4 -- GATHER0000176
    func getFitnessProfile(paramaterDict: [String: Any]?, onSuccess: @escaping(FitnessProfile) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.fitnessProfile
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let dashboardDict = Mapper<FitnessProfile>().map(JSONObject: jsonDict)
                            onSuccess(dashboardDict!)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    //Added on 23rd October 2020 V2.4 -- GATHER0000176
    func saveFitnessProfile(paramaterDict: [String: Any]?, onSuccess: @escaping(APIResponse?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.saveFitnessProfile
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let response = Mapper<APIResponse>().map(JSON: jsonDict)
                            onSuccess(response)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    //Added on 26th October 2020 V2.4 -- GATHER0000176
    func getGoalsAndChallenges(paramaterDict: [String: Any]?, onSuccess: @escaping(FitnessGoalsAndChallance?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getGoalsAndChallenges
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let details = Mapper<FitnessGoalsAndChallance>().map(JSONObject: jsonDict)
                            onSuccess(details)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    
    //Added on 28th October 2020 V2.4 -- GATHER0000176
    func getFitnessCheckin(paramaterDict: [String: Any]?, onSuccess: @escaping(FitnessCheckin?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getFitnessActivityCheckin
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let details = Mapper<FitnessCheckin>().map(JSONObject: jsonDict)
                            onSuccess(details)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    
    //Added on 28th October 2020 V2.4 -- GATHER0000176
    func saveFitnessCheckin(paramaterDict: [String: Any]?, onSuccess: @escaping() -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.saveFitnessActivityCheckin
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
            
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            onSuccess()
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    //Added by kiran -- GATHER0000176
    func getFitnessVideoCategory(paramaterDict: [String: Any]?, onSuccess: @escaping(FitnessVideoCategories?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getFitnessVideoCategory
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let categories = Mapper<FitnessVideoCategories>().map(JSONObject : jsonDict)
                            onSuccess(categories)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    
    //Added by kiran -- GATHER0000176
    func getFitnessVideoPreferences(paramaterDict: [String: Any]?, onSuccess: @escaping(FitnessVideos?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getAudienceVideoPreference
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let videos = Mapper<FitnessVideos>().map(JSONObject : jsonDict)
                            onSuccess(videos)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    
    //Added by kiran -- GATHER0000176
    func saveVideoPreferences(paramaterDict: [String: Any]?, onSuccess: @escaping(APIResponse?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.saveVideoPreference
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let response = Mapper<APIResponse>().map(JSON: jsonDict)
                            onSuccess(response)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    
    //Added by kiran -- GATHER0000176
    func getVideoSubCategories(paramaterDict: [String: Any]?, onSuccess: @escaping(FitnessVideoSubCategoriesResponse?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getVideoSubCategories
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let response = Mapper<FitnessVideoSubCategoriesResponse>().map(JSON: jsonDict)
                            onSuccess(response)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    //MARK:- Covid Rules
    //Added by kiran -- ENGAGE0011226 -- added for Covid rules
    func getCovidRules(paramaterDict: [String: Any]?, onSuccess: @escaping(AlertDetails?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getCovidRules
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let rules = Mapper<AlertDetails>().map(JSONObject : jsonDict)
                            onSuccess(rules)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                // print(error)
                onFailure(error)
            }
            
        }
        
        
    }
    
    
    //Added by kiran V2.8 -- ENGAGE0011784 -- Existing guest API
    //ENGAGE0011784 -- Start
    func getMemberExistingGuestList(paramaterDict: [String: Any]?, onSuccess: @escaping(ExistingGuestList?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getMemberExistingGuestList
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            self.appDelegate.hideIndicator()
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let rules = Mapper<ExistingGuestList>().map(JSONObject : jsonDict)
                            onSuccess(rules)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                onFailure(error)
            }
            
        }
        
        
    }
    //ENGAGE0011784 -- End
    
    //Added by kiran V2.9 -- ENGAGE0011898 -- Added support for GuestCard PDF instead of fetching details from API
    //ENGAGE0011898 -- Start
    func getMobileConfigurations(paramaterDict: [String: Any]?, onSuccess: @escaping(MobileConfig?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getMobileConfigurations
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let rules = Mapper<MobileConfig>().map(JSONObject : jsonDict)
                            onSuccess(rules)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                onFailure(error)
            }
            
        }
        
        
    }
    //ENGAGE0011898 -- End
    
    //Added by kiran V2.9 -- ENGAGE0011722 -- Apple wallet functionality
    //ENGAGE0011722 -- Start
    func getWalletPass(paramaterDict: [String: Any]?, onSuccess: @escaping(WalletPassData?) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let url : String = baseURL + APIHandler.getWalletPass
        let headers: HTTPHeaders = [
            APIHeader.kusername: APIHeader.kusernamevalue,
            APIHeader.kpassword: APIHeader.kpasswordvalue,
            APIHeader.kautherization: UserDefaults.standard.string(forKey: UserDefaultsKeys.apiauthtoken.rawValue) ?? "",
            APIHeader.kculturecode: UserDefaults.standard.string(forKey: UserDefaultsKeys.culturecode.rawValue) ?? ""
        ]
        
        Alamofire.request(url,method:.post, parameters:paramaterDict,encoding: JSONEncoding.default, headers:headers).responseJSON { response  in
            switch response.result
            {
            case.success( _):
                
                do {
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                    {
                        
                        let dashboardDicterror = Mapper<BrokenRulesModel>().map(JSONObject: jsonDict)
                        //Broken rule
                        if(((dashboardDicterror?.brokenRules?.fields?.count) ?? 0) > 0 )
                        {
                            let currentViewController = UIApplication.topViewController()
                            let brokenMessage = (dashboardDicterror?.brokenRules?.message)!  + (dashboardDicterror?.brokenRules?.fields?.joined(separator: ","))!
                            SharedUtlity.sharedHelper().showToast(on:currentViewController?.view, withMeassge:brokenMessage, withDuration: Duration.kMediumDuration)
                        }
                        else
                        {
                            let rules = Mapper<WalletPassData>().map(JSONObject : jsonDict)
                            onSuccess(rules)
                        }
                        
                    }
                    
                }
                catch let error as NSError
                {
                    onFailure(error)
                }
            case .failure(let error):
                onFailure(error)
            }
            
        }
        
        
    }
    //ENGAGE0011722 -- End
    
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    } }


