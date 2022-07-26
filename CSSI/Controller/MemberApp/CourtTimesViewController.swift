//  CourtTimesViewController.swift
//  CSSI
//
//  Created by apple on 11/21/18.
//  Copyright © 2018 yujdesigns. All rights reserved.


import UIKit
import Popover
import Charts

class CourtTimesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    @IBOutlet weak var chartBaseView: UIView!
    @IBOutlet weak var heightInstructionVideos: NSLayoutConstraint!
    @IBOutlet weak var heightInstructionText: NSLayoutConstraint!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var lblAnnualPlayHistory: UILabel!
    @IBOutlet weak var chartScrollView: UIScrollView!
    @IBOutlet weak var heightUpcomingLabel: NSLayoutConstraint!
    @IBOutlet weak var heightUpcomingTop: NSLayoutConstraint!
    @IBOutlet weak var heightUpcomingEvent: NSLayoutConstraint!
    @IBOutlet weak var courtTimeEventsView: UIView!
    @IBOutlet weak var courtTimeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ImpMainView: UIView!
    @IBOutlet weak var viewContactsBase: UIView!
    @IBOutlet weak var viewImpContacts: UIView!
    @IBOutlet weak var imgImpContacts: UIImageView!
    @IBOutlet weak var lblUpComingEvents: UILabel!
    @IBOutlet weak var imgUpcomingEvents: UIImageView!
    @IBOutlet weak var lblCalendarofEvents: UIButton!
    @IBOutlet weak var recentNewsTableview: UITableView!
    @IBOutlet weak var lblRecentNews: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var imgGolfMemberdirectory: UIImageView!
    @IBOutlet weak var lblMemberDirectory: UILabel!
    @IBOutlet weak var lblInstructionalVideos: UILabel!
    @IBOutlet weak var viewGolfMemberDir: UIView!
    @IBOutlet weak var collectionViewIV: UICollectionView!
    @IBOutlet weak var lblMemberNameAndID: UILabel!
    @IBOutlet weak var heightRecentNewsTable: NSLayoutConstraint!
    @IBOutlet weak var btnrules: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnRequestTeeTime: UIButton!
    //Added by Kiran V2.7 -- GATHER0000700 -- Book a lesson changes
    @IBOutlet weak var btnBookALesson: UIButton!
    
    var ClubNewsDetails: CourtTimeDetails? = nil
    var filterPopover: Popover? = nil
    var isUpcomingEventHidded : Bool?
    var tennisSettings : TennisSettings?
    
    var lineChartView: LineChartView!
    var response: AnualCourtBookingsResponse? = nil
    var  months = [String]()
    
    var unitsSold = [Double]()
    var valueColors = [UIColor]()
    var index = 0

    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Added on 4th July 2020 V2.2
    private let accessManager = AccessManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        courtTimeDetails()
        
        
        let tennisMemberView = UITapGestureRecognizer(target: self, action:  #selector(self.tennisMember(sender:)))
        self.viewGolfMemberDir.addGestureRecognizer(tennisMemberView)
        
        let impContacts = UITapGestureRecognizer(target: self, action: #selector(self.importantContacts(sender:)))
        self.viewImpContacts.addGestureRecognizer(impContacts)
        
        let EventsimageView = UITapGestureRecognizer(target: self, action:  #selector(self.upComingEventsCliked(sender:)))
        self.courtTimeEventsView.addGestureRecognizer(EventsimageView)
        
        viewContactsBase.layer.shadowColor = UIColor.black.cgColor
        viewContactsBase.layer.shadowOpacity = 0.16
        viewContactsBase.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewContactsBase.layer.shadowRadius = 4

        
       // lblAnnualPlayHistory.text = self.appDelegate.masterLabeling.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        self.playHistoryDetails()
        self.loadData()
        
        //Added by kiran V2.5 -- ENGAGE0011372 -- Custom method to dismiss screen when left edge swipe.
        //ENGAGE0011372 -- Start
        self.addLeftEdgeSwipeDismissAction()
        //ENGAGE0011372 -- Start
        
        //Added by Kiran V2.7 -- GATHER0000700 -- Book a lesson changes
        //GATHER0000700 - Start
        self.btnBookALesson.isHidden = true
        //GATHER0000700 - End
    }
    
    override func viewWillLayoutSubviews() {
        if (isUpcomingEventHidded == true){
            
            self.heightUpcomingEvent.constant = 0
            self.heightUpcomingLabel.constant = 0
            self.heightUpcomingTop.constant = 0
            heightRecentNewsTable.constant = recentNewsTableview.contentSize.height
            
            if ClubNewsDetails?.instructionalVideos.count == 0{
                lblInstructionalVideos.isHidden = true
                heightInstructionVideos.constant = 0
                heightInstructionText.constant = 0
                self.courtTimeViewHeight.constant = 899 + self.recentNewsTableview.contentSize.height
                
            }else{
                courtTimeViewHeight.constant = 1071 + recentNewsTableview.contentSize.height
            }
            
        }
        else{
            heightRecentNewsTable.constant = recentNewsTableview.contentSize.height
            if ClubNewsDetails?.instructionalVideos.count == 0{
                lblInstructionalVideos.isHidden = true
                heightInstructionVideos.constant = 0
                heightInstructionText.constant = 0
                self.courtTimeViewHeight.constant = 1160 + self.recentNewsTableview.contentSize.height
                
            }else{
                self.courtTimeViewHeight.constant = 1330 + self.recentNewsTableview.contentSize.height
            }
            
        }
    }
    
    func playHistoryDetails(){
        
        if let m = response?.countBooking.map({ (booking) -> String in
            return booking.monthYear
        }) {
            months = m
        }
        
        if let m = response?.countBooking.map({ (booking) -> Double in
            return Double(booking.count)
        }) {
            unitsSold = m
        }
        let frame = CGRect(x: 0, y: 0, width: 310, height: Int(chartScrollView.frame.height))
        
       // chartBaseView.center.x = self.view.center.x
        
        lineChartView = LineChartView(frame: frame)
        chartScrollView.contentSize = frame.size
        
       // chartScrollView.addSubview(chartBaseView)
        chartScrollView.addSubview(lineChartView)
        
        self.lineChartView.delegate = self
        
        self.lineChartView.noDataText = ""
        
        self.lineChartView.backgroundColor = UIColor.clear
        self.chartView.backgroundColor = UIColor(red: 64/255, green: 178/255, blue: 230/255, alpha: 1.0)
        
        loadMonths(at: 0)
        
    }
    func loadMonths(at: Int) {
        if at >= 0,
            at <= months.count - 4 {
            index = at
            let targetMonths = Array(months[index..<(index+4)])
            let targetUnits = Array(unitsSold[index..<(index+4)])
            lineChartView.clear()
            lineChartView.clearValues()
            lineChartView.clearAllViewportJobs()
            lineChartView.resetViewPortOffsets()
            setChartData(dataPoints: targetMonths, values: targetUnits)
        }
    }
    
    func setChartData(dataPoints: [String], values: [Double]) {        // 1 - creating an array of data entries
        var dataEntries: [ChartDataEntry] = []
        
        
        for i in 0 ..< dataPoints.count {
            
            dataEntries.append(ChartDataEntry(x: Double(i), y: values[i]))
            
            valueColors.append(colorPicker(value: values[i]))
            
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: nil)
        lineChartDataSet.axisDependency = .right
        lineChartDataSet.setColor(UIColor.white)
        lineChartDataSet.setCircleColor(UIColor.black) // our circle will be dark red
        
        
        lineChartView.xAxis.labelFont = UIFont(name:"Helvetica Neue", size: 14.0)!
        lineChartView.xAxis.labelTextColor = UIColor.white
        
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 4.2 // the radius of the node circle
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fillColor = UIColor.white
        lineChartDataSet.highlightColor = UIColor.white
        lineChartDataSet.drawCircleHoleEnabled = true
        lineChartDataSet.circleHoleColor = UIColor.white
        //        lineChartDataSet.circleColors[1] = UIColor.red
        lineChartDataSet.valueFont = UIFont(name:"Helvetica Neue", size: 12.0)!
        lineChartDataSet.valueTextColor = UIColor.white
        
        lineChartDataSet.formLineDashLengths = [5.0, 12.5]
        var dataSets = [LineChartDataSet]()
        
        dataSets.append(lineChartDataSet)
        
        let lineChartData = LineChartData(dataSets: dataSets)
        
        lineChartView.data = lineChartData
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        lineChartData.setValueFormatter(formatter)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelPosition = .top
        lineChartView.isUserInteractionEnabled = false

        
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.avoidFirstLastClippingEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        
        
        
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        
        lineChartView.xAxis.avoidFirstLastClippingEnabled = false
        lineChartView.xAxis.yOffset = 40.0
        lineChartView.setViewPortOffsets(left: 40, top: 60, right: 40, bottom: 0)
    }
    
    func colorPicker(value : Double) -> UIColor {
        
        //input your own logic for how you actually want to color the x axis
        
        return UIColor.red
        
    }
    
    func loadData() {
        if let responseFileURL = Bundle.main.url(forResource: "document", withExtension: "json"),
            let responseData = try? Data(contentsOf: responseFileURL) {
            do {
                response = try JSONDecoder().decode(AnualCourtBookingsResponse.self, from: responseData)
            }
            catch(let error) {
                //commented by kiran V3.0
                //print(error)
            }
        }
        
        self.appDelegate.showIndicator(withTitle: "", intoView: self.view)
        
        let params: [String : Any] = [
            APIKeys.kMemberId : UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)!,
            APIKeys.kdeviceInfo: [APIHandler.devicedict],
            APIKeys.kParentId: UserDefaults.standard.string(forKey: UserDefaultsKeys.parentID.rawValue)!,
            APIKeys.kID : UserDefaults.standard.string(forKey: UserDefaultsKeys.id.rawValue)!,
            APIKeys.kCategory : "Tennis"
        ]
        
        APIHandler.sharedInstance.annualPlayHistoryDetails(paramater: params, onSuccess: { (AnnualPlayresponse) in
            
            self.response = AnnualPlayresponse
            self.playHistoryDetails()
            self.appDelegate.hideIndicator()
            
        }) { (error) in
            SharedUtlity.sharedHelper().showToast(on:self.view, withMeassge:error.localizedDescription, withDuration: Duration.kMediumDuration)
            self.appDelegate.hideIndicator()
            
        }
        
        
        
    }
    @IBAction func previousClicked(_ sender: Any) {
        loadMonths(at: index - 1)
        
    }
    @IBAction func nextClicked(_ sender: Any) {
        loadMonths(at: index + 1)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        initController()
        self.navigationItem.title = self.appDelegate.masterLabeling.court_times ?? "" as String
        self.lblRecentNews.text = self.appDelegate.masterLabeling.recent_news ?? "" as String
        self.lblInstructionalVideos.text = self.appDelegate.masterLabeling.instructional_videos ?? "" as String
        self.lblUpComingEvents.text = self.appDelegate.masterLabeling.upcoming_tennis_events ?? "" as String
        lblCalendarofEvents .setTitle(self.appDelegate.masterLabeling.calendar_title, for: .normal)
        btnrules .setTitle(self.appDelegate.masterLabeling.rules_etiquettes, for: .normal)
        btnViewAll .setTitle(self.appDelegate.masterLabeling.vIEW_ALL, for: .normal)
        self.appDelegate.dateSortToDate = ""
        self.appDelegate.dateSortFromDate = ""
        //NOTE:- Removed as its causing the below issue
        //after going to calendar and swiped right(not completely) to dismiss and let go without dismissing then the titles of the screen is changing to golf even when going from tennis / dining.
        //self.appDelegate.typeOfCalendar = ""


        self.navigationController?.navigationBar.isHidden = false
        
        //Added by kiran V2.5 11/30 -- ENGAGE0011297 -- Removing back button menus
        //ENGAGE0011297 -- Start
        self.navigationItem.leftBarButtonItem = self.navBackBtnItem(target: self, action: #selector(self.backBtnAction(sender:)))
        //ENGAGE0011297 -- End
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Commented by kiran V2.5 11/30 -- ENGAGE0011297 --
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
   
    
    func initController(){
        
        self.lblCalendarofEvents.layer.borderWidth = 1
        self.lblCalendarofEvents.layer.borderColor = hexStringToUIColor(hex: "F06C42").cgColor
        self.btnViewAll.layer.borderWidth = 1
        self.btnViewAll.layer.borderColor = hexStringToUIColor(hex: "F06C42").cgColor
        
        self.btnRequestTeeTime.layer.cornerRadius = 18
        self.btnRequestTeeTime.layer.borderWidth = 1
        self.btnRequestTeeTime.layer.borderColor = hexStringToUIColor(hex: "F06C42").cgColor
        self.btnRequestTeeTime.setTitle(self.appDelegate.masterLabeling.rEQUEST_COURT, for: UIControlState.normal)
        
        imgUpcomingEvents.layer.cornerRadius = 30
        imgUpcomingEvents.layer.borderWidth = 1
        imgUpcomingEvents.layer.masksToBounds = true
        imgUpcomingEvents.layer.borderColor = hexStringToUIColor(hex: "a7a7a7").cgColor
        
        recentNewsTableview.layer.shadowColor = UIColor.black.cgColor
        recentNewsTableview.layer.shadowOpacity = 0.16
        recentNewsTableview.layer.masksToBounds = false
        
        recentNewsTableview.layer.shadowOffset = CGSize.zero
        recentNewsTableview.layer.shadowRadius = 2
        
        self.lblMemberNameAndID.text = String(format: "%@ | %@", UserDefaults.standard.string(forKey: UserDefaultsKeys.fullName.rawValue)!, self.appDelegate.masterLabeling.hASH! + UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)!)

        ImpMainView.layer.shadowColor = UIColor.lightGray.cgColor
        ImpMainView.layer.shadowOpacity = 1.0
        ImpMainView.layer.shadowOffset = CGSize(width: 2, height: 2)
        ImpMainView.layer.shadowRadius = 4
        
        //Added by Kiran V2.7 -- GATHER0000700 -- Book a lesson changes
        //GATHER0000700 - Start
        
        let hideBookLessonBtn = !(DataManager.shared.enableTennisLesson == "1")//(!(DataManager.shared.enableTennisLesson == "1") || self.accessManager.accessPermision(for: .tennisBookALesson) == .notAllowed)
        self.btnBookALesson.isHidden = hideBookLessonBtn
        self.btnBookALesson.setStyle(style: .outlined, type: .primary, cornerRadius: 18)
        self.btnBookALesson.layer.borderWidth = 1.0
        self.btnBookALesson.titleLabel?.font = AppFonts.semibold22
        self.btnBookALesson.setTitle(self.appDelegate.masterLabeling.TL_ButtonText ?? "", for: .normal)
        //GATHER0000700 - End
        
    }
    
    @objc func tennisMember(sender : UITapGestureRecognizer)
    {
        
        //Added on 17th July 2020 V2.2
        //Added for roles adn privilages
        switch self.accessManager.accessPermision(for: .memberDirectory)
        {
        case .notAllowed:
            
            if let message = self.appDelegate.masterLabeling.role_Validation1 , message.count > 0
            {
                SharedUtlity.sharedHelper()?.showToast(on: self.view, withMeassge: message, withDuration: Duration.kMediumDuration)
            }
            return
        default:
            break
        }
        
        if let tennisMemberDirectory = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MemberDirectoryViewController") as? MemberDirectoryViewController {
            tennisMemberDirectory.isFrom = "CourtTimes"
            tennisMemberDirectory.isFromDashBoard = true

            self.navigationController?.pushViewController(tennisMemberDirectory, animated: true)
        }
        
    }
    
    //Added by kiran V2.5 11/30 -- ENGAGE0011297 --
    @objc private func backBtnAction(sender : UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func importantContacts(sender : UITapGestureRecognizer) {

        if let impVC = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "ImpotantContactsVC") as? ImpotantContactsVC {
            impVC.isFrom = "CourtTimes"
            impVC.importantContactsDisplayName = self.ClubNewsDetails?.importantContacts[0].displayName ?? ""
            
            impVC.modalTransitionStyle   = .crossDissolve;
            impVC.modalPresentationStyle = .overCurrentContext
            self.present(impVC, animated: true, completion: nil)
        }
    }
    
    @objc func upComingEventsCliked(sender : UITapGestureRecognizer) {
        if let clubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "ViewNewsViewController") as? ViewNewsViewController {
            clubNews.modalTransitionStyle   = .crossDissolve;
            clubNews.modalPresentationStyle = .overCurrentContext
            clubNews.isFrom = "Events"

            if (self.ClubNewsDetails?.upComingEvent.count != 0)
            {
                //Added on 14th May 2020  v2.1
                //clubNews.imgURl = self.ClubNewsDetails?.upComingEvent[0].image
                let mediaDetail = MediaDetails.init()
                mediaDetail.newsImage = self.ClubNewsDetails?.upComingEvent[0].image ?? ""
                mediaDetail.type = .image
                clubNews.arrMediaDetails = [mediaDetail]
                
                //Old logic
                //clubNews.arrImgURl = [["NewsImage" : self.ClubNewsDetails?.upComingEvent[0].image ?? ""]]
                //Added on 19th May 2020  v2.1
                clubNews.contentType = .image
                self.present(clubNews, animated: true, completion: nil)

            }
            else{
//                clubNews.imgURl = nil
            }
        }
    }
    
    //Commented by kiran V2.5 -- ENGAGE0011419 -- Using string extension instead
    //ENGAGE0011419 -- Start
//    func verifyUrl(urlString: String?) -> Bool {
//        if let urlString = urlString {
//            if let url = URL(string: urlString) {
//                return UIApplication.shared.canOpenURL(url)
//            }
//        }
//        return false
//    }
    //ENGAGE0011419 -- Start
    
    //MARK:- Get Court Details  Api

    func courtTimeDetails() {
        
        self.appDelegate.showIndicator(withTitle: "", intoView: self.view)
        
        let params: [String : Any] = [
            APIKeys.kMemberId : UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)!,
            APIKeys.kdeviceInfo: [APIHandler.devicedict],
            APIKeys.kParentId: UserDefaults.standard.string(forKey: UserDefaultsKeys.parentID.rawValue)!,
            APIKeys.kID : UserDefaults.standard.string(forKey: UserDefaultsKeys.id.rawValue)!,
            
            ]
        
        APIHandler.sharedInstance.courtTimeDetails(paramater: params, onSuccess: { (response) in
            
            self.ClubNewsDetails = response
            
            let placeHolderImage = UIImage(named: "Icon-App-40x40")
            if (self.ClubNewsDetails?.upComingEvent.count != 0)
            {
                //Modified by kiran V2.5 -- ENGAGE0011419 -- Using string extension instead to verify the url
                //ENGAGE0011419 -- Start
                let imageURLString2 = self.ClubNewsDetails?.upComingEvent[0].imgthumb ?? ""
                
                if imageURLString2.isValidURL()
                {
                    self.isUpcomingEventHidded = false
                    if (UserDefaults.standard.string(forKey: UserDefaultsKeys.shareUrl.rawValue) == "1")
                    {
                    
                    }
                    else
                    {
                    
                    }
                    let url = URL.init(string:imageURLString2)
                    self.imgUpcomingEvents.sd_setImage(with: url , placeholderImage: placeHolderImage)
                    self.appDelegate.hideIndicator()

                }
                else
                {
                    self.isUpcomingEventHidded = true
                    self.lblUpComingEvents.isHidden = true
                }
                
                /*
                if(imageURLString2 != nil)
                {
                    let validUrl = self.verifyUrl(urlString: imageURLString2)
                    if(validUrl == true)
                    {
                        self.isUpcomingEventHidded = false
                        if (UserDefaults.standard.string(forKey: UserDefaultsKeys.shareUrl.rawValue) == "1")
                        {
                        
                        }
                        else
                        {
                        
                        }
                        let url = URL.init(string:imageURLString2!)
                        self.imgUpcomingEvents.sd_setImage(with: url , placeholderImage: placeHolderImage)
                        self.appDelegate.hideIndicator()

                    }
                    else
                    {
                        self.isUpcomingEventHidded = true
                        self.lblUpComingEvents.isHidden = true

                    }
                }
                */
                //ENGAGE0011419 -- End
                
            }
            else
            {
                //   let url = URL.init(string:imageURLString)
                self.isUpcomingEventHidded = true
                self.lblUpComingEvents.isHidden = true

            }
            
            
            if self.ClubNewsDetails?.instructionalVideos.count == 0
            {
                self.collectionViewIV.setEmptyMessage(InternetMessge.kNoData)
            }
            
            if (self.ClubNewsDetails?.memberDirectory.count != 0)
            {
                self.lblMemberDirectory.text = self.ClubNewsDetails?.memberDirectory[0].displayName
            
                //Modified by kiran V2.5 -- ENGAGE0011419 -- Using string extension instead to verify the url
                //ENGAGE0011419 -- Start
                let imageURLString = self.ClubNewsDetails?.memberDirectory[0].icon2X ?? ""
                
                if imageURLString.isValidURL()
                {
                    let url = URL.init(string:imageURLString)
                    self.imgGolfMemberdirectory.sd_setImage(with: url , placeholderImage: placeHolderImage)
                    self.appDelegate.hideIndicator()
                }
                /*
                if(imageURLString != nil)
                {
                    let validUrl = self.verifyUrl(urlString: imageURLString)
                    if(validUrl == true)
                    {
                        let url = URL.init(string:imageURLString!)
                        self.imgGolfMemberdirectory.sd_setImage(with: url , placeholderImage: placeHolderImage)
                        self.appDelegate.hideIndicator()

                    }
                    
                }
                */
                //ENGAGE0011419 -- End
                
            }
            
            self.recentNewsTableview.reloadData()
            self.collectionViewIV.reloadData()
            
            
        }) { (error) in
            SharedUtlity.sharedHelper().showToast(on:self.view, withMeassge:error.localizedDescription, withDuration: Duration.kMediumDuration)
            self.appDelegate.hideIndicator()
            
        }
        
        
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        if let share = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "ShareViewController") as? ShareViewController {
            share.modalTransitionStyle   = .crossDissolve;
            share.modalPresentationStyle = .overCurrentContext
            //old logic
            //share.imgURl = self.ClubNewsDetails?.upComingEvent[0].imgthumb
            //share.isFrom = "Events"
            //Added on 19th May 2020 v2.1
            share.contentType = .events
            share.contentDetails = ContentDetails.init(id: self.ClubNewsDetails?.upComingEvent[0].imgthumb, date: nil, name: nil, link: self.ClubNewsDetails?.upComingEvent[0].imgthumb)
            self.present(share, animated: true, completion: nil)
        }
    }
    @IBAction func viewAllClicked(_ sender: Any) {
        
        if let allClubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "AllClubNewsViewController") as? AllClubNewsViewController {
            allClubNews.isFrom = "CourtTimes"
            self.navigationController?.pushViewController(allClubNews, animated: true)
            
        }
        
    }
    @IBAction func calendarOfEventsClicked(_ sender: Any)
    {
        
        if let calendar = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "GolfCalendarVC") as? GolfCalendarVC
        {
            self.appDelegate.buddyType = "First"
            
            self.appDelegate.typeOfCalendar = "Tennis"
            self.navigationController?.pushViewController(calendar, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return  ClubNewsDetails?.clubNews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:RecentNewsCustomCell = tableView.dequeueReusableCell(withIdentifier: "RecentNewsID") as! RecentNewsCustomCell
        
        if let recentNews = ClubNewsDetails?.clubNews[indexPath.row]
        {
            cell.lblNews.text = recentNews.newsTitle
            cell.lblNewsDate.text = recentNews.date
        }
        
        if (isUpcomingEventHidded == true){
            self.lblUpComingEvents.isHidden = true

            
            self.heightUpcomingEvent.constant = 0
            self.heightUpcomingLabel.constant = 0
            self.heightUpcomingTop.constant = 0

            heightRecentNewsTable.constant = recentNewsTableview.contentSize.height

            courtTimeViewHeight.constant = 1071 + recentNewsTableview.contentSize.height
        }
        else{
            self.lblUpComingEvents.isHidden = false

            heightRecentNewsTable.constant = recentNewsTableview.contentSize.height
            courtTimeViewHeight.constant = 1353 + recentNewsTableview.contentSize.height
        }
        self.view.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
//        if let clubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "ClubNewsDetailsViewController") as? ClubNewsDetailsViewController {
//
//            clubNews.newsDescription = ClubNewsDetails?.clubNews[indexPath.row].description as NSString?
//            clubNews.imgURl = ClubNewsDetails?.clubNews[indexPath.row].newsImage as NSString?
//
//            self.navigationController?.pushViewController(clubNews, animated: true)
//
//        }
        //Added on 14th May 2020  v2.1
        if let clubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "ViewNewsViewController") as? ViewNewsViewController
        {
            clubNews.modalTransitionStyle   = .crossDissolve;
            clubNews.modalPresentationStyle = .overCurrentContext
            clubNews.arrMediaDetails = self.appDelegate.imageDataToMediaDetails(list: ClubNewsDetails?.clubNews[indexPath.row].newsImageList)
            //Added on 19th May 2020  v2.1
            clubNews.contentType = .clubNews
            clubNews.contentDetails = ContentDetails.init(id: ClubNewsDetails?.clubNews[indexPath.row].id, date: ClubNewsDetails?.clubNews[indexPath.row].date, name: ClubNewsDetails?.clubNews[indexPath.row].newsTitle, link: nil)
            self.present(clubNews, animated: true, completion: nil)
        }
        
        
        //Old Logic
        /*
        if  (ClubNewsDetails?.clubNews[indexPath.row].newsVideoURL == "")
        {
            if let clubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "ViewNewsViewController") as? ViewNewsViewController
            {
                clubNews.modalTransitionStyle   = .crossDissolve;
                clubNews.modalPresentationStyle = .overCurrentContext
                //clubNews.imgURl = ClubNewsDetails?.clubNews[indexPath.row].newsImage
                
                clubNews.arrImgURl = self.appDelegate.imageDataToDict(list: ClubNewsDetails?.clubNews[indexPath.row].newsImageList)
                self.present(clubNews, animated: true, completion: nil)
            }
            
        }
        else
        {
 
            if let clubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController {
                clubNews.modalTransitionStyle   = .crossDissolve;
                clubNews.modalPresentationStyle = .overCurrentContext
                clubNews.videoURL = ClubNewsDetails?.clubNews[indexPath.row].newsVideoURL.videoID
                
                self.present(clubNews, animated: true, completion: nil)
            }
            
        }
        
        */
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ClubNewsDetails?.instructionalVideos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath as IndexPath) as! CustomDashBoardCell
        
        
        if let instructionalVideos = ClubNewsDetails?.instructionalVideos[indexPath.row]
        {
            cell.videoWkWebview.scrollView.isScrollEnabled = false
            cell.imgInstructionalVideos.isHidden = true

            let videoURL = instructionalVideos.videoURL
            if videoURL != nil || videoURL == ""{
                let url = URL (string: ("https://player.vimeo.com/video/") + (videoURL.videoID ?? ""))
                let requestObj = URLRequest(url: url!)
                cell.videoWkWebview.load(requestObj)
            }else{
                let url = URL (string: ("https://player.vimeo.com/video/"))
                let requestObj = URLRequest(url: url!)
                cell.videoWkWebview.load(requestObj)
            }
         //   cell.imgInstructionalVideos.image = UIImage(named: "Group 1429")!

//            let placeholder:UIImage = UIImage(named: "Icon-App-40x40")!
//            
//            let imageURLString = instructionalVideos.imageThumbnail
//            if(imageURLString != nil){
//                let validUrl = self.verifyUrl(urlString: imageURLString)
//                if(validUrl == true){
//                    let url = URL.init(string:imageURLString)
//                    cell.imgInstructionalVideos.sd_setImage(with: url , placeholderImage: placeholder)
//                }
//            }
//            else{
//                //   let url = URL.init(string:imageURLString)
//                cell.imgImageView.image = UIImage(named: "")!
//            }
            //  self.collectionViewHeight.constant = self.dashBoardCollectionView.contentSize.height;
            //Added by kiran V3.0 -- ENGAGE0012360 -- fixes the issue where video playes automitically with the app is left idle for 1+hrs
            //ENGAGE0012360 -- Start
            cell.videoWkWebview.configuration.mediaTypesRequiringUserActionForPlayback = [.audio,.video]
            //ENGAGE0012360 -- End
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    func requestReservationApi() {
        
        self.appDelegate.showIndicator(withTitle: "", intoView: self.view)
        
        let paramaterDict: [String : Any] = [
            APIKeys.kMemberId : UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)!,
            APIKeys.kdeviceInfo: [APIHandler.devicedict],
            APIKeys.kParentId: UserDefaults.standard.string(forKey: UserDefaultsKeys.parentID.rawValue)!,
            APIKeys.kID : UserDefaults.standard.string(forKey: UserDefaultsKeys.id.rawValue)!,
            "UserName": UserDefaults.standard.string(forKey: UserDefaultsKeys.username.rawValue)!,
            "IsAdmin": UserDefaults.standard.string(forKey: UserDefaultsKeys.isAdmin.rawValue)!
        ]
        
        APIHandler.sharedInstance.getReservationSettings(paramater: paramaterDict , onSuccess: { response in
            
            
            
            self.appDelegate.arrGolfSettings = response.golfSettings
            self.appDelegate.arrTennisSettings = response.tennisSettings
            self.appDelegate.arrDiningSettings = response.dinningSettings
            
            self.gotoCourtRequest()
            
        }) { (error) in
            SharedUtlity.sharedHelper().showToast(on:self.view, withMeassge:error.localizedDescription, withDuration: Duration.kMediumDuration)
            self.gotoCourtRequest()
            self.appDelegate.hideIndicator()
            
        }
    }
    
    @IBAction func requestTeeTimeClicked(_ sender: Any)
    {
        
        self.requestReservationApi()
    }
    
    //Added by Kiran V2.7 -- GATHER0000700 -- Book a lesson changes
    //GATHER0000700 - Start
    @IBAction func bookALessonClicked(_ sender: UIButton)
    {
        self.getDepartmentDetails()
    }
    //GATHER0000700 -- End
    
    func gotoCourtRequest(){
        if let impVC = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "CourtRequestVC") as? CourtRequestVC {
            
            //impVC.tennisSettings = self.tennisSettings
            
            self.navigationController?.pushViewController(impVC, animated: true)
            
        }
        
    }
    @IBAction func RulesClicked(_ sender: Any) {
        
        let restarantpdfDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDfViewController") as! PDfViewController
        if self.ClubNewsDetails?.rulesEtiquette.count == 0 {
            restarantpdfDetailsVC.pdfUrl = ""
            restarantpdfDetailsVC.restarantName =  self.appDelegate.masterLabeling.rules_etiquettes!
            
        }else{
            restarantpdfDetailsVC.pdfUrl = (self.ClubNewsDetails?.rulesEtiquette[0].URL) ?? ""
            restarantpdfDetailsVC.restarantName = (self.ClubNewsDetails?.rulesEtiquette[0].title) ?? ""
        }
        
        
//        restarantpdfDetailsVC.pdfUrl = (self.ClubNewsDetails?.rulesEtiquette[0].URL)!
//        restarantpdfDetailsVC.restarantName = (self.ClubNewsDetails?.rulesEtiquette[0].title)!
        self.navigationController?.pushViewController(restarantpdfDetailsVC, animated: true)
    }
}
extension CourtTimesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let edgeInsets = (view.frame.size.width/2) - 91
        
        if ClubNewsDetails?.instructionalVideos.count == 1 {
            
            return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
        }else{
            return UIEdgeInsetsMake(0, 0, 0, 0)
            
        }
        
    }
    
}

//MARK:- Api Methods
//Added by Kiran V2.7 -- GATHER0000700 -- Book a lesson changes
//GATHER0000700 - Start
extension CourtTimesViewController
{
    private func getDepartmentDetails()
    {
        guard Network.reachability?.isReachable == true else {
            CustomFunctions.shared.showToast(WithMessage: InternetMessge.kInternet_not_available, on: self.view)
            return
            
        }
        
        let paramaterDict:[String: Any] = [
            "Content-Type":"application/json",
            APIKeys.kMemberId : UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)!,
            APIKeys.kParentId: UserDefaults.standard.string(forKey: UserDefaultsKeys.parentID.rawValue)!,
            APIKeys.kid: UserDefaults.standard.string(forKey: UserDefaultsKeys.id.rawValue)!,
            APIKeys.kdeviceInfo: [APIHandler.devicedict],
            APIKeys.kAppointmentDetailID : self.appDelegate.bookingAppointmentDetails.appointmentID ?? "",
            APIKeys.kDepartment : BMSDepartment.tennisBookALesson.rawValue
        ]
        
        CustomFunctions.shared.showActivityIndicator(withTitle: "", intoView: self.view)
        APIHandler.sharedInstance.getDepartmentDetails(paramater: paramaterDict, onSuccess: { [weak self] (departments) in
           
            if let department = (departments.departmentsDetails ?? [DepartmentDetails]()).first
            {
                self?.appDelegate.bookingAppointmentDetails = BMSAppointmentDetails()
                self?.appDelegate.bookingAppointmentDetails.requestScreenType = .request
                self?.appDelegate.bookingAppointmentDetails.department = department
                self?.appDelegate.BMSOrder.removeAll()
                self?.appDelegate.BMSOrder.append(contentsOf: department.appointmentFlow!)
                self?.StartBookingFlow()
            }
            
            CustomFunctions.shared.hideActivityIndicator()
        }) { [weak self] (error) in
            CustomFunctions.shared.handleRequestError(error: error, ShowToastOn: self?.view)
        }
        
        
    }
}

//MARK:- Custom methods
extension CourtTimesViewController
{
    private func StartBookingFlow()
    {
        
        switch self.appDelegate.BMSOrder.first?.contentType ?? .none
        {
        case .services , .providers , .departments:
            
            guard let vc = UIStoryboard.init(name: "MemberApp", bundle: nil).instantiateViewController(withIdentifier: "FitnessRequestListingViewController") as? FitnessRequestListingViewController else {
                return
            }
            
            vc.contentType = (self.appDelegate.BMSOrder.first?.contentType)!
            //Added by Kiran V2.7 -- GATHER0000700 - Book a lesson changes
            //GATHER0000700 - Start
            vc.BMSBookingDepartment = .tennisBookALesson
            //GATHER0000700 - End
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .serviceType:
            
             guard let serviceTypeVC = UIStoryboard.init(name: "MemberApp", bundle: nil).instantiateViewController(withIdentifier: "ServiceTypeViewController") as? ServiceTypeViewController else{return}
            
            //Added by Kiran V2.7 -- GATHER0000700 - Book a lesson changes
            //GATHER0000700 - Start
            serviceTypeVC.BMSBookingDepartment = .tennisBookALesson
            //GATHER0000700 - End
            serviceTypeVC.modalPresentationStyle = .fullScreen
                       
            self.navigationController?.pushViewController(serviceTypeVC, animated: true)
            
        case .requestScreen:
            
            guard let requestVC = UIStoryboard.init(name: "MemberApp", bundle: nil).instantiateViewController(withIdentifier: "SpaAndFitnessRequestVC") as? SpaAndFitnessRequestVC else {
                return
                
            }
            
            requestVC.requestType = self.appDelegate.bookingAppointmentDetails.requestScreenType
            //Added by Kiran V2.7 -- GATHER0000700 - Book a lesson changes
            //GATHER0000700 - Start
            requestVC.BMSBookingDepartment = .tennisBookALesson
            //GATHER0000700 - End
            requestVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(requestVC, animated: true)
            
        case .none:
            break
            
        }
    }
}
//GATHER0000700 - End
