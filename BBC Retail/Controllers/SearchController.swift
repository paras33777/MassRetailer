//
//  SearchController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 03/08/22.
//

    import UIKit
    import FTIndicator
    import UIView_Shimmer

    class SearchController: UIViewController {
        //MARK: - IBOUTLET
        @IBOutlet weak var lblTitle: UILabel!
        @IBOutlet weak var btnSidemenu: UIButton!
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var tblVw: UITableView!
        //MARK: - VARIABLES
        private var isLodinData = true
        private var searchActive = false
        var userList = [UserList]()
        var productList = [Productlist]()
        var totalCount = Int()
        var totalPage = Int()
        var page = 1
        var isFrom = ""
        var pageLoading = false
        var fromSearchService = false
        var updateService:((_ serviceID : String,_ name : String) -> Void)!
        var updateNurseDoc:((_ type:String,_ id:String,_ name:String)-> Void)!
        var updateReckProducts:((_ product:String,_ productId:String,_ category:String,_ categoryId:String,_ Subcategory:String,_ SubcategoryId:String)-> Void)!
        let userDefault = UserDefaults.standard
      //MARK: - IBACTIONS
       
        @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        }
            //MARK: - VIEW LIFE CYCLE
        override func viewDidLoad() {
            super.viewDidLoad()
            searchBar.becomeFirstResponder()
            addToolbarToSearchKeyboard()
            updateUI()
            if Singleton.sharedInstance.retailerData.category == "restaurant"{
                lblTitle.text = "Select worker"
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                if fromSearchService{
                   lblTitle.text = "Select Service"
                }else{
                   lblTitle.text = "Select Doctor/Nurse"
                }
            }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                if isFrom == "Select Cab"{
                    lblTitle.text = "Select Cab"
                }else{
                    lblTitle.text = "Select Driver"
                }
               
            }else{
                lblTitle.text = "Select Products"
                
            }
            
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
//            if self.userList.count > 0 {
//                self.tblVw.backgroundView = UIView()
//            }else{
//                let vwNoData = ViewNoData()
//                self.tblVw.backgroundView = vwNoData
//                vwNoData.imgVw.image = UIImage(named: "noDataFound")
//                vwNoData.center.x = self.view.center.x
//                vwNoData.center.y =  self.view.center.y
//                vwNoData.label.text = message
//            }
        }
        
        //MARK: - SEARCH PRODUCT LIST API
        func searchMemberAPI(page:Int,keyword:String){
        WebServiceManager.sharedInstance.getUsersList(page: String(page), keyword:keyword ) { userList, totalpage, totalCount, msg, status in
                if status == "1"{
                    self.userList = userList!
                    self.tblVw.reloadData()
                }else{
                FTIndicator.showToastMessage(msg!)
              }
             }
           }
        //MARK: - SEARCH SERVICE LIST API
        func searchWaiterAPI(page:Int,keyword:String){
            WebServiceManager.sharedInstance.searchWaiterList(page: "\(page)", keyword: keyword, retailerId: Singleton.sharedInstance.retailerData.RetailerId ?? ""){ userList, totalpage, totalCount, msg, status in
                if status == "1"{
                    self.userList = userList!
                    self.tblVw.reloadData()
                }else{
                    FTIndicator.showToastMessage(msg!)
                }
            }
        }
        //MARK: SEARCH PRODUCT FOR RECK
        func searchProductReck(keyword:String){
            WebServiceManager.sharedInstance.searchProductListAPI(store_id: Singleton.sharedInstance.retailerData.storeId ?? "", page: "1", keyword: keyword, vertical: "FMCG") { productList, totalpage, totalCount, msg, status in
                if status == "1"{
                    self.productList = productList!
                    self.tblVw.reloadData()
                }else{
                    FTIndicator.showToastMessage(msg!)
                }
            }
        }
        
        func searchServiceAPI(page:Int,keyword:String){
            WebServiceManager.sharedInstance.searchProductList(page: String(page),keyword: keyword) { productList, totalpage, totalCount, msg, status in
                if status == "1"{
                    self.productList = productList!
                    self.tblVw.reloadData()
                }else{
                    FTIndicator.showToastMessage(msg!)
                }
            }
        }
        func getUsersList(page:Int){
            WebServiceManager.sharedInstance.getUsersList(page: String(page), keyword: nil) {usersList, totalPage, totalCount, msg, status in
                    self.isLodinData = false
                    if page == 1{
                     self.page = 1
                    }
                 // self.refreshControl?.endRefreshing()
                    self.tblVw.tableFooterView = nil
                    if status == "1"{
                        self.totalCount = totalCount!
                        self.totalPage = totalPage!
                        if self.pageLoading == true && page > 1{
                        self.pageLoading = false
                        self.userList += usersList!
                        }else{
                        self.userList = usersList!
                        }
                        if self.searchActive{
                       // self.filterArrayData(text: self.searchBar.text ?? "")
                        }
                        self.updateNoData(message: "")
                        self.tblVw.reloadData()
                     }else{
                         self.userList = [UserList]()
                        self.updateNoData(message: msg!)
                         self.tblVw.reloadData()
                     }
                   }
                 }
               }
    extension SearchController:UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if Singleton.sharedInstance.retailerData.category == "restaurant"{
                guard self.userList.count > 0 else{
                updateNoData(message: "No data found.")
                    return 0}
                return userList.count
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                if fromSearchService{
                    guard self.productList.count > 0 else{
                    updateNoData(message: "No data found.")
                        return 0}
                    return productList.count
                }else{
                    guard userList.count > 0 else{
                        updateNoData(message: "No data found.")
                        return 0}
                return userList.count
                }
            }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                if fromSearchService{
                    guard self.productList.count > 0 else{
                    updateNoData(message: "No data found.")
                        return 0}
                    return productList.count
                }else{
                    guard userList.count > 0 else{
                        updateNoData(message: "No data found.")
                        return 0}
                return userList.count
                }
            }else{
                guard self.productList.count > 0 else{
                updateNoData(message: "No data found.")
                    return 0}
                
                
                return productList.count
            }
           
            }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableCell
            cell.selectionStyle = .none
           // guard isLodinData == false else{return cell}
          //  cell.setTemplateWithSubviews(isLodinData)
            if Singleton.sharedInstance.retailerData.category == "restaurant"{
                guard userList.count > 0 else{ return cell}
                let user = userList[indexPath.row]
                cell.lblName.text = "\(user.firstname?.capitalized ?? "") \(user.lastname?.capitalized ?? "")"
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                if fromSearchService{
                    guard productList.count > 0 else{ return cell}
                    let product = productList[indexPath.row]
                    cell.lblName.text = product.ProductName?.capitalized
                   // cell.lblStatus.text = product.
                }else{
                    guard userList.count > 0 else{ return cell}
                    let user = userList[indexPath.row]
                    cell.lblName.text = "\(user.firstname?.capitalized ?? "") \(user.lastname?.capitalized ?? "")"
                   // cell.lblStatus.text = user.status?.capitalized
                }
            }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                if fromSearchService{
                    guard productList.count > 0 else{ return cell}
                    let product = productList[indexPath.row]
                    cell.lblName.text = product.ProductName?.capitalized
                   // cell.lblStatus.text = product.
                }else{
                    guard userList.count > 0 else{ return cell}
                    let user = userList[indexPath.row]
                    cell.lblName.text = "\(user.firstname?.capitalized ?? "") \(user.lastname?.capitalized ?? "")"
                   // cell.lblStatus.text = user.status?.capitalized
                }
                
                
            }else{
                guard productList.count > 0 else{ return cell}
                let product = productList[indexPath.row]
                cell.lblName.text = product.ProductName?.capitalized
            }
          
            return cell
        }
     
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if Singleton.sharedInstance.retailerData.category == "restaurant"{
                guard userList.count > 0 else{ return }
                let user = userList[indexPath.row]
                updateNurseDoc(user.userType!,user.memberId!,"\(user.firstname!) \(user.lastname!)")
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                if fromSearchService{
                    guard productList.count > 0 else{ return}
                    let product = productList[indexPath.row]
                    updateService(product.ProductId!,product.ProductName!)
                }else{
                    guard userList.count > 0 else{ return }
                    let user = userList[indexPath.row]
                    updateNurseDoc(user.userType!,user.memberId!,"\(user.firstname!) \(user.lastname!)")
                 }

            }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                if fromSearchService{
                    guard productList.count > 0 else{ return}
                    let product = productList[indexPath.row]
                    updateService(product.ProductId!,product.ProductName!)
                }else{
                    guard userList.count > 0 else{ return }
                    let user = userList[indexPath.row]
                    updateNurseDoc(user.userType!,user.memberId!,"\(user.firstname!) \(user.lastname!)")
                 }
            }else{
                guard productList.count > 0 else{ return}
                let product = productList[indexPath.row]
               
                updateReckProducts(product.ProductName ?? "",product.ProductId ?? "",product.MainCategory ?? "",product.MAINCATEGORYID ?? "",product.CHILDCATEGORYNAME ?? "",product.CHILDCATEGORYID ?? "")
         
                print("Reck products ---> ",product.ProductName ?? "",product.ProductId ?? "",product.MainCategory ?? "",product.MAINCATEGORYID ?? "",product.CHILDCATEGORYNAME ?? "",product.CHILDCATEGORYID ?? "")
            }
             self.dismiss(animated: true)
           }
//            func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//                (cell as! UsersListTableCell).imgVwStore.kf.cancelDownloadTask()
//            }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         //   guard isLodinData == false else{
         //   cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
         //       return}
        }
        
    }
    extension SearchController:UISearchBarDelegate{
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
//        func filterArrayData(text:String){
//            filteredUserList = userList.filter( {
//            $0.firstname!.range(of: text, options: .caseInsensitive) != nil || $0.lastname!.range(of: text, options: .caseInsensitive) != nil
//            })
//           }
        func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
            searchActive = true
            searchBar.setShowsCancelButton(true, animated: true)
            if searchText.count > 0{
                if Singleton.sharedInstance.retailerData.category == "restaurant"{
                    searchWaiterAPI(page: 1, keyword: searchText)
                }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                    if fromSearchService{
                      searchServiceAPI(page: 1, keyword: searchText)
                    }else{
                        searchMemberAPI(page: 1, keyword: searchText)
                    }
                }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                    if fromSearchService{
                      searchServiceAPI(page: 1, keyword: searchText)
                    }else{
                        searchMemberAPI(page: 1, keyword: searchText)
                    }
                    
                }else{
                    searchProductReck(keyword: searchText)
                }
             
               // filterArrayData(text: searchText)
               // tblVw.reloadData()
             }

           }
       
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchActive = false
            tblVw.reloadData()
          //  filteredUserList.removeAll()
            searchBar.text = ""
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
         }
     }
    class SearchTableCell:UITableViewCell,ShimmeringViewProtocol{
        @IBOutlet weak var lblName: UILabel!
        @IBOutlet weak var lblStatus: UILabel!
        
        var shimmeringAnimatedItems: [UIView] {
            [
                lblName,
                lblStatus
            ].compactMap({$0})
           }
        
    }

//
//{\"Product_id\":\"689\",\"Product_Name\":\"test data 2\",\"Main_Category\":\"Testq\",\"MAIN_CATEGORY_ID\":\"138\",\"CHILD_CATEGORY_NAME\":\"\",\"CHILD_CATEGORY_ID\":\"\",\"Product_Image\":\"https:\\/\\/newnfresume.s3-us-west-2.amazonaws.com\\/Mass\\/BBC\\/Skills\\/skill_02_11_2022_1667393433_498514612.jpeg\",\"Product_Offer_Price\":\"400.00\",\"Product_Price\":\"400.00\",\"Cost_Price\":\"100\",\"Product_Quantity\":\"269\",\"SKU\":\"SKU_689\",\"Product_SHORT_DESCRIPTION\":\"webdgh\",\"Product_DETAIL\":\"\",\"Store_Name\":\"Simple Store INR\",\"Retailer_Id\":\"47\",\"Store_Id\":\"57\",\"Product_Medium_Image\":\"https:\\/\\/newnfresume.s3-us-west-2.amazonaws.com\\/Mass\\/BBC\\/Skills\\/medium_skill_02_11_2022_1667393433_498514612.jpeg\",\"Product_Icon_Image\":\"https:\\/\\/newnfresume.s3-us-west-2.amazonaws.com\\/Mass\\/BBC\\/Skills\\/icon_skill_02_11_2022_1667393433_498514612.jpeg\",\"product_type\":\"Product\"}
