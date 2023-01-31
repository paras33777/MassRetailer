//
//  ServiceListController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 30/06/22.
//


    import UIKit
    import FTIndicator
    import UIView_Shimmer

    class ServiceListController: UIViewController {
        //MARK: - IBOUTLET
        @IBOutlet weak var lblTitle: UILabel!
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var tblVw: UITableView!
        @IBOutlet weak var lbltotalCount: UILabel!
        //MARK: - VARIABLES
        private var isLodinData = true
        private var searchActive = false
        var serviceList = [Servicelist]()
        var filteredServices = [Servicelist]()
        var refreshControl: UIRefreshControl!
        var totalCount = Int()
        var totalPage = Int()
        var page = 1
        var pageLoading = false
            //MARK: - IBACTIONS
        @IBAction func btnSideMenuAction(_ sender: UIButton) {
            self.sideMenuViewController?.presentLeftMenuViewController()
        }
        //MARK: - VIEW LIFE CYCLE
        override func viewDidLoad() {
            super.viewDidLoad()
            addToolbarToSearchKeyboard()
            getServiceListAPI(page: 1)
            updateUI()

        }
        //MARK: - UPDATE UI
        func updateUI(){
            self.tblVw.tableFooterView = UIView()
            if #available(iOS 13.0, *) {
                searchBar[keyPath: \.searchTextField].font = UIFont.init(name: "Montserrat-Medium",size: 14)!
            } else {
                let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
                    let placeholderLabel       = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
                    placeholderLabel?.font     = UIFont.init(name: "Montserrat-Medium", size: 14)!
            }
        }
        //MARK: ************UPDATE NO DATA FOUND
        func updateNoData(message:String){
            if self.serviceList.count > 0 {
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
       
        //MARK: - GET PRODUCT LIST API
        func getServiceListAPI(page:Int){
            WebServiceManager.sharedInstance.getServiceList(page: String(page)){ serviceList, totalPage, totalCount, msg, status in
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
                        self.serviceList += serviceList!
                    }else{
                        self.serviceList = serviceList!
                    }
                    self.updateNoData(message: "")
                    self.tblVw.reloadData()
                 }else{
                     self.lbltotalCount.text = ""
                     self.serviceList = [Servicelist]()
                    self.updateNoData(message: msg!)
                     self.tblVw.reloadData()
                }
            }
        }
    }
    extension ServiceListController:UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard isLodinData == false else{return 5}
            if searchActive{
                return filteredServices.count
            }else{
            return serviceList.count
            }
            }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableCell
            guard isLodinData == false else{return cell}
            cell.setTemplateWithSubviews(isLodinData)
            var list : [Servicelist]!
            if searchActive{
                guard filteredServices.count > 0 else{ return cell}
                list = filteredServices
            }else{
                guard serviceList.count > 0 else{ return cell}
                list = serviceList
            }
            let service = list[indexPath.row]
            cell.lblName.text = service.ProductName?.capitalized
            if service.MainCategory == "" {
                cell.stackMain.subviews[1].isHidden = true
            }else{
                cell.stackMain.subviews[1].isHidden = false
            cell .lblMainCategory.text = service.MainCategory
            }
            cell.lblDescription.text = service.ProductSHORTDESCRIPTION
           // cell.lblQuantity.attributedText = getAttrbText(simpleText: service.ProductQuantity!, text:  "Quantity: \(product.ProductQuantity!)")
            if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital"{
                cell.lblCostPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(service.FullPrice!)"
            }else if Singleton.sharedInstance.retailerData.category?.lowercased() == "cab service"{
                cell.lblCostPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(service.FullPrice!)"
            }else{
            cell.lblOfferPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(service.HalfPrice!) (Half)"
            cell.lblCostPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(service.FullPrice!) (Full)"
            }
            if service.HalfPrice!.isEmpty{
                cell.stackMain.subviews[3].isHidden = true
            }else{
                cell.stackMain.subviews[3].isHidden = false
            }
            if service.FullPrice!.isEmpty{
                cell.stackMain.subviews[4].isHidden = true
            }else{
                cell.stackMain.subviews[4].isHidden = false
            }
//            if Double(service.ProductOfferPrice!) == Double(service.ProductPrice!){
//                cell.stackMain.subviews[3].isHidden = true
//                cell.lblCostPrice.text = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "") \(service.ProductPrice!)"
//            }else{
//
//               cell.stackMain.subviews[3].isHidden = false
//                cell.lblCostPrice.attributedText = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "") \(service.ProductPrice!)".strikeThrough()
//            }
            self.loadMore(indexPath: indexPath)
            return cell
        }
      
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
        func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            (cell as! ProductTableCell).imgVwProduct.kf.cancelDownloadTask()
        }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            guard isLodinData == false else{
            cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                return}
            
            var list : [Servicelist]!
            if searchActive{
                guard filteredServices.count > 0 else{ return}
                list = filteredServices
            }else{
                guard serviceList.count > 0 else{ return}
                list = serviceList
                }
                let product = list[indexPath.row]
                if product.ProductMediumImage == ""{
                  //  let cell =  (cell as! CellAssignedAsset)
                    (cell as! ProductTableCell).imgVwProduct.image = #imageLiteral(resourceName: "imagePlaceholder")
                }else{
                    let url:URL = URL(string: product.ProductMediumImage!)!
                    _ = (cell as! ProductTableCell).imgVwProduct.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
                }
        }
        //MARK: LOAD MORE IN TABLE
        func loadMore(indexPath : IndexPath){
            if indexPath.row == serviceList.count - 1 && !pageLoading{ // last cell
                if self.totalCount > serviceList.count && self.page <= self.totalPage { // more items to fetch
                    self.pageLoading = true
                    let vW = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  44))
                    self.showSpinner(onView :vW)
                    // showActivityIndicatory(vw: vW)
                    self.tblVw.tableFooterView = vW
                    self.tblVw.tableFooterView?.isHidden = false
                    self.page += 1
                    getServiceListAPI(page: self.page)
                }
            }
        }
    }
    extension ServiceListController:UISearchBarDelegate{
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
            filteredServices = serviceList.filter( {
            $0.ProductName!.range(of: text, options: .caseInsensitive) != nil
            })
           }
        func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
            searchActive = true
            searchBar.setShowsCancelButton(true, animated: true)
            if searchText.count > 0{
                    filterArrayData(text: searchText)
                    tblVw.reloadData()
                if filteredServices.count == 0{
                    self.lbltotalCount.text = "No Results Found"
                }else{
                    self.lbltotalCount.text = "\(String(filteredServices.count)) Results Found"
                }
               
                   
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
           
            filteredServices.removeAll()
            searchBar.text = ""
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
            
        }
    }
  
