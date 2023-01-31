//
//  ActivityController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 06/07/22.
//


        import UIKit
        import FTIndicator
        import UIView_Shimmer

        class ActivityController: UIViewController {
            //MARK: - IBOUTLET
            @IBOutlet weak var btnSidemenu: UIButton!
            @IBOutlet weak var searchBar: UISearchBar!
            @IBOutlet weak var tblVw: UITableView!
            //MARK: - VARIABLES
            private var isLodinData = true
            private var searchActive = false
            var loginDevices = [LoginDevices]()
            var totalCount = Int()
            var totalPage = Int()
            var page = 1
            var pageLoading = false
            var fromSelectStore = false
            var updateDashboardData:(()-> Void)!
            let userDefault = UserDefaults.standard
                //MARK: - IBACTIONS
            @IBAction func btnSideMenuAction(_ sender: UIButton) {
                    self.navigationController?.popViewController(animated: true)
            }
            @IBAction func btnLogOutAllDevicesAction(_ sender: UIButton) {
                logoutAllDevices()
            }
            //MARK: - VIEW LIFE CYCLE
            override func viewDidLoad() {
                super.viewDidLoad()
               // addToolbarToSearchKeyboard()
                getLoginDevicesAPI()
               // updateUI()

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
                if self.loginDevices.count > 0 {
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
            func getLoginDevicesAPI(){
                WebServiceManager.sharedInstance.getLoginActivity { loginDevices, msg, status in
                        self.isLodinData = false
                     //   self.refreshControl?.endRefreshing()
                        self.tblVw.tableFooterView = nil
                        if status == "1"{
                            self.loginDevices = loginDevices!
                            self.updateNoData(message: "")
                            self.tblVw.reloadData()
                         }else{
                             self.loginDevices = [LoginDevices]()
                            self.updateNoData(message: msg!)
                             self.tblVw.reloadData()
                        }
                    }
            }
            //MARK: - LOGOUT ALL DEVICES
            func logoutAllDevices(){
                showIndicator()
                WebServiceManager.sharedInstance.logoutAllDevicesApi { msg, status in
                    self.hideIndicator()
                    if status == "1"{
                        self.getLoginDevicesAPI()
                        FTIndicator.showToastMessage(msg!)
                    }else{
                        FTIndicator.showToastMessage(msg!)
                    }
                }
             }
           }
        extension ActivityController:UITableViewDelegate,UITableViewDataSource{
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                guard isLodinData == false else{return 5}
               
                return loginDevices.count
                
                }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityTableCell
                cell.selectionStyle = .none
                guard isLodinData == false else{return cell}
                cell.setTemplateWithSubviews(isLodinData)
                guard loginDevices.count > 0 else{ return cell}
                
                let device = loginDevices[indexPath.row]
                cell.lblName.text = device.deviceName?.capitalized
                cell.lblLocation.text = device.location?.capitalized
                cell.lblTime.text = device.lastactivity
                if device.location == ""{
                cell.stackVwMain.subviews[1].isHidden = true
                }else{
                cell.stackVwMain.subviews[1].isHidden = false
                }
                return cell
            }
          
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             
            }
            func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
             //   (cell as! ActivityTableCell).imgVwStore.kf.cancelDownloadTask()
            }
            func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                guard isLodinData == false else{
                cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                    return}
                
                    guard loginDevices.count > 0 else{ return}
                   
                let device = loginDevices[indexPath.row]
                switch device.browerName?.lowercased(){
                case "android":
                    (cell as! ActivityTableCell).imgVwDevice.image = UIImage(named: "android")
                case "ios":
                    (cell as! ActivityTableCell).imgVwDevice.image = UIImage(named: "ios")
                default:
                    (cell as! ActivityTableCell).imgVwDevice.image = UIImage(named: "window icon")
                }
                
//                    if store.storeImageSmal == ""{
//                      //  let cell =  (cell as! CellAssignedAsset)
//                        (cell as! ActivityTableCell).imgVwStore.image = #imageLiteral(resourceName: "imagePlaceholder")
//                    }else{
//                        let url:URL = URL(string: store.storeImageSmal!)!
//                        _ = (cell as! ActivityTableCell).imgVwStore.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
//
//                    }
            }
            
        }
        extension ActivityController:UISearchBarDelegate{
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
    //            filteredProducts = productList.filter( {
    //            $0.ProductName!.range(of: text, options: .caseInsensitive) != nil
    //            })
    //           }
    //        func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
    //            searchActive = true
    //            searchBar.setShowsCancelButton(true, animated: true)
    //            if searchText.count > 0{
    //                    filterArrayData(text: searchText)
    //                    tblVw.reloadData()
    //
    //            }
    //
    //        }
    //        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //            searchActive = false
    //            tblVw.reloadData()
    //            filteredProducts.removeAll()
    //            searchBar.text = ""
    //            searchBar.setShowsCancelButton(false, animated: true)
    //            searchBar.resignFirstResponder()
    //
    //        }
        }
        class ActivityTableCell:UITableViewCell,ShimmeringViewProtocol{
            
            @IBOutlet weak var imgVwDevice: UIImageView!
            @IBOutlet weak var lblName: UILabel!
            @IBOutlet weak var lblLocation: UILabel!
            @IBOutlet weak var lblTime: UILabel!
            @IBOutlet weak var stackVwMain: UIStackView!
            
            var shimmeringAnimatedItems: [UIView] {
                [
                    imgVwDevice,
                    lblName,
                    lblTime,
                    lblLocation,
                    stackVwMain
                ].compactMap({$0})
               }
            
        }
