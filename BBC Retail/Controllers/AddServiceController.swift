//
//  AddServiceController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 28/06/22.
//


import UIKit
import AVFoundation
import FTIndicator

class AddServiceController: UIViewController {
    //MARK: - IBOUTLET
    @IBOutlet weak var txtProductName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMainCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSubCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCurrency: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFull: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHalf: SkyFloatingLabelTextField!
    @IBOutlet weak var imgeVwFullCheck: UIImageView!
    @IBOutlet weak var imgeVwHalfCheck: UIImageView!
    @IBOutlet weak var imgVWProduct: UIImageView!
    @IBOutlet weak var txtHpRegFees: SkyFloatingLabelTextField!
    @IBOutlet weak var txtVWDescription: UITextView!
    @IBOutlet weak var stackMain: UIStackView!
    //MARK: - VARIABLES
    var placeholderLabel : UILabel!
    var dropdowns : Dropdowns!
    var mainID = String()
    var childID = String()
    //MARK: - IBACTIONS
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    @IBAction func btnActionCheck(_ sender: UIButton) {
        if sender.tag == 100{
            if imageCompare(image1: imgeVwFullCheck.image!, isEqualTo: UIImage(named: "checkbox")!){
                imgeVwFullCheck.image = UIImage(named: "unCheck")
                txtFull.text = ""
                txtFull.isEnabled = false
                txtFull.resignFirstResponder()
                
            }else{
                txtFull.isEnabled = true
                txtFull.becomeFirstResponder()
                imgeVwFullCheck.image = UIImage(named: "checkbox")
            }
            
            // self.package = "full"
        }else{
            if imageCompare(image1: imgeVwHalfCheck.image!, isEqualTo: UIImage(named: "checkbox")!){
                imgeVwHalfCheck.image = UIImage(named: "unCheck")
                txtHalf.text = ""
                txtHalf.isEnabled = false
                txtHalf.resignFirstResponder()
            }else{
                txtHalf.isEnabled = true
                txtHalf.becomeFirstResponder()
                imgeVwHalfCheck.image = UIImage(named: "checkbox")
            }
            //  self.package = "half"
        }
    }
    @IBAction func addProductImageAction(_ sender: UIButton) {
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
                self.imgVWProduct.image = image
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
        alertController.addAction(UIAlertAction(title: CommonConstant.Cancel, style: .default))
        alertController.addAction(UIAlertAction(title:CommonConstant.Settings, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        
        present(alertController, animated: true)
    }
    @IBAction func btnAddProductAction(_ sender: UIButton) {
        validations()
    }
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCurrency.text = UserDefaults.standard.string(forKey: "currency") ?? ""
        getMainCategories()
        addTextVWPlaceholder()
        updateUI()
        txtProductName.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // imgVWProduct.addDashedBorder(.lightGray, withWidth: 4, cornerRadius: 5, dashPattern: [6,4])
    }
    func updateUI(){
        txtHalf.isEnabled = false
        txtFull.isEnabled = false
        txtProductName.placeholder = "Service Name *"
        txtMainCategory.placeholder = "Main Category *"
        //txtHalf.placeholder = "Half Price *"
        txtFull.placeholder = "Full Price *"
        txtCurrency.placeholder = "Currency *"
        txtHpRegFees.placeholder = "Registration Fees *"
        placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
        txtVWDescription.layer.cornerRadius = 2
        txtVWDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtVWDescription.layer.borderWidth = 1
        if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital"{
            stackMain.subviews[1].isHidden = true//Main cat
            stackMain.subviews[2].isHidden = true//Sub Cat
            stackMain.subviews[4].isHidden = false//Reg Fees
            stackMain.subviews[5].isHidden = true//full half
        }else{
            stackMain.subviews[1].isHidden = false//Main cat
            stackMain.subviews[2].isHidden = false//Sub Cat
            stackMain.subviews[4].isHidden = true//Reg Fees
            stackMain.subviews[5].isHidden = false//full half
        }
    }
    //MARK: - TEXTVIEW PLACEHOLDER
    func addTextVWPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.attributedText = getAttrbText(char: "*", text: AddProductControllerConstant.Description)
        placeholderLabel.font = UIFont.init(name: "Montserrat-Regular", size: 14)!
        txtVWDescription.addSubview(placeholderLabel)
        placeholderLabel.frame = CGRect.init(x: 5, y: 5, width: 150, height: 20)
        placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
    }

    func getAttrbText(char:String,text:String) -> NSMutableAttributedString {
        let range = (text as NSString).range(of: String(text))
        let range1 = (text as NSString).range(of: String(char))
        
        let attribute = NSMutableAttributedString.init(string: text)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range1)
        return attribute
    }
    //MARK: - GET MAIN CATEGORIES
    func getMainCategories() {
        WebServiceManager.sharedInstance.getMainCategoryAPI { dropdowns, msg, status in
            if status == "1"{
                self.dropdowns = dropdowns
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
    //MARK: - ADD SERVICE API
    func addServiceAPI(productImage: UIImage, halfPrice: String, fullPrice: String,name: String, shortDescr: String, currencyType: String,  mainID: String, childID: String, grandChildID: String) {
        showIndicator()
        WebServiceManager.sharedInstance.addService(productImage: productImage, halfPrice: halfPrice, fullPrice: fullPrice,  name: name, shortDescr: shortDescr, currencyType: currencyType, mainID: mainID, childID: childID, grandChildID: grandChildID ){ msg, status in
            self.hideIndicator()
            if status == "1"{
                self.txtHalf.isEnabled = false
                self.txtFull.isEnabled = false
                self.txtProductName.text = ""
                self.txtMainCategory.text = ""
                self.txtSubCategory.text = ""
                self.txtHalf.text = ""
                self.txtFull.text = ""
                self.txtHpRegFees.text = ""
                self.txtVWDescription.text = ""
                self.childID = ""
                self.mainID = ""
                self.imgeVwFullCheck.image = UIImage(named: "unCheck")
                self.imgeVwHalfCheck.image = UIImage(named: "unCheck")
                self.imgVWProduct.image = UIImage(named: "add-image")
                self.placeholderLabel.isHidden = !self.txtVWDescription.text.isEmpty
                FTIndicator.showToastMessage("Service added successfully!")
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    //MARK: - VALIDATIONS
    
    func validations() {
        do {
            guard imageCompare(image1: self.imgVWProduct.image!, isEqualTo: UIImage(named: "add-image")!) == false else{
                FTIndicator.showToastMessage("Please select service image")
                return
            }
            if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital"{
                let productname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtProductName.text!, fieldName: "service name")
                let currency = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCurrency.text!, fieldName: "currency")
                let fees = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtHpRegFees.text!, fieldName: "registration fees")
                let description = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtVWDescription.text!, fieldName: "description")
                addServiceAPI(productImage: self.imgVWProduct.image!, halfPrice: "", fullPrice: fees, name: productname, shortDescr: description, currencyType: currency, mainID: "", childID: "", grandChildID: "")
            }else{
                var halfPrice: String!
                var fullPrice: String!
                let productname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtProductName.text!, fieldName: "service name")
                let mainCat = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtMainCategory.text!, fieldName: "main category")
                //let subCat = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtSubCategory.text!, fieldName: "sub category")
                let currency = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCurrency.text!, fieldName: "currency")
                if  txtFull.text == ""{
                    FTIndicator.showToastMessage("Please enter full price")
                    return
                }
                let img = UIImage(named: "checkbox")!
                if imageCompare(image1: img, isEqualTo: imgeVwFullCheck.image!){
                    fullPrice = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtFull.text!, fieldName: "full price")
                }else{
                    fullPrice = ""
                }
                if imageCompare(image1: img, isEqualTo: imgeVwHalfCheck.image!){
                    halfPrice = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtHalf.text!, fieldName: "half price")
                }else{
                    halfPrice = ""
                }
                if !fullPrice.isEmpty{
                    if Double(fullPrice) ?? 0 == 0{
                        FTIndicator.showToastMessage("Full price can't be equal to zero" )
                        return
                      }
                 }
                if !halfPrice.isEmpty{
                    if  Double(halfPrice) ?? 0 == 0{
                        FTIndicator.showToastMessage("Half price can't be equal to zero" )
                        return
                    }
                }
                if !fullPrice.isEmpty{
                    if Double(halfPrice) ?? 0 > Double(fullPrice) ?? 0{
                        FTIndicator.showToastMessage("Half price can't be greater than full price" )
                        return
                    }
                }
                if !fullPrice.isEmpty{
                    if Double(halfPrice) ?? 0 == Double(fullPrice) ?? 0{
                        FTIndicator.showToastMessage("Half price can't be equal to full price")
                        return
                    }
                }
                let description = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtVWDescription.text!, fieldName: "description")
                addServiceAPI(productImage: self.imgVWProduct.image!, halfPrice: halfPrice, fullPrice: fullPrice, name: productname, shortDescr: description, currencyType: currency, mainID: mainID, childID: childID, grandChildID: "")
            }
            
            
            
        } catch(let error){
            let message = (error as! ValidationError).message
            FTIndicator.showToastMessage(message)
        }
    }
}

//MARK: - UITextFieldDelegate
extension AddServiceController:UITextViewDelegate,UITextFieldDelegate,DropDownDelegate{
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .mainCategory:
            txtMainCategory.text = value?.name ?? ""
            mainID = value?.mainId ?? ""
        case .subCategory:
            txtSubCategory.text = value?.name ?? ""
            childID = value?.FKCHILDCATEGORYID ?? ""
        default: break
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        //Apply FORUM TEXTFIELDS ACTION
        if textField == txtMainCategory{
            self.view.endEditing(true)
            let data = dropdowns.mainCategory!
            let drop  = DropdownPopUp(title: "Select Main Category", type: .mainCategory, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }else if textField == txtSubCategory{
            if txtMainCategory.text! == ""{
                FTIndicator.showToastMessage("Please select main category first")
                return false
            }
            let data  = dropdowns.subCategory1!.filter( {
                $0.FKMAINCATEGORYID!.range(of: mainID, options: .caseInsensitive) != nil
            })
            let drop  = DropdownPopUp(title: "Select Sub Category", type: .subCategory, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }else{
            print(textField.text!)
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtHalf || textField == txtFull || textField == txtHpRegFees {
            if string == "" {
                return true
            }
            
            // Block multiple dot
            if (textField.text?.contains("."))! && string == "." {
                return false
            }
            
            // Check here decimal places
            if (textField.text?.contains("."))! {
                let limitDecimalPlace = 2
                let decimalPlace = textField.text?.components(separatedBy: ".").last
                if (decimalPlace?.count)! < limitDecimalPlace {
                    return true
                }
                else {
                    return false
                }
              }
            let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if range.location > 7 - 1 {
                return false
                //textField.text?.removeLast()
            }
            return true//string == numberFiltered
            
        }else if textField == txtProductName{
            
            let maxLength = 50
            let currentString: NSString = txtProductName.text as! NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

               return newString.length <= maxLength
       }else{return true}
    }
}
