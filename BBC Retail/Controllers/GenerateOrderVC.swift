//
//  GenerateOrderVC.swift
//  BBC Retail
//
//  Created by Himanshu on 07/11/22.
//

import UIKit
import CountryPickerView
import PhoneNumberKit
import FTIndicator

class GenerateOrderVC: UIViewController,UITextFieldDelegate ,goToCart{
    func cartPush() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        vc.userId = arrUserInfo?.user_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: IBOUTLET
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var imgCross: UIImageView!
    @IBOutlet weak var buttonCross: UIButton!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    //MARK: VARIABLES
    var arrUserInfo : UserInfo?
    var arrProductDetail : ProductDetails?
    var arrCartInfo : CartInfo?
    var addCountry = String()
    var countryCodePicker = CountryPickerView()
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgCross.alpha = 0
        self.buttonCross.alpha = 0
        setCountryCode()
        self.txtMobileNumber.delegate = self
    }
    func setCountryCode(){
        let phoneNumberKit = PhoneNumberKit()
        let region = Locale.current.regionCode
        let Code =  phoneNumberKit.countryCode(for: region!)
        let intValue = NSNumber(value: Code!).intValue
        txtCountryCode.text = "+91"
    }
    //MARK: FUNCTION (TEXTFIELD DELEGATE)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobileNumber{
            let maxLength = 15
            let currentString: NSString = textField.text as! NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
            
            let textf = textField.text! + string
            let count = textf.count
            if count == 0{
                imgCross.alpha = 0
                buttonCross.alpha = 0
            }else if count == 1 {
                imgCross.alpha = 0
                buttonCross.alpha = 0
            }else if count >= 2{
                imgCross.alpha = 1
                buttonCross.alpha = 1
            }
            return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtMobileNumber{
            if txtCountryCode.text == ""{
                FTIndicator.showToastMessage("Please select country code")
            }else if txtMobileNumber.text == "" {
                FTIndicator.showToastMessage("Please enter mobile number")
            }else{
                self.getUserDetails(countryCode: self.txtCountryCode.text?.replacingOccurrences(of: "+", with: "") ?? "", mobileNumber: self.txtMobileNumber.text ?? "")
                self.showIndicator()
            }
        }
    }
    //MARK: API FUNCTION
    func addToCart(productQuantity: String, product_offer_price: String, user_id: String, product_id: String, qty: String, store_type: String, inventory: String, payment_method: String){
        WebServiceManager.sharedInstance.addToCart(productQuantity: productQuantity, product_offer_price: product_offer_price, user_id: user_id, product_id: product_id, qty: qty, store_type: store_type, inventory: inventory, payment_method: payment_method) { cartInfo, msg, status in
            if status == "1"{
                self.arrCartInfo = cartInfo
                self.dismiss(animated: false)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                vc.userId = self.arrUserInfo?.user_id ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    func getUserDetails(countryCode:String, mobileNumber:String){
        WebServiceManager.sharedInstance.getUserDetails(countryCode: countryCode, mobileNumber: mobileNumber) { userInfo, msg, status in
            if status == "1"{
                self.hideIndicator()
                self.arrUserInfo = userInfo
                self.txtEmail.text = self.arrUserInfo?.email ?? ""
                self.txtFirstName.text = self.arrUserInfo?.firstname ?? ""
                self.txtLastName.text = self.arrUserInfo?.lastname ?? ""
                
            }else{
                self.hideIndicator()
                self.txtEmail.text = ""
                self.txtFirstName.text = ""
                self.txtLastName.text = "" 
            }
        }
    }
    func updateUserDetails(firstName:String,lastName:String,email:String,countryCode:String, mobileNumber:String,userId:String){
        WebServiceManager.sharedInstance.updateUserDetails(firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, mobileNumber: mobileNumber,userId: userId) { filepath, msg, status in
            if status == "1"{
                
                let scanner = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeScannerCartVC") as! QRCodeScannerCartVC
                scanner.delegate = self
                scanner.delegate1 = self
                self.present(scanner, animated: true, completion: nil)
                //                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    func getProductDetailsBySku(sku:String){
        WebServiceManager.sharedInstance.getProductDetailsBySku(sku: sku) { productDetails, msg, status in
            if status == "1"{
                self.arrProductDetail = productDetails
                self.addToCart(productQuantity: productDetails?.productQuantity ?? "", product_offer_price: productDetails?.productOfferPrice ?? "", user_id: self.arrUserInfo?.user_id ?? "", product_id: productDetails?.productId ?? "", qty: "1",store_type: Singleton.sharedInstance.retailerData.storeType ?? "", inventory: Singleton.sharedInstance.retailerData.inventory ?? "" , payment_method: Singleton.sharedInstance.retailerData.paymentMethod ?? "")
            }else{
//                FTIndicator.showToastMessage(msg)
//                self.dismiss(animated: false)
            }
        }
    }
    //MARK: BUTTON ACTION
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    @IBAction func btnCrossMobileNo(_ sender: UIButton) {
        self.txtMobileNumber.text = ""
        self.imgCross.alpha = 0
        self.buttonCross.alpha = 0
    }
    @IBAction func btnSubmit(_ sender: UIButton) {
        if txtCountryCode.text == ""{
            FTIndicator.showToastMessage("Please select country code")
        }else if txtMobileNumber.text == "" {
            FTIndicator.showToastMessage("Please enter mobile number")
        }else{
            updateUserDetails(firstName: self.txtFirstName.text ?? "", lastName: self.txtLastName.text ?? "", email: self.txtEmail.text ?? "", countryCode: self.txtCountryCode.text?.replacingOccurrences(of: "+", with: "") ?? "", mobileNumber: self.txtMobileNumber.text ?? "",userId: self.arrUserInfo?.user_id ?? "")
        }
    }
    @IBAction func btnCountryCode(_ sender: UIButton) {
        let dropDown =  DropdownPopUp.init(title: "Select Country Code", type: .countryCode, dropDownType: .apiGetSearch, data: [], sender: self)
        dropDown.dropDownVC.delegate = self
    }
}
//MARK: EXTENSION COUNTRY PICKER DELEGATE AND DATA SOURCE
extension GenerateOrderVC: CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let countryPickerView = CountryPickerView()
        countryPickerView.setCountryByCode("+91")
        self.txtCountryCode.text = country.code
        print(country.name)
    }
}
//MARK: EXTENSION DROPDOWN DELEGATE
extension GenerateOrderVC:DropDownDelegate{
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .countryCode:
            let fullNameArr = value?.name!.components(separatedBy: " ")
            let code = fullNameArr![0]
            if code == ""{
                // txtCountryCode.text = ""
            }else{
                txtCountryCode.text = "+\(code)"
            }
        default: break
        }
    }
}
//MARK: EXTENSION QRCODE SCANNER DELEGATE
extension GenerateOrderVC: QRScannerCodeDelegate1 {
    func qrCodeScanningDidCompleteWithResult1(result: String) {
        print("result:\(result)")
//        if result == ""{
//            return
//        }
        self.getProductDetailsBySku(sku: result)
        guard  let url:URL = URL(string:result) else{return}
        //  if result.contains("bbc.newforceltd.com") || result.contains("bbcuat.newforceltd.com") || result.contains("retail.maaserp.com") { //Staging
        if  result.contains("SKU") {
            //            self.barCodeId = url.lastPathComponent
            //            self.qrCodeText.text = CommonConstant.Barcodescannedsuccessfully
            //            self.tickImageView.isHidden = false
            //            self.qrCodeImageView.image = UIImage(named: "settlementReport")
            print("QR Id getting from scanning QR -->",url.lastPathComponent)
        }else{
            FTIndicator.showToastMessage(CommonConstant.InvalidQRCode)
        }
    }
    func qrCodeScanningFailedWithError1(error: String) {
        print("error:\(error)")
        self.navigationController?.dismiss(animated: true)
    }
}
