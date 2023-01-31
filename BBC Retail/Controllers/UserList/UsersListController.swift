//
//  UsersListController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 04/07/22.
//


        import UIKit
        import FTIndicator
        import UIView_Shimmer
protocol UsersListControllerDelegate{
    func selectedUser(selectedUsers:[UserList])
}
        class UsersListController: BaseViewController {
            //MARK: - IBOUTLET
            var delegate:UsersListControllerDelegate?
            @IBOutlet weak var searchBar: UISearchBar!
            @IBOutlet weak var tblVw: UITableView!
            //MARK: - VARIABLES
            private var isLodinData = true
            private var searchActive = false
            var userList = [UserList]()
            var filteredUserList = [UserList]()
            
            var selectedUser = [UserList]()
            var totalCount = Int()
            var totalPage = Int()
            var page = 1
            var pageLoading = false
            var fromSelectStore = false
            var isBackButton = false
            var isSelectUser = false
            var isSingleUser = false
            
            var isCustomer = false
            
            var updateDashboardData:(()-> Void)!
            let userDefault = UserDefaults.standard
            
            @IBOutlet weak var addButton: UIButton!
            @IBOutlet weak var addButtonHeight: NSLayoutConstraint!
                //MARK: - IBACTIONS
           
           /* @IBAction func btnSideMenuAction(_ sender: UIButton) {
                if fromSelectStore{
                    self.navigationController?.popViewController(animated: true)
                }else{
                self.sideMenuViewController?.presentLeftMenuViewController()
                }
            }*/
                //MARK: - VIEW LIFE CYCLE
            override func viewDidLoad() {
                super.viewDidLoad()
               // addToolbarToSearchKeyboard()
                
               
                self.navigationController?.navigationBar.isHidden = false
                navigationSetup()
                self.navigationController?.navigationBar.isHidden = false
                getUsersList(page: 1)
              
                 
                updateUI()
               
                addButton.setTitle(AddSalesOrderConstant.SaleOrderAdd, for: .normal)
                addButton.titleLabel?.font  = UIFont().MontserratSemiBold(size: 15)
                Utility().roundCorner(view: addButton, borderWith: 0.0, borderColor: self.themeRed, cornerRadius: 5.0)

            }
            @IBAction func btnSelectUserAction(_ sender: UIButton) {
                var list : [UserList]!
                if searchActive{
                    list = filteredUserList.filter({ user in
                        return user.isSelectUser ?? false
                    })
                }else{
                    list = userList.filter({ user in
                        return user.isSelectUser ?? false
                })
                }
                self.delegate?.selectedUser(selectedUsers: list)
                self.navigationController?.popViewController(animated: true)
                                           
                                           
            }
            @objc func menuButtonAction() {
                self.sideMenuViewController?.presentLeftMenuViewController()
            }
            @objc func backButtonpressed() {
                self.navigationController?.popViewController(animated: true)
            }
            @objc func btnAddUserAction() {
                if self.isCustomer{
                    let vc = UIStoryboard().returnUserUI().instantiateViewController(withIdentifier: "AddCustomerViewController") as! AddCustomerViewController
                    vc.updateUserList = {
                        self.getUsersList(page: 1)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = UIStoryboard().returnUserUI().instantiateViewController(withIdentifier: "AddUserController") as! AddUserController
                    vc.updateUserList = {
                        self.getUsersList(page: 1)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }
            fileprivate func navigationSetup() {
               
                
                if self.isBackButton{
                    let backButton =  self.getBackButton()
                    
         
                    backButton.0.addTarget(self, action: #selector(backButtonpressed), for: .touchUpInside)
                    
                    
                    let plusButton =  self.getPlusButton(imageName: "addUser")
                   
                    plusButton.0.addTarget(self, action: #selector(btnAddUserAction), for: .touchUpInside)
                    
                    if self.isCustomer{
                        navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: UserConstant.SelectUsers,barTintcolor: self.themeRed, titleTextColor: .white,leftBarItem: [backButton.1],rightBarItem: [plusButton.1], leftBarItem1: backButton.1)
                    }else{
                        navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: UserConstant.SelectUsers,barTintcolor: self.themeRed, titleTextColor: .white,leftBarItem: [backButton.1],rightBarItem: [plusButton.1], leftBarItem1: backButton.1)
                    }
                   
                }else{
                    let sideMenuButton =  self.getMenuButton()
                    let plusButton =  self.getPlusButton(imageName: "addUser")
                   
                    plusButton.0.addTarget(self, action: #selector(btnAddUserAction), for: .touchUpInside)
                    sideMenuButton.0.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
                    navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: UserConstant.Users,barTintcolor:  self.themeRed, titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: [plusButton.1], leftBarItem1: sideMenuButton.1)
                }
               
            }
            
            
            
            //MARK: - UPDATE UI
            func updateUI(){
                if self.isSingleUser{
                    self.addButtonHeight.constant = 0
                }  else if self.isSelectUser
                {
                    self.addButtonHeight.constant = 45
                }else{
                    self.addButtonHeight.constant = 0
                }
                
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
                if self.userList.count > 0 {
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
            func getUsersList(page:Int){
                if self.isCustomer{
                    WebServiceManager.sharedInstance.getCustomersList(page: String(page), keyword: nil) {usersList, totalPage, totalCount, msg, status in
                            self.isLodinData = false
                            if page == 1{
                                self.page = 1
                            }
                       
                         //   self.refreshControl?.endRefreshing()
                            self.tblVw.tableFooterView = nil
                            if status == "1"{
                              
                                if self.pageLoading == true && page > 1{
                                    self.pageLoading = false
                                    self.userList += usersList!
                                }else{
                                    self.userList = usersList!
                                }
                                for object in self.userList{
                                    if self.selectedUser.count > 0{
                                        for selectedUser in self.selectedUser{
                                        
                                            if object.userId == selectedUser.userId{
                                                object.isSelectUser = true
                                            }
                                            else{
                                                object.isSelectUser = false
                                            }
                                        }
                                    }else{
                                        object.isSelectUser = false
                                    }
                                    
                                }
                                
                                if self.searchActive{
                                    self.filterArrayData(text: self.searchBar.text ?? "")
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
                else{
                    
                    WebServiceManager.sharedInstance.getUsersList(page: String(page), keyword: nil) {usersList, totalPage, totalCount, msg, status in
                            self.isLodinData = false
                            if page == 1{
                                self.page = 1
                            }
                       
                         //   self.refreshControl?.endRefreshing()
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
                                for object in self.userList{
                                    if self.selectedUser.count > 0{
                                        for selectedUser in self.selectedUser{
                                        
                                            if object.memberId == selectedUser.memberId{
                                                object.isSelectUser = true
                                            }
                                            else{
                                                object.isSelectUser = false
                                            }
                                        }
                                    }else{
                                        object.isSelectUser = false
                                    }
                                    
                                }
                                
                                if self.searchActive{
                                    self.filterArrayData(text: self.searchBar.text ?? "")
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
                
           }
        extension UsersListController:UITableViewDelegate,UITableViewDataSource{
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                guard isLodinData == false else{return 5}
               
                if searchActive{
                    guard filteredUserList.count > 0 else{
                        updateNoData(message: "No data found.")
                        return 0}
                    return filteredUserList.count
                }else{
                    guard userList.count > 0 else{
                        updateNoData(message: "No data found.")
                        return 0}
                return userList.count
                }
                }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersListTableCell
                cell.selectionStyle = .none
                guard isLodinData == false else{return cell}
                cell.setTemplateWithSubviews(isLodinData)
                guard userList.count > 0 else{ return cell}
                var list : [UserList]!
                if searchActive{
                    guard filteredUserList.count > 0 else{ return cell}
                    list = filteredUserList
                }else{
                    guard userList.count > 0 else{ return cell}
                    list = userList
                }
                let user = list[indexPath.row]
                if self.isCustomer{
                    
                    cell.lblName.text = "\(user.userFirstName?.capitalized ?? "") \(user.userLastName?.capitalized ?? "")"
                    cell.lblEmail.text = user.userEmail
                    cell.lblMobile.text = "\(user.userDialCode ?? "")\(user.userMobile ?? "")"
                    cell.lblRole.text = user.userType?.capitalized
                    cell.lblStatus.text = ""
                   
                    cell.selectImage.isHidden = true
                    if isSelectUser{
                        cell.selectImage.isHidden = false
                        if let isSelectUser = list[indexPath.row].isSelectUser{
                            if isSelectUser  {
                                cell.selectImage.setImage(UIImage.init(named: "checkbox"), for: .normal)
                            }else{
                                cell.selectImage.setImage(UIImage.init(named: "unCheck"), for: .normal)
                            }
                        }
                        cell.selectImage.tag = indexPath.row
                        cell.selectImage.addTarget(self, action: #selector(selectedButton(sender: )), for: .touchUpInside)
                        
                    }
                }else{
                    
                    cell.lblName.text = "\(user.firstname?.capitalized ?? "") \(user.lastname?.capitalized ?? "")"
                    cell.lblEmail.text = user.email
                    cell.lblMobile.text = "\(user.countryCode ?? "")\(user.mobileNumber ?? "")"
                    cell.lblRole.text = user.userType?.capitalized
                    cell.lblStatus.text = user.status?.capitalized
                    if user.status!.uppercased() ==  "ACTIVE"{
                        cell.lblStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else{
                        cell.lblStatus.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
                    }
                    cell.selectImage.isHidden = true
                    if isSelectUser{
                        cell.selectImage.isHidden = false
                        if let isSelectUser = list[indexPath.row].isSelectUser{
                            if isSelectUser  {
                                cell.selectImage.setImage(UIImage.init(named: "checkbox"), for: .normal)
                            }else{
                                cell.selectImage.setImage(UIImage.init(named: "unCheck"), for: .normal)
                            }
                        }
                        cell.selectImage.tag = indexPath.row
                        cell.selectImage.addTarget(self, action: #selector(selectedButton(sender: )), for: .touchUpInside)
                        
                    }
                }
                return cell
            }
         
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                var list : [UserList]!
                if searchActive{
                    guard filteredUserList.count > 0 else{ return }
                    list = filteredUserList
                }else{
                    guard userList.count > 0 else{ return }
                    list = userList
                }
                let user = list[indexPath.row]
                
                if isSingleUser{
                    var newList  : [UserList] = []
                    newList.append(user)
                    self.delegate?.selectedUser(selectedUsers: newList)
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    let vc = UIStoryboard().returnUserUI().instantiateViewController(withIdentifier: "AddUserController") as! AddUserController
                    vc.user = user
                    vc.updateUserList = {
                    self.getUsersList(page: 1)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
//            func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//                (cell as! UsersListTableCell).imgVwStore.kf.cancelDownloadTask()
//            }
            func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                guard isLodinData == false else{
                cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                    return}
                
            }
           @objc func selectedButton(sender: UIButton!) {
               var list : [UserList] = []
               if searchActive{
                
                   list = filteredUserList
               }else{
                  
                   list = userList
               }
               if isSingleUser{
                   var newList  : [UserList] = []
                   newList.append(list[sender.tag])
                   self.delegate?.selectedUser(selectedUsers: newList)
                   self.navigationController?.popViewController(animated: true)
               }else{
                   if let isSelectUser = list[sender.tag].isSelectUser{
                       if isSelectUser{
                           list[sender.tag].isSelectUser = false
                       }else{
                           list[sender.tag].isSelectUser = true
                       }
                   }
                   self.tblVw.reloadData()
               }
               
               
            }
            
        }
        extension UsersListController:UISearchBarDelegate{
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
                if self.isCustomer{
                    filteredUserList =   userList.filter { obj in
                        let userFirstName = obj.userFirstName ?? ""
                        let userLastName = obj.userLastName ?? ""
                        let userMobile = obj.userMobile ?? ""
                        let userEmail = obj.userEmail ?? ""
                        if     userFirstName.range(of: text, options: .caseInsensitive) != nil || userLastName.range(of: text, options: .caseInsensitive) != nil  || userMobile.range(of: text, options: .caseInsensitive) != nil || userEmail.range(of: text, options: .caseInsensitive) != nil{
                            return true
                        }
                        return false
                    }
                }else{
                    filteredUserList =   userList.filter { obj in
                        let userFirstName = obj.firstname ?? ""
                        let userLastName = obj.lastname ?? ""
                        let userMobile = obj.mobileNumber ?? ""
                        let userEmail = obj.email ?? ""
                        if     userFirstName.range(of: text, options: .caseInsensitive) != nil || userLastName.range(of: text, options: .caseInsensitive) != nil  || userMobile.range(of: text, options: .caseInsensitive) != nil || userEmail.range(of: text, options: .caseInsensitive) != nil{
                            return true
                        }
                        return false
                    }
                }
                
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
                filteredUserList.removeAll()
                searchBar.text = ""
                searchBar.setShowsCancelButton(false, animated: true)
                searchBar.resignFirstResponder()
    
            }
        }
        class UsersListTableCell:UITableViewCell,ShimmeringViewProtocol{
            @IBOutlet weak var lblName: UILabel!
            @IBOutlet weak var lblEmail: UILabel!
            @IBOutlet weak var lblMobile: UILabel!
            @IBOutlet weak var lblRole: UILabel!
            @IBOutlet weak var lblStatus: UILabel!
            @IBOutlet weak var selectImage: UIButton!
            
            var shimmeringAnimatedItems: [UIView] {
                [
                    lblName,
                    lblEmail,
                    lblMobile,
                    lblRole,
                    lblStatus
                ].compactMap({$0})
               }
            
            }
