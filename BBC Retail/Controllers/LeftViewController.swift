//
//  Created by Admin on 03/07/19.
//  Copyright © 2019 Newforce Ltd. All rights reserved.
//
//
import UIKit
import FTIndicator
import Kingfisher
class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //MARK: ******************* IBOUTLET
    @IBOutlet weak var tblVW: UITableView!
    @IBOutlet weak var imgVwAvtar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    //MARK: ******************* VARIABLE
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let userDefaults = UserDefaults.standard
    private var sideMenu = [SideMenu]()
    var lastIndexpath = IndexPath(row: 0, section: 0)
    
    //MARK: ******************* IBACTIONS
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        let dropDown =  DropdownActionPopUp.init(title: "Are you sure you want to logout?",header:"",action: .YesNo, type: .logout, sender: self, image: nil,tapDismiss:true)
       
          dropDown.alertActionVC.delegate = self
    }
    @IBAction func btnOpenProfile(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
                let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "StoreInfoController")
                let navController = NFNavigationController.init(rootViewController: vc)
               navController.viewControllers.append(contentsOf: [vc1])
                self.sideMenuViewController!.setContentViewController(navController, animated: true)
                self.sideMenuViewController!.hideMenuViewController()
       }
   //MARK: ******************* VIEW LIFE CYCLE
    override func viewDidLoad(){
        super.viewDidLoad()
        tblVW.contentInset = UIEdgeInsets(top: 20, left: 0.0, bottom: 44.0, right: 0.0)
       // getSideMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
       // updateUI()
       checkRedirectFlow()
        sideMenu = SideMenu.getStaticMenu(type: Singleton.sharedInstance.retailerData.storeType!.lowercased(), access: Singleton.sharedInstance.retailerData.access!.lowercased())
        setImage()
        self.tblVW.reloadData()
        updateUI()
        }
    override func viewDidLayoutSubviews() {
        imgVwAvtar.layer.cornerRadius = 5 //imgVwAvtar.bounds.width / 2
       // imgVwAvtar.layer.borderColor = hexStringToUIColor(hex: Color.logoYellow.rawValue).cgColor
        //imgVwAvtar.layer.borderWidth = 3
       }
    //MARK: *** UPDATE UI
    func updateUI(){
     lblName.text = "\(Singleton.sharedInstance.retailerData.ADMINFIRSTNAME!.capitalized) \(Singleton.sharedInstance.retailerData.ADMINLASTNAME!.capitalized)"
        lblDesignation.text =  Singleton.sharedInstance.retailerData.StoreName!//"GST: \(Singleton.sharedInstance.retailerData.GSTNUMBER!)"
        
        guard let url :URL = URL(string:Singleton.sharedInstance.retailerData.RETAILERQRCODE!) else{return}
        KingfisherManager.shared.downloader.downloadImage(with: url, options: nil, progressBlock: nil, completionHandler: {  (result) in
                 //  print("\(imageUrl), from cache: \(cacheType)")
               })
    }
    //MARK: ******** LOGOUT API
    func logoutAPI(){
        WebServiceManager.sharedInstance.logoutAPI { msg, status in
            if status == "1"{
                Singleton.sharedInstance.retailerData = nil
            if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
                FTIndicator.showToastMessage(msg!)
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavi") as! UINavigationController
                let window = UIApplication.shared.keyWindow
                window?.rootViewController = homeVC
                window?.makeKeyAndVisible()
            }else{
                FTIndicator.showToastMessage(msg!)
            }
        }
      }
    //MARK: ********CHECK REDIRECT FLOW
    func checkRedirectFlow(){
//    if Singleton.sharedInstance.actionType == ActionType.timesheet{
//        Singleton.sharedInstance.actionType = ActionType.none
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ProfileController")
//        let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "ListIntTimesheetController")
//        let navController = NFNavigationController.init(rootViewController: vc)
//        navController.viewControllers.append(contentsOf: [vc1])
//        self.sideMenuViewController!.setContentViewController(navController, animated: true)
//        self.sideMenuViewController!.hideMenuViewController()
          if Singleton.sharedInstance.rediectFrom == RedirectFrom.orderGenerated{
             
              
              let vc = self.storyboard!.instantiateViewController(withIdentifier: "SalesOrderListController")
                      let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "OrderDetailController") as! OrderDetailController
              let orderDetail = OrderList.init(id: Singleton.sharedInstance.notifData.contentID,category: Singleton.sharedInstance.notifData.vertical)
              vc1.ordedrDetail = orderDetail
              vc1.isComingFromAppointment = "notification"
              
              let navController = NFNavigationController.init(rootViewController: vc)
                      navController.viewControllers.append(contentsOf: [vc1])
                      self.sideMenuViewController!.setContentViewController(navController, animated: true)
                      self.sideMenuViewController!.hideMenuViewController()
              Singleton.sharedInstance.rediectFrom = .none
            
    }
 //             else if Singleton.sharedInstance.redirectFrom == RedirectFrom.assetAssign{
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ProfileController")
//        let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "AssignedAssetController")
//        let navController = NFNavigationController.init(rootViewController: vc)
//        navController.viewControllers.append(contentsOf: [vc1])
//        self.sideMenuViewController!.setContentViewController(navController, animated: true)
//        self.sideMenuViewController!.hideMenuViewController()
//    }else if Singleton.sharedInstance.redirectFrom == RedirectFrom.notifApproval{
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreateApprovalController")
//        let vc1 = self.storyboard?.instantiateViewController(withIdentifier:"ApprovalListController" ) as! ApprovalListController
//        let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"ApproveController" ) as! ApproveController
//        let navController = NFNavigationController.init(rootViewController: vc)
//        navController.viewControllers.append(contentsOf:[vc1,vc2])
//        self.sideMenuViewController!.setContentViewController(navController, animated: true)
//        self.sideMenuViewController!.hideMenuViewController()
//     }else if Singleton.sharedInstance.redirectFrom == RedirectFrom.notifMultipleApproval{
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreateApprovalController")
//        let vc1 = self.storyboard?.instantiateViewController(withIdentifier:"ApprovalListController" ) as! ApprovalListController
//        let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"MultipleApprovalListController" ) as! MultipleApprovalListController
//        let navController = NFNavigationController.init(rootViewController: vc)
//        navController.viewControllers.append(contentsOf:[vc1,vc2])
//        self.sideMenuViewController!.setContentViewController(navController, animated: true)
//        self.sideMenuViewController!.hideMenuViewController()
//     }else if Singleton.sharedInstance.redirectFrom == RedirectFrom.notifGroups{
//         let vc = Constants.groupStoryBoard.instantiateViewController(withIdentifier: "GroupChatListController")
//         let vc1 = Constants.groupStoryBoard.instantiateViewController(withIdentifier:"ChatController" ) as! ChatController
//      //   let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"MultipleApprovalListController" ) as! MultipleApprovalListController
//         let navController = NFNavigationController.init(rootViewController: vc)
//         navController.viewControllers.append(contentsOf:[vc1])
//         self.sideMenuViewController!.setContentViewController(navController, animated: true)
//         self.sideMenuViewController!.hideMenuViewController()
//      }else if Singleton.sharedInstance.redirectFrom == RedirectFrom.notifPC{
//          let vc = Constants.groupStoryBoard.instantiateViewController(withIdentifier: "GroupChatListController")
//          let vc1 = Constants.groupStoryBoard.instantiateViewController(withIdentifier:"SingleChatController") as! SingleChatController
//       //   let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"MultipleApprovalListController" ) as! MultipleApprovalListController
//          let navController = NFNavigationController.init(rootViewController: vc)
//          navController.viewControllers.append(contentsOf:[vc1])
//          self.sideMenuViewController!.setContentViewController(navController, animated: true)
//          self.sideMenuViewController!.hideMenuViewController()
//       } else if Singleton.sharedInstance.redirectFrom == RedirectFrom.univarsal {
//        checkUniveraslInfo(linkCode: Singleton.sharedInstance.UnivApprovalCode!)
//     }
//      }
//    func checkUniveraslInfo(linkCode:String){
//        WebserviceManager.sharedInstance.getUniversalLinkInfo(linkCode: linkCode) { linkInfo, msg, status in
//            if status == "1"{
//            guard let linkData = linkInfo else{return}
//                switch linkData.module {
//                case "finance":
//                    switch linkData.type {
//                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreateApprovalController")
//                        let vc1 = self.storyboard?.instantiateViewController(withIdentifier:"ApprovalListController" ) as! ApprovalListController
//                        let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"MultipleApprovalListController" ) as! MultipleApprovalListController
//                        let navController = NFNavigationController.init(rootViewController: vc)
//                        navController.viewControllers.append(contentsOf:[vc1,vc2])
//                        self.sideMenuViewController!.setContentViewController(navController, animated: true)
//                        self.sideMenuViewController!.hideMenuViewController()
//                    case "single":
//                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreateApprovalController")
//                        let vc1 = self.storyboard?.instantiateViewController(withIdentifier:"ApprovalListController" ) as! ApprovalListController
//                        let vc2 = self.storyboard?.instantiateViewController(withIdentifier:"ApproveController" ) as! ApproveController
//                        let navController = NFNavigationController.init(rootViewController: vc)
//                        navController.viewControllers.append(contentsOf:[vc1,vc2])
//                        self.sideMenuViewController!.setContentViewController(navController, animated: true)
//                        self.sideMenuViewController!.hideMenuViewController()
//                    default:
//                        break
//                    }
//                default:
//                break
//                }
//            }else{
//
//            }
//         }
       }
    //MARK: - SET ADMIN AVTAR
    func setImage(){
        imgVwAvtar.kf.indicatorType = .activity
        guard  let retailerData = Singleton.sharedInstance.retailerData else{return}
        if let url:URL = URL(string:retailerData.storeImageSmal ?? ""){
            imgVwAvtar.kf.setImage(with: url, completionHandler:  { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                    self.imgVwAvtar.image = #imageLiteral(resourceName: "storePlace")
                }
            })
           }
        }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
      }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenu.count
    
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell
     
        let menu = sideMenu[indexPath.row]
            cell.titleLabel.text = menu.name
        cell.imgView.image = menu.imageWhite
//        if indexPath == lastIndexpath{
//        cell.imgView.image = menu.imageWhite
//        }else{
//            cell.imgView.image = menu.imageOrange
//        }
        return cell
    }
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//           (cell as! LeftViewCell).imgView.kf.cancelDownloadTask()
//       }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if Singleton.sharedInstance.sideMenu != nil{
//            let menu = Singleton.sharedInstance.sideMenu[indexPath.row]
//            let url:URL = URL(string: menu.image!)!
//            _ = (cell as! LeftViewCell).imgView.kf.setImage(with: url)
//        }
//    }
    // MARK: - UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LeftViewCell
        self.lastIndexpath = indexPath
        self.tblVW.reloadData()
        switch cell.titleLabel.text {
        case "Dashboard":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController:
            self.storyboard!.instantiateViewController(withIdentifier: "DashboardController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "QR Code":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController:
            self.storyboard!.instantiateViewController(withIdentifier: "QRVWController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Add Product":
            let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
            if storeType.contains("manufacturing")
            {
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController:
                UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "AddProductManfacturingViewController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }else{
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController:
                UIStoryboard().returnProductUI().instantiateViewController(withIdentifier: "AddProductController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }
            
        case "Product List":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: UIStoryboard().returnProductUI().instantiateViewController(withIdentifier: "ProductListController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Add Service":
            if Singleton.sharedInstance.retailerData.category == "cab service"{
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController:
                self.storyboard!.instantiateViewController(withIdentifier: "AddCabServiceViewController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }else{
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController:
                self.storyboard!.instantiateViewController(withIdentifier: "AddServiceController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }
        case "Sales Order":
           
            let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
            if storeType.contains("manufacturing")
            {
                let conroller = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "DealListVC")  as! DealListVC
                conroller.isSalesOrderDetail = true
                conroller.isWorkOrderDetail = false
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: conroller), animated: true)
                
                self.sideMenuViewController!.hideMenuViewController()
            }else
            {
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SalesOrderListController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }
        case "Work Order":
            let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
            if storeType.contains("manufacturing")
            {
                let conroller = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "DealListVC")  as! DealListVC
                conroller.isSalesOrderDetail = false
                conroller.isWorkOrderDetail = true
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: conroller), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }
        case "Add Cab":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController:
            self.storyboard!.instantiateViewController(withIdentifier: "AddCabServiceViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Cab List":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ServiceListController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Service List":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ServiceListController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Sales Order List":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SalesOrderListController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Stores":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "StoreListController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Users":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: UIStoryboard().returnUserUI().instantiateViewController(withIdentifier: "UsersListController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Storage Allocation":
            if Singleton.sharedInstance.retailerData.category == "cab service"{
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "AllocationListController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }else{
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "AllocationListController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }
          
        case "Doctor Availability":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "AllSlotsViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Appointment":
            self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "AppointmentController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case "Generate Order":
          
                self.sideMenuViewController!.setContentViewController(NFNavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "GenerateOrderVC")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            
        case "Log Out":
            print("LOG OUT")
            let dropDown =  DropdownActionPopUp.init(title: "Are you sure you want to logout?",header:"",action: .YesNo, type: .logout, sender: self, image: nil,tapDismiss:true)
              dropDown.alertActionVC.delegate = self
        default:
            break
         }
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let menu = sideMenu[indexPath.row]
        if menu.name == "Dashboard"{
            return 50
        }
        
        if menu.name == "QR Code"{
            return 50
        }
        if menu.name == "Add Product"{
            return 50
        }
        if menu.name == "Add Cab"{
            return 50
        }
        if menu.name == "Product List"{
            return 50
        }
        if menu.name == "Add Service"{
            return 50
        }
        if menu.name == "Service List"{
            return 50
        }
       
        if menu.name == "Stores"{
            return 50
        }
        if menu.name == "Users"{
            return 50
        }
        if menu.name == "Storage Allocation"{
            return 50
        }
        if menu.name == "Doctor Availability"{
            return 50
        }
        if menu.name == "Appointment"{
            return 50
        }
        if menu.name == "Generate Order"{
            return 50
        }
        if menu.name == ""{
            return 0
        }
        if menu.name == "Log Out"{
            return 50
        }
       let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
       
        if menu.name == "Sales Order"{
            return 50
        }
        if  menu.name == "Work Order"  {
            
            if storeType.contains("manufacturing"){
               return 50
            }else{
                return 0
            }
        }
        
            
       
//        print("Side menus item names ===> ",sideMenu[indexPath.row])
        return 50
    }
    }

extension LeftViewController:DropdownActionDelegate{
    func dropdownActionBool(yesClicked: Bool, type: DropdownActionType) {
        if yesClicked{
            logoutAPI()
        }else{
           
        }
    }
    
    
}
//MARK: ******************LEFT CONTROLLER TABLE CELL CLASS
class LeftViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var separatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        titleLabel.alpha = highlighted ? 0.5 : 1.0
    }
}

