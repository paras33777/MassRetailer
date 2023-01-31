//
//  StoreListController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 27/06/22.
//


    import UIKit
    import FTIndicator
    import UIView_Shimmer

    class StoreListController: BaseViewController {
        //MARK: - IBOUTLET
       
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var tblVw: UITableView!
        //MARK: - VARIABLES
        private var isLodinData = true
        private var searchActive = false
        var storeList = [StoreList]()
        var filterStoreList = [StoreList]()
        
        
        var totalCount = Int()
        var totalPage = Int()
        var page = 1
        var storeCurrency = [String]()
        var pageLoading = false
        var fromSelectStore = false
        var updateDashboardData:(()-> Void)!
        let userDefault = UserDefaults.standard
            //MARK: - IBACTIONS
        @IBAction func btnSideMenuAction(_ sender: UIButton) {
            if fromSelectStore{
                self.navigationController?.popViewController(animated: true)
            }else{
            self.sideMenuViewController?.presentLeftMenuViewController()
            }
        }
            //MARK: - VIEW LIFE CYCLE
        override func viewDidLoad() {
            super.viewDidLoad()
           addToolbarToSearchKeyboard()
           getStoreListAPI(page: 1)
            
            navigationSetup()
            updateUI()
        }
        //MARK: - UPDATE UI
        func updateUI(){
            self.tblVw.tableFooterView = UIView()
            
            if #available(iOS 13.0, *) {
                searchBar.backgroundColor = .clear
                searchBar[keyPath: \.searchTextField].font = UIFont.init(name: "Montserrat-Medium",size: 14)!
            }else {
                searchBar.backgroundColor = hexStringToUIColor(hex:Color.searchBarBG.rawValue)
                
                let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
                let placeholderLabel    = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
                placeholderLabel?.font  = UIFont.init(name: "Montserrat-Medium", size: 14)!
            }
            
          
            }
        
        @objc func menuButtonAction() {
            self.sideMenuViewController?.presentLeftMenuViewController()
        }
       
       
        fileprivate func navigationSetup() {
            self.navigationController?.navigationBar.isHidden = false
                let sideMenuButton =  self.getMenuButton()
                sideMenuButton.0.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
                navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: StoreListConstant.StoreList,barTintcolor:  self.themeRed, titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
        }
        
        
        //MARK: ************UPDATE NO DATA FOUND
        func updateNoData(message:String){
            if self.storeList.count > 0 {
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
        func getStoreListAPI(page:Int){
                WebServiceManager.sharedInstance.getStoresList(page: String(page)) {storeList, totalPage, totalCount, msg, status in
                    self.isLodinData = false
                    if page == 1{
                        self.page = 1
                    }
                 //   self.refreshControl?.endRefreshing()
                    self.tblVw.tableFooterView = nil
                    if status == "1"{
                        self.totalCount = totalCount!
                        self.totalPage = totalPage!
                      //  self.lbltotalCount.text = "Results Found \(String(self.totalCount))"
                        if self.pageLoading == true && page > 1{
                            self.pageLoading = false
                            self.storeList += storeList!
                        }else{
                           self.storeList = storeList!
                        }
                        self.updateNoData(message: "")
                        self.tblVw.reloadData()
                     }else{
                       //  self.lbltotalCount.text = ""
                         self.storeList = [StoreList]()
                        self.updateNoData(message: msg!)
                         self.tblVw.reloadData()
                    }
                }
        }
       }
    extension StoreListController:UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard isLodinData == false else{return 5}
           
            var store = storeList
            if searchActive{
                store = filterStoreList
                
            }
            return store.count
            }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoreListTableCell
            cell.selectionStyle = .none
            guard isLodinData == false else{return cell}
            cell.setTemplateWithSubviews(isLodinData)
            guard storeList.count > 0 else{ return cell}
            
            var store = storeList[indexPath.row]
            if searchActive{
                store = filterStoreList[indexPath.row]
                
            }
            cell.lblName.text = store.storeName?.capitalized
            cell.lblLocation.text = store.location?.capitalized
            if store.location == ""{
            cell.stackVwMain.subviews[1].isHidden = true
            }else{
            cell.stackVwMain.subviews[1].isHidden = false
            }
          
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var store = storeList[indexPath.row]
            if searchActive{
                store = filterStoreList[indexPath.row]
                
            }
//            if fromSelectStore{
                Singleton.sharedInstance.retailerData.storeId = store.storeId
                //Singleton.sharedInstance.retailerData.paymentMethod = store.paymentMethod
                Singleton.sharedInstance.retailerData.category = store.category
                Singleton.sharedInstance.retailerData.services = store.services
                Singleton.sharedInstance.retailerData.storeType = store.storeType
                Singleton.sharedInstance.retailerData.COD = store.COD
                Singleton.sharedInstance.retailerData.googlepay = store.googlepay
                Singleton.sharedInstance.retailerData.phonepay = store.phonepay
                Singleton.sharedInstance.retailerData.paytm = store.paytm
                Singleton.sharedInstance.retailerData.StoreName = store.storeName
                Singleton.sharedInstance.retailerData.location = store.location
                Singleton.sharedInstance.retailerData.RETAILERQRCODE = store.storeQrCode
                Singleton.sharedInstance.retailerData.access = store.access
                Singleton.sharedInstance.retailerData.settings = store.settings
                Singleton.sharedInstance.retailerData.userRole = store.userRole
                Singleton.sharedInstance.retailerData.taxStatus = store.taxStatus
                Singleton.sharedInstance.retailerData.taxId = store.taxId
                Singleton.sharedInstance.retailerData.taxType = store.taxType
                Singleton.sharedInstance.retailerData.taxName = store.taxName
                Singleton.sharedInstance.retailerData.taxPercentage = store.taxPercentage
                self.userDefault.save(customObject: Singleton.sharedInstance.retailerData,inKey:"retailerData")
                let arrStore = store.storeName?.split(separator:" ")
                let lastElement = arrStore?.last ?? ""
                UserDefaults.standard.setValue(lastElement, forKey: "currency")
                if let savedPerson = self.userDefault.object(forKey: "retailerData") as? Data {
                    let decoder = JSONDecoder()
                    if let loadedPerson = try? decoder.decode(RetailerData.self, from: savedPerson){
                        print(loadedPerson.RetailerId!)
                    }
                }
//            self.navigationController?.popViewController(animated: true)
            //    self.updateDashboardData()
              
//            }else {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "DashboardController") as!  DashboardController
          //      vc.store = store
                 self.navigationController?.pushViewController(vc, animated: false)
//            }
          

            
        }
        func getSymbolForCurrencyCode(code: String) -> String? {
          let locale = NSLocale(localeIdentifier: code)
          return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
        }
        func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            (cell as! StoreListTableCell).imgVwStore.kf.cancelDownloadTask()
        }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            guard isLodinData == false else{
            cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                return}
            
                guard storeList.count > 0 else{ return}
            
            var store = storeList[indexPath.row]
            if searchActive{
                store = filterStoreList[indexPath.row]
                
            }
               
                
                if store.storeImageSmal == ""{
                  //  let cell =  (cell as! CellAssignedAsset)
                    (cell as! StoreListTableCell).imgVwStore.image = #imageLiteral(resourceName: "imagePlaceholder")
                }else{
                    let url:URL = URL(string: store.storeImageSmal!)!
                    _ = (cell as! StoreListTableCell).imgVwStore.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))

                }
          }
         
       }
    extension StoreListController:UISearchBarDelegate{
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
            filterStoreList = storeList.filter( {
            $0.storeName!.range(of: text, options: .caseInsensitive) != nil
            })
           
            
           }
        func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
            searchActive = true
            searchBar.setShowsCancelButton(true, animated: true)
           if searchText.count > 0{
                    filterArrayData(text: searchText)
                    tblVw.reloadData()

            }
            if searchText == ""
            {
                filterStoreList = storeList
                tblVw.reloadData()
            }

        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchActive = false
            tblVw.reloadData()
            filterStoreList.removeAll()
           searchBar.text = ""
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()

       }
    }
    class StoreListTableCell:UITableViewCell,ShimmeringViewProtocol{
        
        @IBOutlet weak var imgVwStore: UIImageView!
        @IBOutlet weak var lblName: UILabel!
        @IBOutlet weak var lblLocation: UILabel!
        @IBOutlet weak var stackVwMain: UIStackView!
        
        var shimmeringAnimatedItems: [UIView] {
            [
                imgVwStore,
                lblName,
                lblLocation,
                stackVwMain
               ]
           }
        
    }
