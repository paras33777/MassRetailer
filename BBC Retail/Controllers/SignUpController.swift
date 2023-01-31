//
//  SignUpController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 12/04/22.
//

import UIKit
import FTIndicator
import AVFoundation
import Kingfisher
import PhoneNumberKit
import CountryPickerView
class SignUpController: UIViewController {
    // MARK: - IBOUTLET
    @IBOutlet weak var imgVwStoreImg: UIImageView!
    @IBOutlet weak var txtStoreName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtZipCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtGstNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPanNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRetailerType: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAssignQRCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCountryName: SkyFloatingLabelTextField!
    @IBOutlet weak var imgVwQRAssign: UIButton!
    
    @IBOutlet var vwSendOTP: UIView!
    @IBOutlet var vwSubmitOTP: UIView!
    @IBOutlet weak var txtCountryCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    
    @IBOutlet var  otpTextFieldView: OTPFieldView!
    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtOtpFill: OTPTextField!
    
    // MARK: - VARIABLE
    var selectedImage :UIImage!
    var adminID : String!
    var countdownTimer:Timer!
    var totalTime = 30
    var termText = "Didn't receive a code? Resend in 00:00 sec"
    let term = "Resend"
    var otp = String()
    var qrCode = String()
    var addCountry = String()
    var countryCodePicker = CountryPickerView()
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height + 60
        let x = CGFloat(0)
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let fullScreenSize :CGSize = {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let coordinate = CGSize.init(width: width, height: height)
        return coordinate
    }()
    let fullScreenOrigin: CGPoint = {
        let x = CGFloat(0)
        var y = CGFloat(UIScreen.main.bounds.origin.y)
        
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    // MARK: - IBACTIONS
    @IBAction func btnCountryCodeAction(_ sender: UIButton) {
      let dropDown =  DropdownPopUp.init(title: "Select Country Code", type: .countryCode, dropDownType: .apiGetSearch, data: [], sender: self)
        dropDown.dropDownVC.delegate = self
       }
    @IBAction func btnSendOTP(_ sender: UIButton) {
        validateCountryAndMobile()
    }
    @IBAction func btnSendOTPBack(_ sender: UIButton) {
        hideBottomVw(vw: vwSendOTP)
    }
    @IBAction func btnSubmitOTP(_ sender: UIButton) {
      
       veryfyOTP()
    }
    @IBAction func btnSubmitOTPBack(_ sender: UIButton) {
        hideBottomVw(vw: vwSubmitOTP)
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEyeAction(_ sender: UIButton) {
            if sender.tag == 100{
                if txtPassword.isSecureTextEntry{
                    sender.setImage(#imageLiteral(resourceName: "openEye"), for: .normal)
                    txtPassword.isSecureTextEntry = false
                }else{
                    sender.setImage(#imageLiteral(resourceName: "closeEye"), for: .normal)
                    txtPassword.isSecureTextEntry = true
                }
                }else{
                if txtConfirmPassword.isSecureTextEntry{
                    sender.setImage(#imageLiteral(resourceName: "openEye"), for: .normal)
                    txtConfirmPassword.isSecureTextEntry = false
                }else{
                    sender.setImage(#imageLiteral(resourceName: "closeEye"), for: .normal)
                    txtConfirmPassword.isSecureTextEntry = true
                }
            }
    }
    @IBAction func addStoreImageAction(_ sender: UIButton) {
       checkCameraAccess()
    }
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            PKCCropHelper.shared.minSizeHeight = 300
            PKCCropHelper.shared.minSizeWidth = 300
            ImgPickerController.shared.showActionSheet(vc: self)
            ImgPickerController.shared.imagePickedBlock = { (image,name) in
                // self.imgTrack = image
                self.imgVwStoreImg.image = image
               // self.updateImage(image: image)
            }
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            fatalError()
        }
    }
    func presentCameraSettings() {
        let alertController = UIAlertController(title: CommonConstant.Error,
                                                message: CommonConstant.CameraAccessisDenied,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title:CommonConstant.Cancel, style: .default))
        alertController.addAction(UIAlertAction(title:CommonConstant.Settings, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        
        present(alertController, animated: true)
    }
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        self.view.endEditing(true)
        ValidateTextField()
    }
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad(){
        super.viewDidLoad()
        setCountryCode()
        setupOtpView()
        updateUI()
        txtCountryName.delegate  = self
        txtPanNumber.delegate = self
        txtGstNumber.delegate = self
//        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
//        let country = cpv.selectedCountry
//        self.countryCodePicker.delegate = self
//        self.countryCodePicker.dataSource = self
//        self.txtCountryName.text = country.code
        
    }
    //MARK: ************* SET COUNTRY CODE
    func setCountryCode(){
        
    let phoneNumberKit = PhoneNumberKit()
    let region = Locale.current.regionCode
    let Code =  phoneNumberKit.countryCode(for: region!)
    let intValue = NSNumber(value: Code!).intValue
//        txtCountryCode.text = String("+\(intValue)")
        txtCountryCode.text = "+91"
    }
    //MARK: *************UPDATE UI
    func updateUI(){
        //imgVwStoreImg.addDashedBorder()
        txtPassword.setRightPaddingPoints(30)
        txtConfirmPassword.setRightPaddingPoints(30)
        txtStoreName.placeholder = "Store Name *"
        txtFirstName.placeholder = "First Name *"
        txtLastName.placeholder = "Last Name *"
        txtEmail.placeholder = "Email *"
        txtGstNumber.placeholder = "GST Number"
        txtPanNumber.placeholder = "PAN Number"
        txtMobileNumber.placeholder = "Mobile Number *"
        txtRetailerType.placeholder = "Select Store Type *"
        txtPassword.placeholder = "Password *"
        txtConfirmPassword.placeholder = "Confirm Password *"
        txtCountryCode.placeholder = "Country *"
        btnSubmit.isUserInteractionEnabled = false
        vwSendOTP.alpha = 0
        vwSubmitOTP.alpha = 0
        txtOtpFill.textContentType = .oneTimeCode
        self.view.addSubview(vwSendOTP)
        hideBottomVw(vw: vwSendOTP)
        self.view.addSubview(vwSubmitOTP)
        hideBottomVw(vw: vwSubmitOTP)
    }
    
    func validatePANCardNumber(_ strPANNumber : String) -> Bool{
            let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
            let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
            return panCardValidation.evaluate(with: strPANNumber)
        }
    
    
    
    // MARK: - VALIDATION
    func ValidateTextField(){
    do {
      
        if imageCompare(image1: self.imgVwStoreImg.image!, isEqualTo: UIImage(named: "add-image")!){
            
            self.selectedImage = UIImage(named:"storePlace")
        }else{
            self.selectedImage = self.imgVwStoreImg.image
        }
//        if txtPanNumber.text ?? "" == "" {
//
//        }else{
//            if validatePANCardNumber(txtPanNumber.text ?? "") == false{
//                FTIndicator.showToastMessage("PAN number is incorrect")
//                return
//            }
//        }
//        if txtGstNumber.text ?? "" == "" {
//
//        }else{
//            if txtGstNumber.isValidGST() == false{
//                FTIndicator.showToastMessage("GST number is incorrect")
//                return
//            }
//
//        }
        
        let storeName = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtStoreName.text!, fieldName: "store name")
        let firstname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtFirstName.text!, fieldName: "first name")
        let lastname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtLastName.text!, fieldName: "last name")
        let email = try Validation.shared.validate(type: ValidationType.email, inputValue: txtEmail.text!, fieldName: "email")
        //let address = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtAddress.text!, fieldName: "address")
      //  let zipCode = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtZipCode.text!, fieldName: "zip code")
       // let city = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCity.text!, fieldName: "city")
      //  let gstNumber = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtGstNumber.text!, fieldName: "GST number")
     //   let panNumber = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtPanNumber.text!, fieldName: "PAN number")
//        let phoneNumber = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtMobileNumber.text!, fieldName: "mobile number")
        let contry = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCountryName.text!, fieldName: "country")

        let contryCode = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCountryCode.text!, fieldName: "country code")
        let mobileNumber = try Validation.shared.validate(type: ValidationType.mobileNumber, inputValue: txtMobile.text!, fieldName: "mobile number")
       // let mobileNumber = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtMobile.text!, fieldName: "mobile number")
        let retailerType = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtRetailerType.text!, fieldName: "retailer type")
        let password = try Validation.shared.validate(type: ValidationType.password, inputValue: txtPassword.text!, fieldName: "password")
        let _ = try Validation.shared.compareValidate( inputValue1: password,inputValue2: txtConfirmPassword.text!)
        self.signUpAPI(storename: storeName + " \(self.addCountry)", firstname: firstname, lastname: lastname, email: email, address: txtAddress.text!, zipcode: txtZipCode.text!, gstnumber: self.txtGstNumber.text ?? "", countryCode: contryCode, mobilenumber: mobileNumber, cityname: txtCity.text!, pannumber: self.txtPanNumber.text ?? "" , admin_type: "Retailer", password: password, admin_id: self.adminID,service_group: retailerType)
        }catch(let error){
            let message = (error as! ValidationError).message
            FTIndicator.showToastMessage(message)
        }
        
    }
    func imageCompare(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: Data = image1.pngData()!
        let data2: Data = image2.pngData()!
        return data1 == (data2)
    }
    // MARK: - LOGIN API
    func signUpAPI(storename: String, firstname: String, lastname: String, email: String, address: String, zipcode: String, gstnumber: String,countryCode: String ,mobilenumber: String, cityname: String, pannumber: String, admin_type: String, password: String, admin_id: String, service_group: String){
        SKActivityIndicator.show()
        WebServiceManager.sharedInstance.signUpAPI(storename: storename, storeimage: self.selectedImage, firstname: firstname, lastname: lastname, email: email, address: address, zipcode: zipcode, gstnumber: gstnumber, mobilenumber: mobilenumber, countryCode: countryCode, cityname: cityname, pannumber: pannumber, admin_type: admin_type, password: password, admin_id: admin_id, service_group: service_group, qrCode: qrCode) { msg, status in
            SKActivityIndicator.dismiss()
            if status == "1"{
                self.navigationController?.popViewController(animated: true)
                FTIndicator.showToastMessage("Sign up successfull, Please wait for admin to activate your account!")
            }else{
                FTIndicator.showToastMessage(msg)
             }
          }
    }
    // MARK: - SEND OTP API
    func sendOTP(code:String,mobile:String){
        showIndicator()
        WebServiceManager.sharedInstance.sendOTPAPI(countryCode: code, mobile: mobile) { adminID, msg, status in
            self.hideIndicator()
           if status == "1"{
               self.totalTime = 30
               self.endTimer()
               self.startTimer()
               self.adminID = adminID!
               self.hideBottomVw(vw: self.vwSendOTP)
               self.otpTextFieldView.initializeUI()
               self.showBottomVw(vw: self.vwSubmitOTP)
            FTIndicator.showToastMessage(msg)
           }else{
            FTIndicator.showToastMessage(msg)
           }
          }
         }
        // MARK: - RESEND OTP API
    func reSendOTP(mobile_number:String,country_code:String ){
            guard let admiID = adminID else{return}
            showIndicator()
        WebServiceManager.sharedInstance.reSendOTPAPI(adminID: admiID, mobile_number: mobile_number, country_code: country_code){ adminID, msg, status in
                self.hideIndicator()
               if status == "1"{
                   self.totalTime = 30
                   self.startTimer()
                   self.adminID = adminID!
                   FTIndicator.showToastMessage(msg)
               }else{
                   FTIndicator.showToastMessage(msg)
                   self.hideIndicator()
               }
             }
            }
            // MARK: - VERIFY OTP API
            func veryfyOTP(){
                guard let admiID = adminID else{return}
                showIndicator()
                WebServiceManager.sharedInstance.verifyOTPAPI(otp: otp, adminID: admiID,countryCode: self.txtCountryCode.text ?? "",mobileNumber: self.txtMobile.text ?? ""){ adminID, msg, status in
                    self.hideIndicator()
                   if status == "1"{
                   //    self.adminID = adminID
                       self.otp = ""
                       self.hideBottomVw(vw: self.vwSubmitOTP)
                       self.txtMobileNumber.text = self.txtCountryCode.text!+self.txtMobile.text!
                       FTIndicator.showToastMessage(msg)
                   }else{
                       FTIndicator.showToastMessage(msg)
                   }
                }
            }
            }
extension SignUpController{
    //MARK: SHOW HIDE BOTTTOM SHEETS
    @objc func hideBottomVw(vw:UIView){
        //   self.inputField.text = ""
        //    self.inputField.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            vw.frame.origin = self.hiddenOrigin
            vw.layoutIfNeeded()
            vw.alpha = 0
        })
       }
    func showBottomVw(vw:UIView){
        //   style()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
            vw.frame.origin = self.fullScreenOrigin
            vw.frame = CGRect.init(origin: self.fullScreenOrigin, size: self.fullScreenSize)
            // self.inputField.becomeFirstResponder()
            vw.layoutIfNeeded()
            vw.alpha = 1
        })
    }
    //MARK: *******START UPDATE END TIMER
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        lblResend.alpha = 1
        termText = "Didn't receive a code? Resend in \(timeFormatted(totalTime)) sec"
        if totalTime != 0 {
            totalTime -= 1
            lblResend.text = termText
        } else {
            termText = "Didn't receive a code? Resend"
            lblResendOtpSet()
            endTimer()
           }
        
    }
    
    func endTimer() {
        if countdownTimer != nil{
            countdownTimer.invalidate()
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func checkRange(_ range: NSRange, contain index: Int) -> Bool{
        return index > range.location && index < range.location + range.length
    }
    func lblResendOtpSet(){
        let formattedText = addBoldText(fullString: termText, boldPartOfString: term, baseFont: UIFont.init(name: "Montserrat-Regular", size: 14.0)!, boldFont: UIFont.init(name:"Montserrat-Medium", size: 15.0)!, boldColor: hexStringToUIColor(hex: Color.logoRed.rawValue), baseColor: UIColor.lightGray)
        lblResend.attributedText = formattedText
        let tap = UITapGestureRecognizer(target:self, action: #selector(handleTermTapped))
        lblResend.addGestureRecognizer(tap)
        lblResend.isUserInteractionEnabled = true
        lblResend.textAlignment = .center
    }
    func addBoldText(fullString: String, boldPartOfString: String, baseFont: UIFont, boldFont: UIFont,boldColor:UIColor,baseColor:UIColor) -> NSAttributedString {
        
       var attributedString = NSMutableAttributedString()
        attributedString = NSMutableAttributedString(string: termText as String, attributes: [NSAttributedString.Key.font:UIFont.init(name: "Montserrat-Regular", size: 14.0)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:hexStringToUIColor(hex: Color.logoRed.rawValue), range: NSRange(location:termText.count-term.count,length:term.count))
        attributedString.addAttribute( NSAttributedString.Key.font,value:UIFont.init(name: "Montserrat-Medium", size: 15.0)!, range: NSRange(location:termText.count-term.count,length:term.count))
        return attributedString
    }
    
    //MARK: ************Handler Term Tapped
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        let termString = termText as NSString
        let termRange = termString.range(of: term)
        let tapLocation = gesture.location(in: lblResend)
        let index = lblResend.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        if checkRange(termRange, contain: index) == true {
            reSendOTP(mobile_number: txtMobile.text!, country_code: txtCountryCode.text!)
            return
        }
    }
    
}
extension SignUpController{
    
    func validateCountryAndMobile() {
        
        do {
            let country = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCountryCode.text!, fieldName: "country code")
            let mobile = try Validation.shared.validate(type: ValidationType.mobileCountryValid, inputValue: txtCountryCode.text! + txtMobile.text!, fieldName: "mobile number")
           sendOTP(code: country, mobile: txtMobile.text!)
        } catch(let error) {
            let message = (error as! ValidationError).message
            FTIndicator.showToastMessage(message)
        }
    }
}

extension SignUpController:DropDownDelegate{
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .serviceGroup:
            txtRetailerType.text = value?.name ?? ""
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
//MARK: *********** OTP Field Func
extension SignUpController:OTPFieldViewDelegate{
    func setupOtpView(){
        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 2
        self.otpTextFieldView.defaultBorderColor = UIColor.darkGray
        self.otpTextFieldView.filledBorderColor = hexStringToUIColor(hex: Color.logoRed.rawValue)
        self.otpTextFieldView.cursorColor = UIColor.blue
        self.otpTextFieldView.displayType = .underlinedBottom
        self.otpTextFieldView.fieldSize = 40
        self.otpTextFieldView.separatorSpace = 15
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
        
    }
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        if  hasEntered{
            btnSubmit.isUserInteractionEnabled = true
        }else{
            btnSubmit.isUserInteractionEnabled = false
        }
        return false
    }
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        otp = otpString
    }
}
extension SignUpController: UITextFieldDelegate{
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == txtMobile
//        {
//            let maxLength = 13
//              let currentString = (textField.text ?? "") as NSString
//              let newString = currentString.replacingCharacters(in: range, with: string)
//
//              return newString.count <= maxLength
//        }
//        {
//        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//        let compSepByCharInSet = string.components(separatedBy: aSet)
//        let numberFiltered = compSepByCharInSet.joined(separator: "")
//        if range.location > 12 - 1 {
//            FTIndicator.showToastMessage("The Mobile Number field cannot exceed 14 characters in length")
//            textField.text?.removeLast()
//        }
//        return string == numberFiltered
//        }
//        else
            if textField == txtFirstName || textField == txtLastName{
            guard range.location < 31 - 1 else{return false}
            if range.location == 0 && string == " " { // prevent space on first character
                   return false
               }

               if textField.text?.last == " " && string == " " { // allowed only single space
                   return false
               }

               if string == " " { return true } // now allowing space between name

               if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
                   return false
               }

               return true

            
//        }else if textField == txtStoreName {
//            guard range.location < 101 - 1 else{return false}
//            if range.location == 0 && string == " " { // prevent space on first character
//                   return false
//               }
//
//               if textField.text?.last == " " && string == " " { // allowed only single space
//                   return false
//               }
//
//               if string == " " { return true } // now allowing space between name
//
//               if string.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
//                   return false
//               }
//
//               return true

        }else if textField == txtAddress {
            guard range.location < 201 - 1 else{return false}
          return true
        }else if textField == txtCity {
            guard range.location < 51 - 1 else{return false}
           
            if range.location == 0 && string == " " { // prevent space on first character
                   return false
               }

               if textField.text?.last == " " && string == " " { // allowed only single space
                   return false
               }

               if string == " " { return true } // now allowing space between name

               if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
                   return false
               }

               return true

          
        }else if textField == txtZipCode {
            guard range.location < 7-1  else{return false}
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
           
            return string == numberFiltered
        }else if textField == txtPassword ||  textField == txtConfirmPassword{
            guard range.location < 13 - 1 else{return false}
          return true
        }else if textField == txtGstNumber{
            let maxLength = 16
            let currentString: NSString = textField.text as! NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if textField == txtPanNumber {
            let maxLength = 11
            let currentString: NSString = textField.text as! NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        //Apply FORUM TEXTFIELDS ACTION
        if textField == txtRetailerType{
            self.view.endEditing(true)
            let data = ServiceGroup.getStaticServiceGroup()
            let drop  = DropdownPopUp(title: "Select Store Type", type: .serviceGroup, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }else if textField == txtMobileNumber{
            self.view.endEditing(true)
            showBottomVw(vw: vwSendOTP)
           return false
   }else if textField == txtAssignQRCode{
       let scanner = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeScannerController") as! QRCodeScannerController
       scanner.delegate = self
       self.present(scanner, animated: true, completion: nil)
       return false
      }else if textField == txtCountryName{
          
          let alert = UIAlertController(style: .actionSheet, title: "Currencies")
          alert.addLocalePicker(type: .currency) { info in
              alert.title = info?.currencyCode
              alert.message = "is selected"
              // action with selected object
              self.addCountry = info?.currencyCode ?? ""
              self.txtCountryName.text = (info?.country ?? "") + " (\(info?.currencyCode ?? ""))"
              
          }
          alert.addAction(title:CommonConstant.Cancel, style: .cancel)
          alert.show()
//          self.countryCodePicker.showCountriesList(from: self)
          return false
      }else{
            print(textField.text!)
            return true
        }
       }
      }
extension SignUpController: QRScannerCodeDelegate {
    func qrCodeScanningDidCompleteWithResult(result: String) {
        print("result:\(result)")
        dismiss(animated: true)
        guard  let url:URL = URL(string:result) else{return}
       //  if result.contains("bbc.newforceltd.com") || result.contains("bbcuat.newforceltd.com") || result.contains("retail.maaserp.com") { //Staging

        if  result.contains(EndPoint.url) { 
            self.qrCode = url.lastPathComponent
            txtAssignQRCode.placeholder = "QR Code Scanned"
            imgVwQRAssign.setImage(UIImage(named: "settlementReport"), for: .normal)
            print(url.lastPathComponent)
        }else{
           FTIndicator.showToastMessage(CommonConstant.InvalidQRCode)
           
           }
        }
    
    func qrCodeScanningFailedWithError(error: String) {
        print("error:\(error)")
    }
}
extension SignUpController: CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let countryPickerView = CountryPickerView()
        countryPickerView.setCountryByCode("+91")
        self.txtCountryName.text = country.code
        print(country.name)
    }
}


