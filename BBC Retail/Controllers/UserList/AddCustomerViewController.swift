//
//  AddCustomerViewController.swift
//  BBC Retail
//
//  Created by rupinder singh on 19/01/23.
//

import UIKit
import FTIndicator
import Kingfisher
import PhoneNumberKit

class AddCustomerViewController:BaseViewController {
    //MARK: -IBOUTLET
      
        @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
        @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
        @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
        @IBOutlet weak var txtCountryCode: SkyFloatingLabelTextField!
        @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextField!
      
         @IBOutlet weak var submitButton: UIButton!
        
       
        var updateUserList:(()-> Void)!
        //MARK: -IBACTION
        @IBAction func btnSubmitAction(_ sender: UIButton) {
        ValidateTextField()
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
            
            
            txtFirstName.placeholder =  UserConstant.Firstname
            txtLastName.placeholder = UserConstant.Lastname
            txtEmail.placeholder = UserConstant.Email
            txtCountryCode.placeholder = UserConstant.CountryCode
            txtMobileNumber.placeholder = UserConstant.MobileNumber
            
            txtMobileNumber.font = UIFont().MontserratRegular(size: 13.0)
            txtLastName.font = UIFont().MontserratRegular(size: 13.0)
            txtEmail.font = UIFont().MontserratRegular(size: 13.0)
            txtCountryCode.font = UIFont().MontserratRegular(size: 13.0)
            txtMobileNumber.font = UIFont().MontserratRegular(size: 13.0)
            txtCountryCode.font = UIFont().MontserratRegular(size: 13.0)
            
            self.submitButton.setTitle(CommonConstant.Save, for: .normal)
            self.submitButton.titleLabel?.font =  UIFont().MontserratSemiBold(size: 14)
           
        
            let ob = CountryPhoneCodeAndName()
           // ob.getCountryName()
            
            if let countryCode =   ob.countryDictionary[Locale.current.regionCode ?? "IN"]{
                txtCountryCode.text =  countryCode
            }else{
                txtCountryCode.text =   "+91"
            }
            
           
            
           
        }
        @objc func backButtonpressed() {
            self.navigationController?.popViewController(animated: true)
        }
        
        fileprivate func navigationSetup() {
                let plusButton =  self.getBackButton()
           
                plusButton.0.addTarget(self, action: #selector(backButtonpressed), for: .touchUpInside)
                navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: UserConstant.AddUsers,barTintcolor: UIColor.init(named: "themeRed") ?? UIColor.yellow, titleTextColor: .white,leftBarItem: [plusButton.1],rightBarItem: nil, leftBarItem1: plusButton.1)

            
        }
        //MARK: - Update DATA
        func updateData(){
                
        }

        // MARK: - VALIDATION
        func ValidateTextField(){
        do {
          
            let firstname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtFirstName.text!, fieldName: "first name")
            let lastname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtLastName.text!, fieldName: "last name")
            if txtEmail.text! != ""{
            _ = try Validation.shared.validate(type: ValidationType.email, inputValue: txtEmail.text!, fieldName: "email")
              }
            let contryCode = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCountryCode.text!, fieldName: "country code")
            let mobileNumber = try Validation.shared.validate(type: ValidationType.mobileNumber, inputValue: txtMobileNumber.text!, fieldName: "mobile number")
           
                addUserAPI(firstname: firstname, lastname: lastname, email: txtEmail.text!, mobileNumber: mobileNumber, countryCode: contryCode)
            return
           
          
            }catch(let error){
                let message = (error as! ValidationError).message
                FTIndicator.showToastMessage(message)
            }
            
        }
       //MARK: - ADD USER API

        func addUserAPI(firstname: String, lastname: String, email: String, mobileNumber: String, countryCode: String){
            showIndicator()
            WebServiceManagerDeal.sharedInstance.addCustmerAPI(firstname: firstname, lastname: lastname, email: email, mobileNumber: mobileNumber, countryCode: countryCode) { msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.updateUserList()
                    self.txtFirstName.text = ""
                    self.txtLastName.text = ""
                    self.txtEmail.text = ""
                    self.txtCountryCode.text = ""
                    self.txtMobileNumber.text = ""
                    FTIndicator.showToastMessage("Customer added successfully!")
                }else{
                    FTIndicator.showToastMessage(msg!)
                }
            }
        }
        
            
}

    extension AddCustomerViewController:DropDownDelegate{
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
    extension AddCustomerViewController: UITextFieldDelegate{
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
            if textField == txtCountryCode{
                self.view.endEditing(true)
                let data = [DropDownModel]()
                let drop  = DropdownPopUp(title: "Select Country Code", type: .countryCode, dropDownType: .apiGetSearch, data: data, sender: self)
                drop.dropDownVC.delegate = self
                return false
            }else{
                print(textField.text!)
                return true
            }
           }
          }




class CountryPhoneCodeAndName: NSObject {
   var countryWithCode = [CountryNameWithCode]()

    var countryDictionary = ["AF":"93", "AL":"355", "DZ":"213","AS":"1", "AD":"376", "AO":"244", "AI":"1","AG":"1","AR":"54","AM":"374","AW":"297","AU":"61","AT":"43","AZ":"994","BS":"1","BH":"973","BD":"880","BB":"1","BY":"375","BE":"32","BZ":"501","BJ":"229","BM":"1","BT":"975","BA":"387","BW":"267","BR":"55","IO":"246","BG":"359","BF":"226","BI":"257","KH":"855","CM":"237","CA":"1","CV":"238","KY":"345","CF":"236","TD":"235","CL":"56","CN":"86","CX":"61","CO":"57","KM":"269","CG":"242","CK":"682","CR":"506","HR":"385","CU":"53","CY":"537","CZ":"420","DK":"45","DJ":"253","DM":"1","DO":"1","EC":"593","EG":"20","SV":"503","GQ":"240","ER":"291","EE":"372","ET":"251","FO":"298","FJ":"679","FI":"358","FR":"33","GF":"594","PF":"689","GA":"241","GM":"220","GE":"995","DE":"49","GH":"233","GI":"350","GR":"30","GL":"299","GD":"1","GP":"590","GU":"1","GT":"502","GN":"224","GW":"245","GY":"595","HT":"509","HN":"504","HU":"36","IS":"354","IN":"91","ID":"62","IQ":"964","IE":"353","IL":"972","IT":"39","JM":"1","JP":"81","JO":"962","KZ":"77","KE":"254","KI":"686","KW":"965","KG":"996","LV":"371","LB":"961","LS":"266","LR":"231","LI":"423","LT":"370","LU":"352","MG":"261","MW":"265","MY":"60","MV":"960","ML":"223","MT":"356","MH":"692","MQ":"596","MR":"222","MU":"230","YT":"262","MX":"52","MC":"377","MN":"976","ME":"382","MS":"1","MA":"212","MM":"95","NA":"264","NR":"674","NP":"977","NL":"31","AN":"599","NC":"687","NZ":"64","NI":"505","NE":"227","NG":"234","NU":"683","NF":"672","MP":"1","NO":"47","OM":"968","PK":"92","PW":"680","PA":"507","PG":"675","PY":"595","PE":"51","PH":"63","PL":"48","PT":"351","PR":"1","QA":"974","RO":"40","RW":"250","WS":"685","SM":"378","SA":"966","SN":"221","RS":"381","SC":"248","SL":"232","SG":"65","SK":"421","SI":"386","SB":"677","ZA":"27","GS":"500","ES":"34","LK":"94","SD":"249","SR":"597","SZ":"268","SE":"46","CH":"41","TJ":"992","TH":"66","TG":"228","TK":"690","TO":"676","TT":"1","TN":"216","TR":"90","TM":"993","TC":"1","TV":"688","UG":"256","UA":"380","AE":"971","GB":"44","US":"1", "UY":"598","UZ":"998", "VU":"678", "WF":"681","YE":"967","ZM":"260","ZW":"263","BO":"591","BN":"673","CC":"61","CD":"243","CI":"225","FK":"500","GG":"44","VA":"379","HK":"852","IR":"98","IM":"44","JE":"44","KP":"850","KR":"82","LA":"856","LY":"218","MO":"853","MK":"389","FM":"691","MD":"373","MZ":"258","PS":"970","PN":"872","RE":"262","RU":"7","BL":"590","SH":"290","KN":"1","LC":"1","MF":"590","PM":"508","VC":"1","ST":"239","SO":"252","SJ":"47","SY":"963","TW":"886","TZ":"255","TL":"670","VE":"58","VN":"84","VG":"284","VI":"340"]

    func getCountryName() {
        // Sorting all keys
        let keys = countryDictionary.keys
        let keysValue = keys.sorted { (first, second) -> Bool in
            let key1: String = first
            let key2: String = second
            let result = key1.compare(key2) == .orderedAscending
            return result

        }
        print(keysValue)

        for key in keysValue{
            let countryKeyValue = CountryNameWithCode()
            print(countryDictionary[key] ?? "not")
            countryKeyValue.countryCode = countryDictionary[key]!
            countryKeyValue.countryName = Locale.current.localizedString(forRegionCode: key)!
            print(Locale.current.localizedString(forRegionCode: key)!)
            countryWithCode.append(countryKeyValue)
        }
    }

   class CountryNameWithCode: NSObject {
    var countryName = ""
    var countryCode = ""

    }
}
