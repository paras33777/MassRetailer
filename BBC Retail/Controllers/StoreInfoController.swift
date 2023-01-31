//
//  StoreInfoController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 06/07/22.
//

import UIKit
import Kingfisher
import FTIndicator

class StoreInfoController: UIViewController {
//MARK: IBOUTLETS-
    @IBOutlet weak var stackButtonCurrentStore: UIStackView!
    @IBOutlet weak var imgVwStore: UIImageView!
    @IBOutlet weak var lblGpay: UILabel!
    @IBOutlet weak var lblPhonpe: UILabel!
    @IBOutlet weak var lblCOD: UILabel!
    @IBOutlet weak var lblPaytm: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblStoreType: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblRetailerName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgVwQRCode: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    //MARK: VARIABLES-
    private var storeInfo: StoreInfo!
    var store: StoreList!
    private let userDefault = UserDefaults.standard
    private var updateDashboardData:(()->Void)!
    //MARK: IBACTIONS-
    @IBAction func btnActivityAction(_ sender: UIButton) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityController") as! ActivityController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteAccountAction(_ sender: UIButton){
        let dropDown =  DropdownActionPopUp.init(title: "Are you sure you want to delete this account?",header:"",action: .YesNo, type: .deleteAccount, sender: self, image: nil,tapDismiss:true)
       
          dropDown.alertActionVC.delegate = self
    }
    @IBAction func btnSetCurrentStoreAction(_ sender: UIButton) {
        guard let store = self.store else{return}
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
    self.userDefault.save(customObject: Singleton.sharedInstance.retailerData,inKey:"retailerData")
    if let savedPerson = self.userDefault.object(forKey: "retailerData") as? Data {
        let decoder = JSONDecoder()
        if let loadedPerson = try? decoder.decode(RetailerData.self, from: savedPerson){
            print(loadedPerson.RetailerId!)
        }
    }
        FTIndicator.showToastMessage("\(store.storeName ?? "") is selected as current selection")
       // self.navigationController?.popViewController(animated: true)
        updateUI()
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
                let navController = NFNavigationController.init(rootViewController: vc)
                self.sideMenuViewController!.setContentViewController(navController, animated: true)
                self.sideMenuViewController!.hideMenuViewController()
       
    }
    
    //MARK: VIEW LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateStoreInfo()
        updateUI()
        //Check if redirected from store Icon/ Store List
        guard store != nil else{
            getStoreInfoAPI(store_id: Singleton.sharedInstance.retailerData.storeId ?? "")
            return
        }
        getStoreInfoAPI(store_id: store.storeId ?? "")

    }
    
    //MARK: - DELETE Account API
    func deleteUserAPI(){
        self.showIndicator()
        WebServiceManager.sharedInstance.deleteUserAPI { msg, status in
            self.hideIndicator()
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
    //MARK: -UPDATE UI
    func updateUI() {
        guard store != nil else{
            stackButtonCurrentStore.subviews[1].isHidden = true
            return}
        if Singleton.sharedInstance.retailerData.storeId == store.storeId{
            stackButtonCurrentStore.subviews[1].isHidden = true
        }else{
            stackButtonCurrentStore.subviews[1].isHidden = false
        }
       
    }
    //MARK: -UPDATE STORE INFO
    func updateStoreInfo(){
        guard let storeInfo = self.storeInfo else{
            guard  let retailerData = Singleton.sharedInstance.retailerData else{return}
            setImage(storeImage: retailerData.storeImageSmal ?? "")
            lblGpay.text = retailerData.googlepay?.capitalized
            lblPhonpe.text = retailerData.phonepay?.capitalized
            lblCOD.text = retailerData.COD?.capitalized
            lblPaytm.text = retailerData.paytm?.capitalized
            lblPaymentMethod.text = retailerData.paymentMethod?.capitalized
            lblStoreType.text = retailerData.storeType?.capitalized
            lblStoreName.text = retailerData.StoreName?.capitalized
            lblRetailerName.text = retailerData.ADMINNAME?.capitalized
            lblLocation.text = retailerData.location?.capitalized
            lblNumber.text = retailerData.contactNumber?.capitalized
            guard let url = URL(string: retailerData.RETAILERQRCODE!) else{return}
            imgVwQRCode.kf.setImage(with: url)
            return}
        setImage(storeImage: storeInfo.storeImageSmal ?? "")
        lblGpay.text = storeInfo.googlepay?.capitalized
        lblPhonpe.text = storeInfo.phonepay?.capitalized
        lblCOD.text = storeInfo.COD?.capitalized
        lblPaytm.text = storeInfo.paytm?.capitalized
        lblPaymentMethod.text = storeInfo.paymentMethod?.capitalized
        lblStoreType.text = storeInfo.storeType?.capitalized
        lblStoreName.text = storeInfo.storeName?.capitalized
        lblRetailerName.text = storeInfo.retailerName?.capitalized
        lblLocation.text = storeInfo.location?.capitalized
        lblNumber.text = storeInfo.contactNumber?.capitalized

        guard let url = URL(string: storeInfo.storeQrCode!) else{return}
        imgVwQRCode.kf.setImage(with: url)
       
    }
    
    func setImage(storeImage : String){
        imgVwStore.kf.indicatorType = .activity
        if let url:URL = URL(string:storeImage){
            imgVwStore.kf.setImage(with: url, completionHandler:  { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                    self.imgVwStore.image = #imageLiteral(resourceName: "storePlace")
                }
            })
           }
        }
//MARK: -  Store Info API
    func getStoreInfoAPI(store_id:String){
        WebServiceManager.sharedInstance.getStoreInfo(store_id: store_id) { storeInfo, msg, status in
            if status == "1"{
                self.storeInfo = storeInfo
                self.updateStoreInfo()
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }

}
extension StoreInfoController:DropdownActionDelegate{
    func dropdownActionBool(yesClicked: Bool, type: DropdownActionType) {
        if yesClicked{
            if type == .storeInactive{
                
            }else{

                deleteUserAPI()

            }
        }
    }
}
