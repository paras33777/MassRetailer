//
//  ProductListController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 19/04/22.
//

import UIKit
import FTIndicator
import UIView_Shimmer

class ProductListController: BaseViewController {
    //MARK: - IBOUTLET
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lbltotalCount: UILabel!
    @IBOutlet weak var lblFilterCount: UILabel!
    @IBOutlet weak var vwBgSearchBar: UIView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    
    
    
    //MARK: - VARIABLES
    private var isLodinData = true
    private var searchActive = false
    var productList = [Productlist]()
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
            self.backView.backgroundColor = UIColor.white
            self.heightNavigationView.constant = 0
            self.navigationController?.navigationBar.isHidden = false
            navigationSetup() 
        }else{
            self.navigationController?.navigationBar.isHidden = true
            
        }
//        getCommonFilterAPI(mainCat: "")
//        addToolbarToSearchKeyboard()
//        getProductListAPI(page: 1, commonFilter: "")
//        updateUI()
        
    }
    fileprivate func navigationSetup() {
        let sideMenuButton =  self.getMenuButton()
        sideMenuButton.0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
     
            navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: ProductDetailManfacturingViewControllerConstant.ProductList,barTintcolor: UIColor.init(named: "themeRed") ?? UIColor.yellow, titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
    
       
    }
    @objc func backButtonAction() {
        self.sideMenuViewController?.presentLeftMenuViewController()
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
            
        }else{
            WebServiceManager.sharedInstance.getProductList(page: String(page),commonFilter: commonFilter) { productList, totalPage, totalCount, msg, status in
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
    @objc func editAction(_ sender:UIButton){
//        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
//         let indexPath = self.tblVw.indexPathForRow(at:buttonPosition)!
//
        let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
        
        if storeType.contains("manufacturing"){
            
            
            let vc = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "AddProductManfacturingViewController") as! AddProductManfacturingViewController
          
            
            var list : [Productlist]!
            if searchActive{
                list = filteredProducts
               
            }else{
           
                list = productList
                
            }
            let product = list[sender.tag]
            vc.product = product
            vc.isComingFrom = "EditProduct"
            vc.productImageFromEdit = productList[0].Product_Medium_Image ?? ""
            vc.updateProductList = {
                let jsonEncoder = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder.encode(self.commonFilter)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    self.getProductListAPI(page: self.page, commonFilter: jsonString!)
                    print("JSON String : " + jsonString!)
                }
                catch {
                }
            }
                    self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }else{
            
            let vc = UIStoryboard().returnProductUI().instantiateViewController(withIdentifier: "AddProductController") as! AddProductController
            var list : [Productlist]!
            if searchActive{
                list = filteredProducts
               
            }else{
           
                list = productList
                
            }
            let product = list[sender.tag]
            vc.product = product
            vc.isComingFrom = "EditProduct"
            vc.productImageFromEdit = productList[0].Product_Medium_Image ?? ""
            vc.updateProductList = {
                let jsonEncoder = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder.encode(self.commonFilter)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    self.getProductListAPI(page: self.page, commonFilter: jsonString!)
                    print("JSON String : " + jsonString!)
                }
                catch {
                }
            }
                    self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
       
      
    }
   
    
   }
extension ProductListController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isLodinData == false else{return 5}
        if searchActive{
            return filteredProducts.count
        }else{
        return productList.count
        }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
        if storeType.contains("manufacturing"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCellManfacturing", for: indexPath) as! ProductTableCellManfacturing
            
            guard isLodinData == false else{return cell}
            cell.setTemplateWithSubviews(isLodinData)
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
            

            //cell.lblMainCategory.text = product.MainCategory
            cell.lblDescription.text = product.productShortDescription
            cell.lblQuantity.text = ""
          //  cell.lblMainCategory.text = product.mainCategory
          
            cell.lblOfferPrice.text = ""
            if let productPrice = Double(product.productPrice ?? "0") {
                if productPrice > 0{
                    cell.lblOfferPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product.productPrice!)"
                }
            }
           
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(editAction), for: .touchUpInside)
            self.loadMore(indexPath: indexPath)
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableCell
        guard isLodinData == false else{return cell}
        cell.setTemplateWithSubviews(isLodinData)
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
        cell.lblName.text = product.ProductName
        cell.statusLabel.text = product.product_status ?? ""
        if product.product_status == "Active"{
            cell.switchStatus.isOn = true
        }else{
            cell.switchStatus.isOn = false

        }
        cell.switchStatus.set(width: 40, height: 25)

        cell.switchStatus.tag = indexPath.row
        cell.switchStatus.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)

        //cell.lblMainCategory.text = product.MainCategory
        cell.lblDescription.text = product.ProductSHORTDESCRIPTION
            
            if Singleton.sharedInstance.retailerData.inventory  == "with inventory"{
                cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Quantity: \(product.ProductQuantity!)")
            }else{
                cell.lblQuantity.text = ""
            }
       
        
        cell.lblOfferPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product.ProductOfferPrice!)"
        if Double(product.ProductOfferPrice!) == Double(product.ProductPrice!){
            cell.stackMain.subviews[3].isHidden = true
            cell.lblCostPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product.ProductPrice!)"
            cell.lblCostPrice.textColor = #colorLiteral(red: 0.6993342042, green: 0.1523861289, blue: 0.1413347125, alpha: 1)
        }else{
           cell.stackMain.subviews[3].isHidden = false
            cell.lblCostPrice.attributedText = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product.ProductPrice!)".strikeThrough()
            cell.lblCostPrice.textColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)

        }
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        
        
        cell.offerPriceLabelConstant.text = ProductControllerListConstant.OfferPrice
        cell.packageLabelConstant.text = ProductControllerListConstant.Package
        
        if product.package_status == "1"{
            cell.packageStackView.isHidden = false
            
                       
            cell.offerPriceLabel.text =  "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "")" + (product.package_price ?? "")
            let product_unit = "1" + (product.product_unit ?? "")
            cell.packageLabel.text =  product_unit + " * " + (product.package_quantity ?? "")
            cell.stackViewDesTop.constant = 8
            cell.packageStackViewHeight.constant = 55
            if product.ProductQuantity == ""{
                 cell.lblQuantity.attributedText = getAttrbText(simpleText: "", text:  "")
            }else{
                var quantityUnit = "Quantity: "
                
                 if let unit =  product.product_unit{
                     let qunatity = "\(product.ProductQuantity!)"  + unit
                     quantityUnit = quantityUnit + qunatity
                     cell.lblQuantity.attributedText = getAttrbText(simpleText: qunatity, text:  quantityUnit)
                 }
                 
                
            }
            cell.stackCost.isHidden = true
            cell.offerPriceLabel.isHidden = false
            cell.lblCostPrice.text = ""
            cell.lblOfferPrice.text = ""
        }else{
            cell.stackCost.isHidden = false
            cell.offerPriceLabel.isHidden = false
            cell.packageStackView.isHidden = true
            cell.stackViewDesTop.constant = 0
            cell.packageStackViewHeight.constant = 0
        }
        
        self.loadMore(indexPath: indexPath)
        return cell
        }
        return UITableViewCell.init()
    }
    @objc func switchChanged(mySwitch: UISwitch) {
        if searchActive{
            if mySwitch.isOn == true{
                WebServiceManager.sharedInstance.changeProductStatusApi(status: "active", RefId: filteredProducts[mySwitch.tag].ProductId ?? "", adminId: Singleton.sharedInstance.retailerData.ADMINID ?? "") { msg, status in
                    if status == "1"{
                        self.getCommonFilterAPI(mainCat: "")
                        self.getProductListAPI(page: 1, commonFilter: "")
                    }else{
                
                    }
                }
            }else{
                WebServiceManager.sharedInstance.changeProductStatusApi(status: "inactive", RefId: filteredProducts[mySwitch.tag].ProductId ?? "", adminId: Singleton.sharedInstance.retailerData.ADMINID ?? "") { msg, status in
                    if status == "1"{
                        self.getCommonFilterAPI(mainCat: "")
                        self.getProductListAPI(page: 1, commonFilter: "")
                    }else{
                
                    }
                }
            }
        }else{
            if mySwitch.isOn == true{
                WebServiceManager.sharedInstance.changeProductStatusApi(status: "active", RefId: productList[mySwitch.tag].ProductId ?? "", adminId: Singleton.sharedInstance.retailerData.ADMINID ?? "") { msg, status in
                    if status == "1"{
                        self.getCommonFilterAPI(mainCat: "")
                        self.getProductListAPI(page: 1, commonFilter: "")
                    }else{
                
                    }
                }
            }else{
                WebServiceManager.sharedInstance.changeProductStatusApi(status: "inactive", RefId: productList[mySwitch.tag].ProductId ?? "", adminId: Singleton.sharedInstance.retailerData.ADMINID ?? "") { msg, status in
                    if status == "1"{
                        self.getCommonFilterAPI(mainCat: "")
                        self.getProductListAPI(page: 1, commonFilter: "")
                    }else{
                
                    }
                }
            }
        }

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
        let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
        
        if storeType.contains("manufacturing"){
            let product = list[indexPath.row]
            let vc  = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "ProductDetailManfacturingViewController") as! ProductDetailManfacturingViewController
            vc.productList = product
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let product = list[indexPath.row]
            let vc  = UIStoryboard().returnProductUI().instantiateViewController(withIdentifier: "ProductDetailController") as! ProductDetailController
            vc.productList = product
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
       
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
        
        if storeType.contains("manufacturing"){
            (cell as! ProductTableCellManfacturing).imgVwProduct.kf.cancelDownloadTask()
        }else{
            (cell as! ProductTableCell).imgVwProduct.kf.cancelDownloadTask()
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLodinData == false else{
        cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
            return}
        
        var list : [Productlist]!
        if searchActive{
            guard filteredProducts.count > 0 else{ return}
            list = filteredProducts
        }else{
            guard productList.count > 0 else{ return}
            list = productList
            }
        
        let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
        if storeType.contains("manufacturing"){
            
            let product = list[indexPath.row]
            if product.Product_Medium_Image == ""{
                //  let cell =  (cell as! CellAssignedAsset)
                (cell as! ProductTableCellManfacturing).imgVwProduct.image = #imageLiteral(resourceName: "imagePlaceholder")
            }else{
                let url = URL(string: product.productIconImage ?? "")
                _ = (cell as! ProductTableCellManfacturing).imgVwProduct.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
            }
            
        }else{
            let product = list[indexPath.row]
            if product.Product_Medium_Image == ""{
                //  let cell =  (cell as! CellAssignedAsset)
                (cell as! ProductTableCell).imgVwProduct.image = #imageLiteral(resourceName: "imagePlaceholder")
            }else{
                let url = URL(string: product.Product_Medium_Image ?? "")
                _ = (cell as! ProductTableCell).imgVwProduct.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
            }
            
            
        }
        
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
extension ProductListController:UISearchBarDelegate{
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
class ProductTableCell:UITableViewCell,ShimmeringViewProtocol{
    @IBOutlet weak var vwImgBg: UIView!
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMainCategory: UILabel!
    @IBOutlet weak var lblCostPrice: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var stackMain: UIStackView!
    
    
    @IBOutlet weak var stackCost: UIStackView!
    @IBOutlet weak var lblTDesc: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var switchStatus : UISwitch!
    
    @IBOutlet weak var offerPriceLabelConstant: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
   
    @IBOutlet weak var packageLabelConstant: UILabel!
    @IBOutlet weak var packageLabel: UILabel!
    
    @IBOutlet weak var packageStackView: UIStackView!
    
    
    @IBOutlet weak var stackViewDesTop: NSLayoutConstraint!
    @IBOutlet weak var packageStackViewHeight: NSLayoutConstraint!
    
    var shimmeringAnimatedItems: [UIView] {
        
           [
            lblTDesc,
            vwImgBg,
            lblName,
            lblMainCategory,
            lblCostPrice,
            lblOfferPrice,
            lblQuantity,
            lblDescription,
            btnEdit,
            switchStatus,
            statusLabel
           ].compactMap{ $0}
           }
    
    
       }
    
extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
class ProductTableCellManfacturing:UITableViewCell,ShimmeringViewProtocol{
    @IBOutlet weak var vwImgBg: UIView!
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMainCategory: UILabel!
    @IBOutlet weak var lblCostPrice: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var stackMain: UIStackView!
    
    
    @IBOutlet weak var stackCost: UIStackView!
    @IBOutlet weak var lblTDesc: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
  
    var shimmeringAnimatedItems: [UIView] {
        
           [
            lblTDesc,
            vwImgBg,
            lblName,
            lblMainCategory,
            lblCostPrice,
            lblOfferPrice,
            lblQuantity,
            lblDescription,
            btnEdit,
           ].compactMap{ $0}
           }
    
    
       }
    
