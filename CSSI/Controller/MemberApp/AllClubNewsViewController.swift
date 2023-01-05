//  AllClubNewsViewController.swift
//  CSSI
//  Created by apple on 10/31/18.
//  Copyright © 2018 yujdesigns. All rights reserved.


import UIKit
import ScrollableSegmentedControl
import Popover

class AllClubNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var newsSearchBar: UISearchBar!
    @IBOutlet weak var uiSegmentView: UIView!
    @IBOutlet weak var segmentMainView: UIView!
    
    
    @IBOutlet weak var allNewsTableview: UITableView!
    var arrEventCategory = [ListEventCategory]()
    var segmentedController = ScrollableSegmentedControl()
    var eventCategory: NSString!
    var filterPopover: Popover? = nil
    var isFrom : NSString!

    var arrClubNews = [ClubNews]()
    var clubNewsDetailsList: ClubNewsDetails? = nil
    var filterByDepartment : String!
    var filterByDate : String!
    var filterBy : String!

    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        allNewsTableview.estimatedRowHeight = 52
        allNewsTableview.rowHeight = UITableViewAutomaticDimension

        allNewsTableview.estimatedSectionHeaderHeight = 47
        
        self.navigationController?.navigationBar.isHidden = false

        // Do any additional setup after loading the view.
        self.getEventCategoriesApi(strSearch : "")

        
        newsSearchBar.searchBarStyle = .default
        
        newsSearchBar.layer.borderWidth = 1
        newsSearchBar.layer.borderColor = hexStringToUIColor(hex: "F5F5F5").cgColor

        
        let textAttributes = [NSAttributedStringKey.foregroundColor:APPColor.navigationColor.navigationitemcolor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = self.appDelegate.masterLabeling.recent_news ?? "" as String
        newsSearchBar.placeholder = self.appDelegate.masterLabeling.search_News ?? "" as String
        
        segmentMainView.layer.shadowColor = UIColor.lightGray.cgColor
        segmentMainView.layer.shadowOpacity = 1.0
        segmentMainView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        segmentMainView.layer.shadowRadius = 1.0
        segmentMainView.layer.masksToBounds = false

        


//        let filterBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Filter"), style: .plain, target: self, action: #selector(onTapFilter))
//        navigationItem.rightBarButtonItem = filterBarButtonItem
        navigationItem.rightBarButtonItem = self.navFilterBtnItem(target: self, action: #selector(self.onTapFilter))

        //Added by kiran V2.5 -- ENGAGE0011372 -- Custom method to dismiss screen when left edge swipe.
        //ENGAGE0011372 -- Start
        self.addLeftEdgeSwipeDismissAction()
        //ENGAGE0011372 -- Start
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.isAppAlreadyLaunchedOnce()
        
        //Added by kiran V2.5 11/30 -- ENGAGE0011297 -- Removing back button menus
        //ENGAGE0011297 -- Start
        self.navigationItem.leftBarButtonItem = self.navBackBtnItem(target: self, action: #selector(self.backBtnAction(sender:)))
        //ENGAGE0011297 -- End
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnceViewNews"){
            //commented by kiran V3.0
            //print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnceViewNews")
            if let impVC = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "PopUpForCategoryVC") as? PopUpForCategoryVC {
                impVC.isFrom = "ViewNews"
                impVC.modalTransitionStyle   = .crossDissolve;
                impVC.modalPresentationStyle = .overCurrentContext
                self.present(impVC, animated: true, completion: nil)
            }
            //commented by kiran V3.0
            //print("App launched first time")
            return false
        }
    }
    
    @IBAction func previousClicked(_ sender: Any) {
        if self.arrEventCategory.count == 0 {
            
        }else{
        
        var selectedSegment =  self.segmentedController.selectedSegmentIndex  - 1
        if selectedSegment <= 0  {
            selectedSegment = 0
        }
        self.appDelegate.selectedEventsCategory = self.arrEventCategory[selectedSegment]
        self.segmentedController.selectedSegmentIndex = selectedSegment
        
        }
    }
    
   
    @IBAction func nextClicked(_ sender: Any) {
        if self.arrEventCategory.count == 0 {
            
        }else{
        var selectedSegment =  self.segmentedController.selectedSegmentIndex  + 1
        
        
        if selectedSegment >= self.segmentedController.numberOfSegments  {
            selectedSegment = self.segmentedController.numberOfSegments - 1
        }
        
        
        self.appDelegate.selectedEventsCategory = self.arrEventCategory[selectedSegment]
        
        
        self.segmentedController.selectedSegmentIndex = selectedSegment
        }}
    
    //MARK:- Segment Controller Selected
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        // print("Segment at index \(sender.selectedSegmentIndex)  selected")
        
        self.allNewsTableview.reloadData()
        self.appDelegate.selectedEventsCategory = self.arrEventCategory[sender.selectedSegmentIndex]
        
        // print()
        eventCategory = self.appDelegate.selectedEventsCategory.categoryName! as NSString
        
        self.getAllClubNewsApi(strSearch: newsSearchBar.text!)
        
    }
    
    //Added by kiran V2.5 11/30 -- ENGAGE0011297 --
    @objc private func backBtnAction(sender : UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onTapFilter() {
        if let filterView = UINib(nibName: "GuestListFilterView", bundle: Bundle.main).instantiate(withOwner: GuestListFilterView.self, options: nil).first as? GuestListFilterView{
            filterPopover = Popover()
            
            filterView.filterWithDepartment = filterByDepartment
            filterView.filterWithDate = filterByDate
            filterView.isFromGuest = 2

            let screenSize = UIScreen.main.bounds
            
            
            filterView.frame = CGRect(x:4, y: 88, width:screenSize.width - 8, height:270)

            
            filterPopover?.arrowSize = CGSize(width: 28.0, height: 13.0)
            filterPopover?.sideEdge = 4.0

            filterView.delegate = self
            filterView.eventsArrayFilter = self.arrEventCategory
            let point = CGPoint(x: self.view.bounds.width - 35, y: 70)
            filterPopover?.show(filterView, point: point)
            
            
           
            
        }
    }
    
    //MARK:- Get Event Categories  Api
    func getEventCategoriesApi(strSearch :String) -> Void {
        if (Network.reachability?.isReachable) == true{
            
            arrEventCategory = [ListEventCategory]()
            self.arrEventCategory.removeAll()
            
            let paramaterDict:[String: Any] = [
                "Content-Type":"application/json",
                APIKeys.kMemberId : UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)!,
                APIKeys.kParentId: UserDefaults.standard.string(forKey: UserDefaultsKeys.parentID.rawValue)!,
                APIKeys.kid: UserDefaults.standard.string(forKey: UserDefaultsKeys.id.rawValue)!,
                APIKeys.kdeviceInfo: [APIHandler.devicedict]
            ]
            self.appDelegate.showIndicator(withTitle: "", intoView: self.view)
            
            APIHandler.sharedInstance.getEventCategory(paramater: paramaterDict, onSuccess: { categoriesList in
                self.appDelegate.hideIndicator()
                if(categoriesList.responseCode == InternetMessge.kSuccess){
                    self.arrEventCategory.removeAll()
                    
                    if(categoriesList.clubNewsCategories == nil){
                        self.arrEventCategory.removeAll()
                        
                        // self.appDelegate.hideIndicator()
                    }
                    else{
                        self.arrEventCategory.removeAll()
                        
                        self.arrEventCategory = categoriesList.clubNewsCategories!
                        
                        self.appDelegate.selectedEventsCategory = self.arrEventCategory[0]
                        
                        self.loadsegmentController()
                    }
                }else{
                    if(((categoriesList.responseMessage!.count) )>0){
                        SharedUtlity.sharedHelper().showToast(on:
                            self.view, withMeassge: categoriesList.responseMessage, withDuration: Duration.kMediumDuration)
                    }
                }
            },onFailure: { error  in
                self.appDelegate.hideIndicator()
                //commented by kiran V3.0
                //print(error)
                SharedUtlity.sharedHelper().showToast(on:
                    self.view, withMeassge: error.localizedDescription, withDuration: Duration.kMediumDuration)
            })
            
        }else{
            
            //self.tableViewStatement.setEmptyMessage(InternetMessge.kInternet_not_available)
            
            SharedUtlity.sharedHelper().showToast(on:
                self.view, withMeassge: InternetMessge.kInternet_not_available, withDuration: Duration.kMediumDuration)
        }
        
    }
    //MARK:- Get Club News Api

    func getAllClubNewsApi(strSearch :String?, filter: GuestCardFilter? = nil)  {
        
        self.appDelegate.showIndicator(withTitle: "", intoView: self.view)
        if isFrom == "TeeTimes"{
            eventCategory = "Golf"
            
            for i in 0 ..< self.arrEventCategory.count {
                let statementData = self.arrEventCategory[i]
                if statementData.categoryName == "Golf" {
                    self.segmentedController.selectedSegmentIndex = i
                }
            }
            
            
        }
        if isFrom == "CourtTimes"{
            eventCategory = "Tennis"
            for i in 0 ..< self.arrEventCategory.count {
                let statementData = self.arrEventCategory[i]
                if statementData.categoryName == "Tennis" {
                    self.segmentedController.selectedSegmentIndex = i
                }
            }
        }
        if isFrom == "DiningReservation"{
            eventCategory = "Dining"
            for i in 0 ..< self.arrEventCategory.count {
                let statementData = self.arrEventCategory[i]
                if statementData.categoryName == "Dining" {
                    self.segmentedController.selectedSegmentIndex = i
                }
            }
        }
        
        //Added on 29th June 2020 V2.2
        
        if isFrom == "FitnessSpa"{
            eventCategory = "FitnessSpa"
            for i in 0 ..< self.arrEventCategory.count {
                let statementData = self.arrEventCategory[i]
                if statementData.categoryName == "FitnessSpa" {
                    self.segmentedController.selectedSegmentIndex = i
                }
            }
        }
        
        

            
        let params: [String : Any] = [
            APIKeys.kMemberId : UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue)!,
            APIKeys.kdeviceInfo: [APIHandler.devicedict],
            APIKeys.kParentId: UserDefaults.standard.string(forKey: UserDefaultsKeys.parentID.rawValue)!,
            APIKeys.kID : UserDefaults.standard.string(forKey: UserDefaultsKeys.id.rawValue)!,
            APIKeys.ksearchby : strSearch ?? "",
            "DepartmentFilter" : eventCategory,
            "DateSort" : filterBy
            
        ]
        
        APIHandler.sharedInstance.getClubNewsDetails(paramater: params, onSuccess: { (response) in
            self.isFrom = ""
            
            

            self.clubNewsDetailsList = response
            self.appDelegate.hideIndicator()

            
            if (self.clubNewsDetailsList?.clubNews.count == 0){
            
            self.allNewsTableview.setEmptyMessage(InternetMessge.kNoData)
            }
            else{
                self.allNewsTableview.setEmptyMessage("")


            }
            self.allNewsTableview.reloadData()


            
        }) { (error) in
            SharedUtlity.sharedHelper().showToast(on:self.view, withMeassge:error.localizedDescription, withDuration: Duration.kMediumDuration)
            self.appDelegate.hideIndicator()
            
        }
        
        
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return clubNewsDetailsList?.clubNews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubNewsDetailsList?.clubNews[section].clubNewsDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AllNewsCustomTableViewCell = self.allNewsTableview.dequeueReusableCell(withIdentifier: "ClubCell") as! AllNewsCustomTableViewCell
        if let clubNewsList = clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row]
        {

            cell.lblNewsTitle.text = "\(clubNewsList.newsTitle ?? "")"
            cell.lblNewsBy.text = ""
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //44
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("AllNewsHeaderView", owner: self, options: nil)?.first as! AllNewsHeaderView
        let dateAsString = clubNewsDetailsList?.clubNews[section].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dateAsString!) {
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            headerView.allNewsHeaderLabel.text = "\(dateFormatter.string(from: date))"
            headerView.allNewsHeaderLabel.sizeToFit()
        }

        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let shadowView = UIView()
        
        
        
        
        let gradient = CAGradientLayer()
        gradient.frame.size = CGSize(width: allNewsTableview.bounds.width, height: 15)
        let stopColor = hexStringToUIColor(hex: "000000").cgColor
        shadowView.alpha = CGFloat(0.16)
        
        let startColor = UIColor.white.cgColor
        
        
        gradient.colors = [stopColor,startColor]
        
        
        gradient.locations = [0.0,0.8]
        
        shadowView.layer.addSublayer(gradient)
        
        
        return shadowView
    }
    //44
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Added on on 14th May 2020  v2.1
        let newsMedia = self.clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].newsImageList
        if let clubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "ViewNewsViewController") as? ViewNewsViewController {
            clubNews.modalTransitionStyle   = .crossDissolve;
            clubNews.modalPresentationStyle = .overCurrentContext
            clubNews.arrMediaDetails = newsMedia
            clubNews.contentDetails =  ContentDetails.init(id: self.clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].id, date: self.clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].date, name: self.clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].newsTitle, link: nil)
            //Added on on 19th May 2020  v2.1
            clubNews.contentType = .clubNews
            self.present(clubNews, animated: true, completion: nil)
            
        }
        
        //OLd Logic
        /*
        if  (clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].newsVideoURL == "")
        {
            if let clubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "ViewNewsViewController") as? ViewNewsViewController
            {
                clubNews.modalTransitionStyle   = .crossDissolve;
                clubNews.modalPresentationStyle = .overCurrentContext
               // clubNews.imgURl = clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].newsImage
                clubNews.arrMediaDetails = clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].newsImageList
                self.present(clubNews, animated: true, completion: nil)
                
            }
        }
        else
        {
            if let clubNews = UIStoryboard.init(name: "MemberApp", bundle: .main).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController
            {
                clubNews.modalTransitionStyle   = .crossDissolve;
                clubNews.modalPresentationStyle = .overCurrentContext
            //  clubNews.imgURl = clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].newsImage as NSString?
                clubNews.videoURL = clubNewsDetailsList?.clubNews[indexPath.section].clubNewsDetails[indexPath.row].newsVideoURL.videoID

                self.present(clubNews, animated: true, completion: nil)
                
            }
            
        }
        */
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        newsSearchBar.resignFirstResponder()
        self.getAllClubNewsApi(strSearch: newsSearchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            
            self.getAllClubNewsApi(strSearch: newsSearchBar.text!)

        }
        
    }
    func loadsegmentController()  {
        
        self.segmentedController = ScrollableSegmentedControl.init(frame: self.uiSegmentView.bounds)
        self.uiSegmentView.addSubview(self.segmentedController)
        self.segmentedController.segmentStyle = .textOnly
        
        self.segmentedController.underlineSelected = true
        self.segmentedController.selectedSegmentIndex = 0
        self.segmentedController.backgroundColor = hexStringToUIColor(hex: "F5F5F5")
        
        self.segmentedController.tintColor = APPColor.loginBackgroundButtonColor.loginBtnBGColor
        
        self.segmentedController.addTarget(self, action: #selector(CalendarOfEventsViewController.segmentSelected(sender:)), for: .valueChanged)
        
        
        
        // self.segmentedController.removeFromSuperview()
        for i in 0 ..< self.arrEventCategory.count {
            let statementData = self.arrEventCategory[i]
            
            self.segmentedController.insertSegment(withTitle: statementData.DisplayText, image: nil, at: i)
        }
        
        self.segmentedController.selectedSegmentIndex = 0
    }


}
extension AllClubNewsViewController : GuestListFilterViewDelegate {
    
    func guestCardFilterApply(filter: GuestCardFilter) {
        
        if !(filter.department.value() == -1) {
            self.segmentedController.selectedSegmentIndex = filter.department.value() as Int
            eventCategory = filter.department.displayName() as NSString
            
        }
        filterBy = filter.date.value()

        filterByDepartment = eventCategory! as String
        filterByDate = filter.date.displayName()
        getAllClubNewsApi(strSearch: newsSearchBar.text, filter: filter)
        filterPopover?.dismiss()
    }
    
    func guestCardFilterClose() {
        filterPopover?.dismiss()
    }
    
    
}
