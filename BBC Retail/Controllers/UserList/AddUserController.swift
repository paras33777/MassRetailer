//
//  AddUserController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 04/07/22.
//

import UIKit
import FTIndicator
import Kingfisher
import PhoneNumberKit

class AddUserController: BaseViewController {
//MARK: -IBOUTLET
    @IBOutlet weak var txtStoreName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCountryCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtUserRole: SkyFloatingLabelTextField!
    @IBOutlet weak var txtStatus: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var stackStatus: UIStackView!
    @IBOutlet weak var lblAddUser: UILabel!
    //MARK: -VARIABLE
    var userRole : String?
    var user : UserList!
    var updateUserList:(()-> Void)!
    //MARK: -IBACTION
    @IBAction func btnSubmitAction(_ sender: UIButton) {
    ValidateTextField()
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
    //MARK: -VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateData()

        navigationSetup()
    }
    //MARK: - Update UI
    func updateUI(){
        
        txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
        txtStoreName.placeholder = "Store Name *"
        txtFirstName.placeholder =  "First name *"
        txtLastName.placeholder = "Last name *"
        txtEmail.placeholder = "Email"
        txtCountryCode.placeholder = "Country Code *"
        txtMobileNumber.placeholder = "Mobile Number *"
        txtUserRole.placeholder = "Select Designation *"
        txtPassword.placeholder = "Password *"
        txtConfirmPassword.placeholder = "Confirm Password *"
        txtStatus.placeholder = "Select Status *"
        txtCountryCode.text = "+91"
        
        txtStoreName.isEnabled = false
        stackStatus.subviews[0].isHidden = true
        stackStatus.subviews[1].isHidden = false
        stackStatus.subviews[2].isHidden = false
    }
    @objc func backButtonpressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func navigationSetup() {
            let plusButton =  self.getBackButton()
        if self.user != nil{
            plusButton.0.addTarget(self, action: #selector(backButtonpressed), for: .touchUpInside)
            navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: UserConstant.UpdateUser,barTintcolor: UIColor.init(named: "themeRed") ?? UIColor.yellow, titleTextColor: .white,leftBarItem: [plusButton.1],rightBarItem: nil, leftBarItem1: plusButton.1)
        }else{
            plusButton.0.addTarget(self, action: #selector(backButtonpressed), for: .touchUpInside)
            navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: UserConstant.AddUsers,barTintcolor: UIColor.init(named: "themeRed") ?? UIColor.yellow, titleTextColor: .white,leftBarItem: [plusButton.1],rightBarItem: nil, leftBarItem1: plusButton.1)
        }
           
        
    }
    //MARK: - Update DATA
    func updateData(){
        guard let user = self.user else{return}
       
        txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
        txtFirstName.text = user.firstname
        txtStatus.text = user.status?.capitalized
        txtLastName.text = user.lastname
        txtEmail.text = user.email
        txtCountryCode.text = user.countryCode
        txtMobileNumber.text = user.mobileNumber
        txtUserRole.text = user.userType
        self.userRole = user.userType
        stackStatus.subviews[0].isHidden = false
        stackStatus.subviews[1].isHidden = true
        stackStatus.subviews[2].isHidden = true
       
    }

    // MARK: - VALIDATION
    func ValidateTextField(){
    do {
      
        _ = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtStoreName.text!, fieldName: "store name")
        let firstname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtFirstName.text!, fieldName: "first name")
        let lastname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtLastName.text!, fieldName: "last name")
        if txtEmail.text! != ""{
        _ = try Validation.shared.validate(type: ValidationType.email, inputValue: txtEmail.text!, fieldName: "email")
          }
        let contryCode = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCountryCode.text!, fieldName: "country code")
        let mobileNumber = try Validation.shared.validate(type: ValidationType.mobileNumber, inputValue: txtMobileNumber.text!, fieldName: "mobile number")
        _ = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtUserRole.text!, fieldName: "retailer type")
        guard self.user != nil else{
            let password = try Validation.shared.validate(type: ValidationType.password, inputValue: txtPassword.text!, fieldName: "password")
//            if  self.txtPassword.text?.isValidPassword == false{
//                throw ValidationError(AlertMessages.inValidPSW.rawValue)
//            }
             _ = try Validation.shared.compareValidate( inputValue1: password,inputValue2: txtConfirmPassword.text!)
            
            addUserAPI(firstname: firstname, lastname: lastname, email: txtEmail.text!, mobileNumber: mobileNumber, userType: userRole!, password:password, countryCode: contryCode)
        return
        }// To Update User
        let status = try Validation.shared.validate(type: ValidationType.isSelectBlank, inputValue: txtStatus.text!, fieldName: "status")
        updateUserAPI(firstname: firstname, lastname: lastname, email: txtEmail.text!, mobileNumber: mobileNumber, userType: userRole!, memberId: self.user.memberId!, countryCode: contryCode, status: status)
        }catch(let error){
            let message = (error as! ValidationError).message
            FTIndicator.showToastMessage(message)
        }
        
    }
   //MARK: - ADD USER API

    func addUserAPI(firstname: String, lastname: String, email: String, mobileNumber: String, userType: String, password: String, countryCode: String){
        showIndicator()
        WebServiceManager.sharedInstance.addUserAPI(firstname: firstname, lastname: lastname, email: email, mobileNumber: mobileNumber, userType: userType, password: password, countryCode: countryCode) { msg, status in
            self.hideIndicator()
            if status == "1"{
                self.updateUserList()
                self.txtFirstName.text = ""
                self.txtLastName.text = ""
                self.txtEmail.text = ""
                self.txtCountryCode.text = ""
                self.txtMobileNumber.text = ""
                self.txtUserRole.text = ""
                self.txtPassword.text = ""
                self.txtConfirmPassword.text = ""
                self.userRole = ""
                FTIndicator.showToastMessage("User added successfully!")
            }else{
                FTIndicator.showToastMessage(msg!)
            }
        }
    }
    //MARK: - UPDATE USER API

    func updateUserAPI(firstname: String, lastname: String, email: String, mobileNumber: String, userType: String, memberId: String, countryCode: String,status:String){
         showIndicator()
        WebServiceManager.sharedInstance.updateUserAPI(firstname: firstname, lastname: lastname, email: email, mobileNumber: mobileNumber, userType: userType, memberId: memberId, countryCode: countryCode, status: status) { msg, status in
             self.hideIndicator()
             if status == "1"{
                 self.updateUserList()
                 FTIndicator.showToastMessage(msg!)
                 self.navigationController?.popViewController(animated: true)
             }else{
                 FTIndicator.showToastMessage(msg!)
             }
           }
          }
         }

extension AddUserController:DropDownDelegate{
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .userRole:
            txtUserRole.text = value?.name
            self.userRole = value?.value
        case .countryCode:
            let fullNameArr = value?.name!.components(separatedBy: " ")
            let code = fullNameArr![0]
            if code == ""{
               // txtCountryCode.text = ""
            }else{
            txtCountryCode.text = "+\(code)"
            }
        case .userStatus:
            txtStatus.text = value?.name
        default: break
        }
    }
}
extension AddUserController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobileNumber{
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if range.location > 12 - 1 {
            textField.text?.removeLast()
        }
        return string == numberFiltered
        }else if textField == txtFirstName || textField == txtLastName{
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

            
        }else if textField == txtStoreName {
            guard range.location < 101 - 1 else{return false}
            if range.location == 0 && string == " " { // prevent space on first character
                   return false
               }

               if textField.text?.last == " " && string == " " { // allowed only single space
                   return false
               }

               if string == " " { return true } // now allowing space between name

               if string.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
                   return false
               }

               return true

        }else if textField == txtPassword ||  textField == txtConfirmPassword{
            guard range.location < 13 - 1 else{return false}
          return true
        }else if textField == txtFirstName{
            
            let maxLength = 50
            let currentString: NSString = txtFirstName.text as! NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

               return newString.length <= maxLength
       }else{
            return true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        //Apply FORUM TEXTFIELDS ACTION
        if textField == txtUserRole{
            self.view.endEditing(true)
            let data = Singleton.sharedInstance.retailerData.userRole!
            let drop  = DropdownPopUp(title: "Select Designation", type: .userRole, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }else if textField == txtCountryCode{
            self.view.endEditing(true)
            let data = [DropDownModel]()
            let drop  = DropdownPopUp(title: "Select Country Code", type: .countryCode, dropDownType: .apiGetSearch, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }else if textField == txtStatus{
            self.view.endEditing(true)
            let data = UserStatus.getStaticStatus()
            let drop  = DropdownPopUp(title: InventoryViewControllerConstant.SelectStatus, type: .userStatus, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }else{
            print(textField.text!)
            return true
        }
       }
      }
