//
//  SalesOrderListController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 19/04/22.
//

import UIKit
import FTIndicator
import UIView_Shimmer

class SalesOrderListController: UIViewController {
    //MARK: - IBOUTLET
    @IBOutlet weak var lblFilterCount: UILabel!
    @IBOutlet weak var vwBgSearchBar: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: - VARIABLES
    var refreshControl: UIRefreshControl!
    private var isLodinData = true
    var totalCount = Int()
    var totalPage = Int()
    var page = 1
    var pageLoading = false
    private var searchActive = false
    var commonFilter = [CommonFilter]()
    var filteredOrders = [OrderList]()
    var salesOrderList = [OrderList]()
    //MARK: - IBACTIONS
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    @IBAction func btnOpenFilter(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonFilterController") as! CommonFilterController
        vc.storeID = Singleton.sharedInstance.retailerData.storeId!
        vc.filters = commonFilter
        vc.type = "OrderList"
        vc.applyFilter = { filter in
            self.commonFilter = filter
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(self.commonFilter)
                let jsonString = String(data: jsonData, encoding: .utf8)
                self.getOrderListAPI(page: 1, commonFilter: jsonString!)
                print("JSON String : " + jsonString!)
            }
            catch {
            }
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
    
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let currency = Singleton.sharedInstance.retailerData?.StoreName ?? ""
        let s = currency.split(separator: " ")
        print(s)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getCommonFilterAPI(mainCat: "")
        addToolbarToSearchKeyboard()
        
        getOrderListAPI(page: 1, commonFilter: "")
        updateUI()
    }
    //MARK: - UPDATE UI
    func updateUI(){
        refreshDataControl()
        lblFilterCount.layer.borderColor = hexStringToUIColor(hex: Color.red.rawValue).cgColor
        lblFilterCount.layer.borderWidth = 1
        lblFilterCount.alpha = 0
        self.tblVw.tableFooterView = UIView()
        self.tblVw.estimatedRowHeight = 140
        if #available(iOS 13.0, *) {
            vwBgSearchBar.backgroundColor = .clear
            searchBar[keyPath: \.searchTextField].font = UIFont.init(name: "Montserrat-Medium",size: 14)!
        }else {
            vwBgSearchBar.backgroundColor = hexStringToUIColor(hex:Color.searchBarBG.rawValue)
            let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
            let placeholderLabel   = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
            placeholderLabel?.font = UIFont.init(name: "Montserrat-Medium", size: 14)!
        }
    }
    //MARK: ************UPDATE NO DATA FOUND
    func updateNoData(message:String){
        if self.salesOrderList.count > 0 {
            self.tblVw.backgroundView = UIView()
        }else{
            let vwNoData = ViewNoData()
            self.tblVw.backgroundView = vwNoData
            vwNoData.imgVw.image = UIImage(named: "noDataFound")
            vwNoData.center.x = self.view.center.x
            vwNoData.center.y =  self.view.center.y
            vwNoData.label.text = message
        }
    }
    //MARK: - GET FILTER FOR ORDERLIST
    func getCommonFilterAPI(mainCat:String){
        WebServiceManager.sharedInstance.getCommonFilterAPI(type: "OrderList", mainCat: mainCat) { commonFilter, msg, status in
            if status == "1"{
                self.commonFilter = commonFilter!
            }else{
                
            }
        }
    }
    //MARK: - GET SALES ORDER LIST API
    func getOrderListAPI(page:Int,commonFilter:String){
        WebServiceManager.sharedInstance.getSalesOrderList(page: String(page), commonFilter: commonFilter) { ordersList, totalPage, totalCount, msg, status in
            self.isLodinData = false
            
            if page == 1{
                self.page = 1
            }
            self.refreshControl?.endRefreshing()
            self.tblVw.tableFooterView = nil
            if status == "1"{
                self.totalCount = totalCount!
                self.totalPage = totalPage!
                if self.pageLoading == true && page > 1{
                    self.pageLoading = false
                    self.salesOrderList += ordersList!
                }else{
                    self.salesOrderList = ordersList!
                }
                self.updateNoData(message: "")
                self.tblVw.reloadData()
            }else{
                self.salesOrderList = [OrderList]()
                self.updateNoData(message:msg!)
                self.tblVw.reloadData()
            }
        }
    }
    
    
    
    //MARK: ***********Refresh Data***************
    func refreshDataControl(){
        tblVw.alwaysBounceVertical = true
        tblVw.bounces  = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.tblVw.addSubview(refreshControl)
    }
    
    //MARK: ***********Refresh Data
    @objc func reloadData(){
        page = 1
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self.commonFilter)
            let jsonString = String(data: jsonData, encoding: .utf8)
            self.getOrderListAPI(page: 1, commonFilter: jsonString ?? "")
            //  print("JSON String : " + jsonString!)
        }
        catch {
        }
    }
}
extension SalesOrderListController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isLodinData == false else{return 5}
        if searchActive{
            return filteredOrders.count
        }else{
            return salesOrderList.count
        }
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SalesOrderTableCell
        cell.selectionStyle = .none
        guard isLodinData == false else{return cell}
        var list : OrderList!
        if searchActive{
            guard filteredOrders.count > 0 else{ return cell}
            list = filteredOrders[indexPath.row]
        }else{
            guard salesOrderList.count > 0 else{ return cell}
            list = salesOrderList[indexPath.row]
        }
        cell.lblOrderID.text = "\(list.orderId!)"
        cell.lblOrderID.font = UIFont(name: "Montserrat-Bold", size: 14)
        cell.lbldate.text = "\(list.orderdate!) \(list.orderTime!)"
        cell.lbldate.font = UIFont(name: "Montserrat-Regular", size: 14)
        cell.lblProductsName.text  = list.Products!
//        if list.paymentMethod  ?? "" == ""{
//
//            cell.lblMethodAmount.text  = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(list.totalAmount!)"
//        }else{
//            cell.lblMethodAmount.text  = "\(list.paymentMethod!): \(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "")\(list.totalAmount!)"
//        }
        if list.order_type ?? "" == ""{
            cell.lblMethodAmount.alpha = 0
        }else{
            cell.lblMethodAmount.alpha = 1
            cell.lblMethodAmount.text = list.order_type ?? ""
            cell.lblMethodAmount.font = UIFont(name: "Montserrat-Bold", size: 14)
        }
        cell.lblCustomerName.text = list.userName?.capitalized
        cell.lblCustomerName.font = UIFont(name: "Montserrat-Bold", size: 14)
        cell.lblStatus.text = list.status?.capitalized
        cell.lblStatus.font = UIFont(name: "Montserrat-Bold", size: 14)
        cell.lblMobile.text = list.userMobile
        cell.lblMobile.font = UIFont(name: "Montserrat-Regular", size: 14)
        cell.lblProductsName.font = UIFont(name: "Montserrat-Regular", size: 14)
        if Singleton.sharedInstance.retailerData.category == "cab service"{
            cell.lblQuantity.isHidden = true
           // cell.lblProductsName.attributedText = getAttrbText(simpleText: list.Products!, text: "Cab: \(list.Products!)")
            cell.lblProductsName.text =  "Cab: \(list.Products!)"
        }else{
           // cell.lblQuantity.attributedText = getAttrbText(simpleText: list.unit!, text: "Unit: \(list.unit!)")
            cell.lblQuantity.text = "Unit: \(list.unit!)"
            cell.lblQuantity.font = UIFont(name: "Montserrat-Regular", size: 14)
            cell.lblProductsName.text = "Items: \(list.Products!)"
           // cell.lblProductsName.attributedText = getAttrbText(simpleText: list.Products!, text: "Items: \(list.Products!)")
        }
        
        if list.status?.lowercased() == "complete" || list.status?.lowercased() == "completed" {
            cell.lblStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
        }else if list.status?.lowercased() == "pending" || list.status?.lowercased() == "accept" || list.status?.lowercased() == "accepted" {
            cell.lblStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
        }else if list.status?.lowercased() == "prepared" || list.status?.lowercased() == "preparing" {
            cell.lblStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
        }else{
            cell.lblStatus.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
        }
        //        switch list.storeType{
        //        case "Product":
        //        cell.imgVW.image = UIImage(named:"store")
        //        case "Service":
        //            if list.category?.uppercased() == "SALOON"{
        //        cell.imgVW.image = UIImage(named:"salon")
        //            }else if list.category?.uppercased() == "RESTAURANT"{
        //        cell.imgVW.image = UIImage(named:"restaurant")
        //        }
        //        default:break
        //        }
        self.loadMore(indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isLodinData == false else{return}
        var list : [OrderList]!
        if searchActive{
            list = filteredOrders
        }else{
            list = salesOrderList
        }
        let order = list[indexPath.row]
        if order.order_batch_id == ""{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as! OrderDetailController
            vc.ordedrDetail = order
            vc.paymentStatus = order.status ?? ""
            vc.paymentMode = order.paymentMethod ?? ""
            vc.orderType = order.order_type ?? ""
            vc.product_type = order.product_type ?? ""
            //                vc.orderBatchId = order.order_batch_id
            //        print("Order Batch ID -----> ",order.order_batch_id ?? <#default value#>)
            vc.updateOrderList = {
                let jsonEncoder = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder.encode(self.commonFilter)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    self.getOrderListAPI(page: self.page, commonFilter: jsonString!)
                    print("JSON String : " + jsonString!)
                }
                catch {
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderBatchDetailVC") as! OrderBatchDetailVC
            vc.ordedrDetail = order
            vc.paymentStatus = order.status ?? ""
            vc.orderType = order.order_type ?? ""
            vc.orderBatchId = order.order_batch_id ?? ""
            vc.subStatus = order.sub_status ?? ""
            vc.product_type = order.product_type ?? ""
            //   print("Order Batch ID -----> ",order.order_batch_id ?? <#default value#>)
            vc.updateOrderList = {
                let jsonEncoder = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder.encode(self.commonFilter)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    self.getOrderListAPI(page: self.page, commonFilter: jsonString!)
                    print("JSON String : " + jsonString!)
                }
                catch {
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLodinData == true else{
            cell.setTemplateWithSubviews(isLodinData)
            return}
        cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    //    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //    }
    
    //MARK: LOAD MORE IN TABLE
    func loadMore(indexPath : IndexPath){
        if indexPath.row == salesOrderList.count - 1 && !pageLoading{ // last cell
            if self.totalCount > salesOrderList.count && self.page <= self.totalPage  { // more items to fetch
                self.pageLoading = true
                let vW = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  44))
                self.showSpinner(onView :vW)
                // showActivityIndicatory(vw: vW)
                self.tblVw.tableFooterView = vW
                self.tblVw.tableFooterView?.isHidden = false
                self.page += 1
                let jsonEncoder = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder.encode(self.commonFilter)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    getOrderListAPI(page: self.page, commonFilter: jsonString!)
                    print("JSON String : " + jsonString!)
                }
                catch {
                }
                
                
            }
        }
    }
    
}
extension SalesOrderListController:UISearchBarDelegate{
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
        filteredOrders = salesOrderList.filter( {
            $0.orderId!.range(of: text, options: .caseInsensitive) != nil || $0.userName!.range(of: text, options: .caseInsensitive) != nil
        })
    }
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
        searchActive = true
        searchBar.setShowsCancelButton(true, animated: true)
        if searchText.count > 0{
            filterArrayData(text: searchText)
            tblVw.reloadData()
            
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        tblVw.reloadData()
        filteredOrders.removeAll()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
    }
}
class SalesOrderTableCell:UITableViewCell,ShimmeringViewProtocol{
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblMethodAmount: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblProductsName: UILabel!
    var shimmeringAnimatedItems: [UIView] {
        [
            lblOrderID,
            lbldate,
            lblMethodAmount,
            lblCustomerName,
            lblStatus,
            lblMobile,
            lblQuantity,
            lblProductsName
        ].compactMap({$0})
    }
}
