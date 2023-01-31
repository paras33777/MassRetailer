//
//  SearchProductNameViewController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 19/01/23.
//

import UIKit
import FTIndicator
import UIView_Shimmer
protocol SearchProductNameViewControllerDelegate{
    func selectProductdelegate(productList:Productlist)
}

class SearchProductNameViewController: BaseViewController {
    //MARK: - IBOUTLET
    var delegate:SearchProductNameViewControllerDelegate? = nil
    
  
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lbltotalCount: UILabel!
    @IBOutlet weak var lblFilterCount: UILabel!
    @IBOutlet weak var vwBgSearchBar: UIView!
    
 
    
    
    //MARK: - VARIABLES
    private var isLodinData = true
    private var searchActive = false
    var productList = [Productlist]()
    var selectedProduct :Productlist?
    var filteredProducts = [Productlist]()
    var refreshControl: UIRefreshControl!
    var totalCount = Int()
    var totalPage = Int()
    var page = 1
    var pageLoading = false
    var commonFilter = [CommonFilter]()
    
    //MARK: - IBACTIONS
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    @IBAction func btnOpenFilter(_ sender: UIButton) {
        let vc = UIStoryboard().returnMain().instantiateViewController(withIdentifier: "CommonFilterController") as! CommonFilterController
        vc.storeID = Singleton.sharedInstance.retailerData.storeId ?? ""
        vc.type = "OrderList"
        vc.filters = commonFilter
        vc.applyFilter = { filter in
            self.commonFilter = filter
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(self.commonFilter)
                let jsonString = String(data: jsonData, encoding: .utf8)
                self.getProductListAPI(page: 1, commonFilter: jsonString!)
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
        
        let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
        if storeType.contains("manufacturing"){
           
            self.navigationController?.navigationBar.isHidden = false
            navigationSetup()
        }
//        getCommonFilterAPI(mainCat: "")
//        addToolbarToSearchKeyboard()
//        getProductListAPI(page: 1, commonFilter: "")
//        updateUI()
        
    }
    fileprivate func navigationSetup() {
        let sideMenuButton =  self.getBackButton()
        sideMenuButton.0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
     
            navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: AddSalesOrderConstant.SelectProductName,barTintcolor: UIColor.init(named: "themeRed") ?? UIColor.yellow, titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
    
       
    }
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        getCommonFilterAPI(mainCat: "")
        addToolbarToSearchKeyboard()
        getProductListAPI(page: 1, commonFilter: "")
        updateUI()
        
    }
    //MARK: - UPDATE UI
    func updateUI(){
        refreshDataControl()
        lblFilterCount.layer.borderColor = hexStringToUIColor(hex: Color.red.rawValue).cgColor
        lblFilterCount.layer.borderWidth = 1
        lblFilterCount.alpha = 0
        self.tblVw.tableFooterView = UIView()
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

    //MARK: ************UPDATE NO DATA FOUND
    func updateNoData(message:String){
        if self.productList.count > 0 {
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
    //MARK: - GET FILTER FOR PRODUCTS
    func getCommonFilterAPI(mainCat:String){
        WebServiceManager.sharedInstance.getCommonFilterAPI(type: "ProductList",  mainCat: mainCat) { commonFilter, msg, status in
            if status == "1"{
                self.commonFilter = commonFilter!
            }else{
                
            }
        }
    }
    //MARK: - GET PRODUCT LIST API
    func getProductListAPI(page:Int,commonFilter:String){
        
        let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
        if storeType.contains("manufacturing"){
            
            if self.productList.count == 0{
                self.isLodinData = true
                self.tblVw.reloadData()
            }
            
            WebServiceManagerDeal.sharedInstance.getProductListManfacturing(page: String(page),commonFilter: commonFilter) { productList, totalPage, totalCount, msg, status in
                self.isLodinData = false
                if page == 1{
                    self.page = 1
                }
                self.refreshControl?.endRefreshing()
                self.tblVw.tableFooterView = nil
                if status == "1"{
                    self.totalCount = totalCount!
                    self.totalPage = totalPage!
                    if self.totalCount == 0{
                        self.lbltotalCount.text = "No Results Found"
                    }else{
                        self.lbltotalCount.text = "\(String(self.totalCount)) Results Found"
                    }
                    
                    if self.pageLoading == true && page > 1{
                        self.pageLoading = false
                        self.productList += productList!
                    }else{
                        self.productList = productList!
                    }
                    self.updateNoData(message: "")
                    self.tblVw.reloadData()
                 }else{
                     self.lbltotalCount.text = ""
                     self.productList = [Productlist]()
                    self.updateNoData(message: msg!)
                     self.tblVw.reloadData()
                }
            }
            
        }
       
    }
    //MARK: ***********Refresh Data
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
            getProductListAPI(page: 1, commonFilter: jsonString!)
          //  print("JSON String : " + jsonString!)
           }
        catch {
        }
    }
   
   
    
   }
extension SearchProductNameViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if searchActive{
            return filteredProducts.count
        }else{
        return productList.count
        }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProductTableCell", for: indexPath) as! SearchProductTableCell
      
        cell.setTemplateWithSubviews(self.isLodinData)
        var list : [Productlist]!
        if searchActive{
            guard filteredProducts.count > 0 else{ return cell}
            list = filteredProducts
        }else{
            guard productList.count > 0 else{ return cell}
            list = productList
        }
        cell.selectionStyle = .none
        let product = list[indexPath.row]
        cell.lblName.text = product.productName
        if let productId = self.selectedProduct?.productId{
            if productId ==   product.productId{
                cell.selectImage.setImage(UIImage.init(named: "checkbox"), for: .normal)
            }else{
                cell.selectImage.setImage(UIImage.init(named: "unCheck"), for: .normal)
            }
        }
        else{
            cell.selectImage.setImage(UIImage.init(named: "unCheck"), for: .normal)
        }
        cell.selectImage.isUserInteractionEnabled = false
        self.loadMore(indexPath: indexPath)
        return cell
        
    }
   
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var list : [Productlist]!
        if searchActive{
            guard filteredProducts.count > 0 else{ return }
            list = filteredProducts
        }else{
            guard productList.count > 0 else{ return }
            list = productList
        }
        
            self.delegate?.selectProductdelegate(productList: list[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
       
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLodinData == false else{
        cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
            return}
    }
    //MARK: LOAD MORE IN TABLE
    func loadMore(indexPath : IndexPath){
        if indexPath.row == productList.count - 1 && !pageLoading{ // last cell
            if self.totalCount > productList.count && self.page <= self.totalPage { // more items to fetch
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
                    self.getProductListAPI(page: self.page, commonFilter: jsonString!)
                  //  print("JSON String : " + jsonString!)
                   }
                catch {
                }
            }
         }
      }
        }
extension SearchProductNameViewController:UISearchBarDelegate{
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
        filteredProducts = productList.filter( {
        $0.productName!.range(of: text, options: .caseInsensitive) != nil
        })
//        tblVw.reloadData()
        print("Filtered product count === ",filteredProducts.count,productList.count)
        if filteredProducts.count == 0{
            self.lbltotalCount.text = "No Result Found"
        }else{
            self.lbltotalCount.text = "\(filteredProducts.count) Result Found"
        }
       }
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
        searchActive = true
        searchBar.setShowsCancelButton(true, animated: true)
        if searchText.count > 0{
            print("SEarch text ===> ",searchText)
                filterArrayData(text: searchText)
                tblVw.reloadData()
//            if filteredServices.count == 0{
//                self.lbltotalCount.text = "No Results Found"
//            }else{
//                self.lbltotalCount.text = "\(String(filteredServices.count)) Results Found"
//            }
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        tblVw.reloadData()
        if self.totalCount == 0{
            self.lbltotalCount.text = "No Results Found"
        }else{
            self.lbltotalCount.text = "\(String(self.totalCount)) Results Found"
        }
        filteredProducts.removeAll()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
    }
}

    

class SearchProductTableCell:UITableViewCell,ShimmeringViewProtocol{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var selectImage: UIButton!
  
    var shimmeringAnimatedItems: [UIView] {
        
           [
            lblName,
           ].compactMap{ $0}
           }
    
    
       }
    
