//
//  DealListVC.swift
//  MASSAPPDEMO
//
//  Created by Sanjeet on 23/12/22.
//

import UIKit
import FTIndicator

class DealListVC: BaseViewController, AddDealVCDelgate {
    
    
    
    @IBOutlet weak var tableviewDeals: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lbltotalCount: UILabel!
    @IBOutlet weak var lblFilterCount: UILabel!
    @IBOutlet weak var vwBgSearchBar: UIView!
    
    @IBOutlet weak var filterButton: UIButton!
    
    var deal:String = "deal"
    var dealsListData: [DealList]?
    var filtterDealsListData: [DealList]?
    
    @IBOutlet weak var filterButtonWidth: NSLayoutConstraint!
    
    
    private var searchActive = false
    
    var page = 1
    var totalCount = Int()
    var totalPage = Int()
    var pageLoading = false
    
    var refreshControl: UIRefreshControl!
    var commonFilter = [CommonFilter]()
    
    var isWorkOrderDetail = false
    var isSalesOrderDetail = false
    
    var dealWorkOrderList: [WorkOrderList]?
    var filtterDealWorkOrderList: [WorkOrderList]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navi = self.navigationController as? DealNavigationViewController{
          //  self.isWorkOrderDetail = navi.isWorkOrderDetail
           // self.isSalesOrderDetail = navi.isSalesOrderDetail
        }
        
       
        navigationSetup()
        updateUI()
        getCommonFilterAPI(mainCat: "")
        getAllDealsList(page)
    }
    //MARK: - UPDATE UI
    func updateUI(){
        refreshDataControl()
        
        lblFilterCount.layer.borderColor = hexStringToUIColor(hex: Color.red.rawValue).cgColor
        lblFilterCount.layer.borderWidth = 1
        lblFilterCount.alpha = 0
        
        if self.isSalesOrderDetail{
            filterButton.isHidden =  false
        }else{
            filterButton.isHidden =  true
            lblFilterCount.isHidden = true
            self.filterButtonWidth.constant = 0
        }
        
        self.tableviewDeals.tableFooterView = UIView()
        if #available(iOS 13.0, *) {
            vwBgSearchBar.backgroundColor = .clear
            searchBar[keyPath: \.searchTextField].font = UIFont.init(name: "Montserrat-Medium",size: 14)!
        }else {
            vwBgSearchBar.backgroundColor = hexStringToUIColor(hex:Color.searchBarBG.rawValue)
            
            let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
            let placeholderLabel    = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
            placeholderLabel?.font  = UIFont.init(name: "Montserrat-Medium", size: 14)!
        }
    }
    
    //MARK: ***********Refresh Data
    func refreshDataControl(){
        tableviewDeals.alwaysBounceVertical = true
        tableviewDeals.bounces  = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.tableviewDeals.addSubview(refreshControl)
    }
    //MARK: ************UPDATE NO DATA FOUND
    func updateNoData(message:String){
        if self.dealsListData?.count > 0 && self.isSalesOrderDetail{
            self.tableviewDeals.backgroundView = UIView()
        } else if self.dealWorkOrderList?.count > 0 && self.isWorkOrderDetail{
            self.tableviewDeals.backgroundView = UIView()
        }
        else{
            let vwNoData = ViewNoData()
            self.tableviewDeals.backgroundView = vwNoData
            vwNoData.imgVw.image = UIImage(named: "noDataFound")
            vwNoData.center.x = self.view.center.x
            vwNoData.center.y =  self.view.center.y
            vwNoData.label.text = message
        }
    }
    //MARK: ***********Refresh Data
    @objc func reloadData(){
        page = 1
        getAllDealsList(page,commonFilter: self.jsonCommonFilter())
    }
    
    @IBAction func tapped_backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - GET FILTER FOR PRODUCTS
    func getCommonFilterAPI(mainCat:String){
        WebServiceManager.sharedInstance.getCommonFilterAPI(type: "ProductList",  mainCat: mainCat,vertical:"manufacturing",sub_type: self.deal) { commonFilter, msg, status in
            if status == "1"{
                self.commonFilter = commonFilter!
            }else{
                
            }
        }
    }
    @IBAction func tapped_filterBtn(_ sender: Any) {
        
        let vc = UIStoryboard().returnMain().instantiateViewController(withIdentifier: "CommonFilterController") as! CommonFilterController
        vc.storeID = Singleton.sharedInstance.retailerData.storeId ?? ""
        vc.type = "OrderList"
        vc.filters = commonFilter
        vc.vertical = "manufacturing"
        vc.sub_type = self.deal
        vc.applyFilter = { filter in
            self.commonFilter = filter
            self.dealsListData = []
            self.dealWorkOrderList = []
            self.getAllDealsList(1, commonFilter: self.jsonCommonFilter())
            
            var count = 0
            for item in self.commonFilter {
                if item.returnValue != ""{
                    count += 1
                 }
             }
            if count > 0{
                self.lblFilterCount.alpha = 1
                self.lblFilterCount.text = String(count)
            }else{
                self.lblFilterCount.alpha = 0
            }
        }
        self.navigationController!.present(vc, animated: true)
    }
    func jsonCommonFilter() -> String
    {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self.commonFilter)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString ?? ""
            
            print("JSON String : " + jsonString!)
        }
        catch {
            return ""
        }
        }
    
    func refreshLising() {
        self.reloadData()
    }
}

extension DealListVC {
    
    func getAllDealsList(_ page:Int,commonFilter:String = "") {
        showIndicator()
        
        if isSalesOrderDetail{
            WebServiceManagerDeal.sharedInstance.getDealsList(page: String(page),commonFilter: commonFilter) { dealsArray, msg, status, totalCount, totalPage  in
                self.hideIndicator()
                if status == "1" {
                    self.totalCount = totalCount ?? 1
                    self.totalPage = totalPage ?? 1
                    self.dealsListData = dealsArray
                    self.updateNoData(message: "")
                    self.tableviewDeals.reloadData()
                }
                else {
                    self.lbltotalCount.text = ""
                    
                    FTIndicator.showToastMessage(msg)
                    self.updateNoData(message: msg)
                }
            }
        }else if isWorkOrderDetail {
            
            WebServiceManagerDeal.sharedInstance.getWorkOrderList(page: String(page),commonFilter: commonFilter) { dealsArray, msg, status, totalCount, totalPage  in
                self.hideIndicator()
                if status == "1" {
                    self.totalCount = totalCount ?? 1
                    self.totalPage = totalPage ?? 1
                    self.dealWorkOrderList = dealsArray
                    self.updateNoData(message: "")
                    self.tableviewDeals.reloadData()
                }
                else {
                    self.lbltotalCount.text = ""
                    
                    FTIndicator.showToastMessage(msg)
                    self.updateNoData(message: msg)
                }
            }
            
        }
       
    }
    
    @objc func backButtonAction() {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    @objc func addDealButtonAction() {
        let vc = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "AddDealVC") as! AddDealVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    fileprivate func navigationSetup() {
        let sideMenuButton =  self.getMenuButton()
        
        sideMenuButton.0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        if self.isSalesOrderDetail{
            let plusButton =  self.getPlusButton(title : "+" )
            plusButton.0.addTarget(self, action: #selector(addDealButtonAction), for: .touchUpInside)
            navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: DealListConstant.SalesOrder,barTintcolor: UIColor.init(named: "themeRed") ?? UIColor.yellow, titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: [plusButton.1], leftBarItem1: sideMenuButton.1)
        }else{
            
            navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: DealListConstant.WorkOrder,barTintcolor: UIColor.init(named: "themeRed") ?? UIColor.yellow, titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
        }
       
    }
    
    //MARK: LOAD MORE IN TABLE
    func loadMore(indexPath : IndexPath){
        if self.isSalesOrderDetail{
            if indexPath.row == (dealsListData?.count ?? 0) - 1 && !pageLoading{ // last cell
                if self.totalCount > dealsListData?.count && self.page <= self.totalPage  { // more items to fetch
                    self.pageLoading = true
                    let vW = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  44))
                    self.showSpinner(onView :vW)
                    // showActivityIndicatory(vw: vW)
                    self.page += 1
                    getAllDealsList(page,commonFilter: self.jsonCommonFilter())
                    
                }
            }
        }else{
            
            if indexPath.row == (dealWorkOrderList?.count ?? 0) - 1 && !pageLoading{ // last cell
                if self.totalCount > dealWorkOrderList?.count && self.page <= self.totalPage  { // more items to fetch
                    self.pageLoading = true
                    let vW = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  44))
                    self.showSpinner(onView :vW)
                    // showActivityIndicatory(vw: vW)
                    self.page += 1
                    getAllDealsList(page,commonFilter: self.jsonCommonFilter())
                    
                }
            }
            
            
        }
    }
}


//MARK :- ********** TABLE VIEW DELEGATE  ******
extension DealListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        if searchActive{
            if self.isSalesOrderDetail{
                return filtterDealsListData?.count ?? 0
            }else{
                return filtterDealWorkOrderList?.count ?? 0
            }
           
        }else{
            if self.isSalesOrderDetail{
                return dealsListData?.count ?? 0
            }else{
                return dealWorkOrderList?.count ?? 0
            }
           
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealListTableViewCell", for: indexPath) as! DealListTableViewCell
        cell.view_response.layer.cornerRadius = 3
        cell.view_response.layer.masksToBounds = true
      
        cell.quantityLabelConstant.text = DealListConstant.QuantityS
        cell.productNameLabelConstant.text = DealListConstant.ProductName
        cell.amountLabelConstant.text = DealListConstant.AmountS
        
        
        
        
        cell.collectionHeight.constant = 100.0
        let arr = ["Approved","Pending","Stores","Production","QA","Accounting","Packaging","Dispatch","Complete"]
        var foundCurrentStatus:Bool = false
        
        
        if self.isSalesOrderDetail{
            cell.dealIDLabelCosntant.text = DealListConstant.DealId
            var obj = self.dealsListData?[indexPath.row]
            if searchActive{
                guard filtterDealsListData?.count > 0 else{ return cell}
                obj = self.filtterDealsListData?[indexPath.row]
                
            }else{
                guard dealsListData?.count > 0 else{ return cell}
                obj = self.dealsListData?[indexPath.row]
            }
            
            cell.retailerLabelProcess.text =  obj?.activity ?? ""
            cell.dealIDLabelValue.text = obj?.dealId ?? ""
            cell.nameLabel.text = "\(obj?.userFirstName ?? "") \(obj?.userLastName ?? "")"
            cell.productNameLabel.text = obj?.productName ?? ""
            cell.quantityLabel.text = obj?.quantity ?? ""
            cell.amountLabel.text = obj?.amount ?? ""
            cell.dateLabel.text = Date().convertDateFormat(inputDate: obj?.deliveryDate ?? "")
            
            
            cell.arrStatus = []
            for object in arr{
                var statusInfo =  StatusInfo.init()
                if foundCurrentStatus == false{
                    var status = obj?.dealStatus ?? ""
                    status = status.lowercased()
                    let arrObj = object.lowercased()
                    if arrObj.contains(status) || status.contains(arrObj){
                        foundCurrentStatus = true
                        statusInfo.title = object
                        
                        switch object.lowercased() {
                        case "approved":
                            statusInfo.image = UIImage.init(named: "orderCreated")
                            statusInfo.desColor =   UIColor().hexStringToUIColor(hex: "F19436")
                        case "order created":
                            statusInfo.image = UIImage.init(named: "orderCreated")
                            statusInfo.desColor =   UIColor().hexStringToUIColor(hex: "F19436")
                        case "order placed":
                            statusInfo.image = UIImage.init(named: "orderCreated")
                            statusInfo.desColor =   UIColor().hexStringToUIColor(hex: "F19436")
                        case "pending":
                            statusInfo.image = UIImage.init(named: "orderCreated")
                            statusInfo.desColor = UIColor.init(red: Int(254.0/255.0), green: Int(142.0/255.0), blue: 0)
                        case "stores":
                            statusInfo.image = UIImage.init(named: "stores")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(6.0/255.0), green: Int(44.0/255.0), blue: Int(114.0/255.0))
                        case "store":
                            statusInfo.image = UIImage.init(named: "stores")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(6.0/255.0), green: Int(44.0/255.0), blue: Int(114.0/255.0))
                        case "production":
                            statusInfo.image = UIImage.init(named: "production")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(0), green: Int(131.0/255.0), blue: Int(103.0/255.0))
                        case "qa":
                            statusInfo.image = UIImage.init(named: "qa")
                            statusInfo.des = "(Rejected)"
                            statusInfo.desColor = UIColor().hexStringToUIColor(hex: "EA332A")
                        case "accounting":
                            statusInfo.image = UIImage.init(named: "accounting")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.yellow
                        case "packaging":
                            statusInfo.image = UIImage.init(named: "packaging")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(131.0/255.0), green: Int(24.0/255.0), blue: Int(106.0/255.0))
                        case "dispatch":
                            statusInfo.image = UIImage.init(named: "dispatch")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(7.0/255.0), green: Int(135.0/255.0), blue: Int(64.0/255.0))
                        case "complete":
                            statusInfo.image = UIImage.init(named: "complete")
                            statusInfo.des = ""
                            statusInfo.desColor = UIColor.init(red: Int(7.0/255.0), green: Int(135.0/255.0), blue: Int(64.0/255.0))
                        default:
                            break
                        }
                        
                        
                    }else{
                        statusInfo.title = object
                        statusInfo.image = UIImage.init(named: "tick")
                        statusInfo.des = ""
                    }
                }else{
                    statusInfo.title = object
                    statusInfo.image = UIImage.init(named: "grayIcon")
                    statusInfo.des = ""
                    statusInfo.desColor = UIColor.white
                }
                cell.arrStatus.append(statusInfo)
            }
        }else{
            cell.dealIDLabelCosntant.text = DealListConstant.Orderid
            
            
            var obj = self.dealWorkOrderList?[indexPath.row]
            if searchActive{
                guard filtterDealWorkOrderList?.count > 0 else{ return cell}
                obj = self.filtterDealWorkOrderList?[indexPath.row]
                
            }else{
                guard dealWorkOrderList?.count > 0 else{ return cell}
                obj = self.dealWorkOrderList?[indexPath.row]
            }
            
            cell.retailerLabelProcess.text =  obj?.salesOrderType ?? ""
            cell.dealIDLabelValue.text = obj?.orderId ?? ""
            cell.nameLabel.text = obj?.userName ?? ""
            cell.productNameLabel.text = obj?.products ?? ""
            cell.quantityLabel.text = obj?.quantity ?? ""
            cell.amountLabel.text = obj?.totalAmount ?? ""
            var orderDate =  obj?.orderdate ?? "" + "|"
            let orderTime = obj?.orderTime ?? ""
            orderDate =    orderDate + orderTime
            
            cell.dateLabel.text =  orderDate
            
            
            cell.arrStatus = []
            for object in arr{
                var statusInfo =  StatusInfo.init()
                if foundCurrentStatus == false{
                    var status = obj?.status ?? ""
                    status = status.lowercased()
                    let arrObj = object.lowercased()
                    if arrObj.contains(status) || status.contains(arrObj){
                        foundCurrentStatus = true
                        statusInfo.title = object
                        
                        switch object.lowercased() {
                        case "approved":
                            statusInfo.image = UIImage.init(named: "orderCreated")
                            statusInfo.desColor =   UIColor().hexStringToUIColor(hex: "F19436")
                        case "order created":
                            statusInfo.image = UIImage.init(named: "orderCreated")
                            statusInfo.desColor =   UIColor().hexStringToUIColor(hex: "F19436")
                        case "order placed":
                            statusInfo.image = UIImage.init(named: "orderCreated")
                            statusInfo.desColor =   UIColor().hexStringToUIColor(hex: "F19436")
                        case "pending":
                            statusInfo.image = UIImage.init(named: "orderCreated")
                            statusInfo.desColor = UIColor.init(red: Int(254.0/255.0), green: Int(142.0/255.0), blue: 0)
                        case "stores":
                            statusInfo.image = UIImage.init(named: "stores")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(6.0/255.0), green: Int(44.0/255.0), blue: Int(114.0/255.0))
                        case "store":
                            statusInfo.image = UIImage.init(named: "stores")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(6.0/255.0), green: Int(44.0/255.0), blue: Int(114.0/255.0))
                        case "production":
                            statusInfo.image = UIImage.init(named: "production")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(0), green: Int(131.0/255.0), blue: Int(103.0/255.0))
                        case "qa":
                            statusInfo.image = UIImage.init(named: "qa")
                            statusInfo.des = "(Rejected)"
                            statusInfo.desColor = UIColor().hexStringToUIColor(hex: "EA332A")
                        case "accounting":
                            statusInfo.image = UIImage.init(named: "accounting")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.yellow
                        case "packaging":
                            statusInfo.image = UIImage.init(named: "packaging")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(131.0/255.0), green: Int(24.0/255.0), blue: Int(106.0/255.0))
                        case "dispatch":
                            statusInfo.image = UIImage.init(named: "dispatch")
                            statusInfo.des = "(In Progress)"
                            statusInfo.desColor = UIColor.init(red: Int(7.0/255.0), green: Int(135.0/255.0), blue: Int(64.0/255.0))
                        case "complete":
                            statusInfo.image = UIImage.init(named: "complete")
                            statusInfo.des = ""
                            statusInfo.desColor = UIColor.init(red: Int(7.0/255.0), green: Int(135.0/255.0), blue: Int(64.0/255.0))
                        default:
                            break
                        }
                        
                        
                    }else{
                        statusInfo.title = object
                        statusInfo.image = UIImage.init(named: "tick")
                        statusInfo.des = ""
                    }
                }else{
                    statusInfo.title = object
                    statusInfo.image = UIImage.init(named: "grayIcon")
                    statusInfo.des = ""
                    statusInfo.desColor = UIColor.white
                }
                cell.arrStatus.append(statusInfo)
            }
            
            
            
            
        }
        cell.statusCollectionView.dataSource = cell
        self.loadMore(indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let initVC = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "DealDetailsVC") as! DealDetailsVC
        if self.isSalesOrderDetail{
            var obj = self.dealsListData?[indexPath.row]
            if searchActive{
                initVC.dealList = self.filtterDealsListData?[indexPath.row]
            }else{
                initVC.dealList  = self.dealsListData?[indexPath.row]
            }
        }else{
            var obj = self.dealWorkOrderList?[indexPath.row]
            if searchActive{
                initVC.dealWorkOrderList = self.filtterDealWorkOrderList?[indexPath.row]
            }else{
                initVC.dealWorkOrderList  = self.dealWorkOrderList?[indexPath.row]
            }
            
            
        }
        initVC.isWorkOrderDetail = self.isWorkOrderDetail
        initVC.isSalesOrderDetail = self.isSalesOrderDetail
        self.navigationController?.pushViewController(initVC, animated: true)
    }
    
}


//MARK:-  DELEGATE THOUGH FILTER DATA PASS
extension DealListVC: filterDataDelegate{
    func filterdataPass(FilterData: Any) {
        print(((FilterData as? NSDictionary)?.value(forKey: "data") as! NSArray)[0])
    }
}
extension DealListVC:UISearchBarDelegate{
    func addToolbarToSearchKeyboard()
    {
        let numberPadToolbar: UIToolbar = UIToolbar()
        numberPadToolbar.isTranslucent = true
        numberPadToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.cancelAction)),
        ]
        numberPadToolbar.sizeToFit()
        searchBar.inputAccessoryView = numberPadToolbar
    }
    
    @objc func cancelAction()
    {
    searchBar.resignFirstResponder()
    }
    //MARK: *****************Filter  Data
    func filterArrayData(text:String){
        if self.isSalesOrderDetail
        {
            filtterDealsListData = dealsListData?.filter( {
                $0.productName!.range(of: text, options: .caseInsensitive) != nil || $0.userFirstName!.range(of: text, options: .caseInsensitive) != nil || $0.userLastName!.range(of: text, options: .caseInsensitive) != nil  ||  $0.dealId!.range(of: text, options: .caseInsensitive) != nil
            })
            //        tblVw.reloadData()
            print("Filtered product count === ",filtterDealsListData?.count,dealsListData?.count)
            if filtterDealsListData?.count == 0{
                self.lbltotalCount.text = "No Result Found"
            }else{
                if let count  = filtterDealsListData?.count
                {
                    self.lbltotalCount.text = "\(count) Result Found"
                }
                
            }}
        else if isWorkOrderDetail{
            filtterDealWorkOrderList = dealWorkOrderList?.filter( {
                $0.products!.range(of: text, options: .caseInsensitive) != nil || $0.products!.range(of: text, options: .caseInsensitive) != nil || $0.userName!.range(of: text, options: .caseInsensitive) != nil  ||  $0.orderId!.range(of: text, options: .caseInsensitive) != nil
            })
            //        tblVw.reloadData()
            print("Filtered product count === ",filtterDealWorkOrderList?.count,dealWorkOrderList?.count)
            if filtterDealWorkOrderList?.count == 0{
                self.lbltotalCount.text = "No Result Found"
            }else{
                if let count  = filtterDealWorkOrderList?.count
                {
                    self.lbltotalCount.text = "\(count) Result Found"
                }
            }
        }
       }
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
        searchActive = true
        searchBar.setShowsCancelButton(true, animated: true)
        if searchText.count > 0{
            print("SEarch text ===> ",searchText)
                filterArrayData(text: searchText)
            self.tableviewDeals.reloadData()
//            if filteredServices.count == 0{
//                self.lbltotalCount.text = "No Results Found"
//            }else{
//                self.lbltotalCount.text = "\(String(filteredServices.count)) Results Found"
//            }
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        self.tableviewDeals.reloadData()
        if self.totalCount == 0{
            self.lbltotalCount.text = "No Results Found"
        }else{
            self.lbltotalCount.text = "\(String(self.totalCount)) Results Found"
        }
        filtterDealsListData = []
        
        
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
    }
}

