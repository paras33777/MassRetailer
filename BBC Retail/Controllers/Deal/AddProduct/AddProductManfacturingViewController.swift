//
//  AddProductManfacturingViewController.swift
//  BBC Retail
//
//  Created by rupinder singh on 15/01/23.
//

import UIKit
import AVFoundation
import FTIndicator
import SwiftPopup
class AddProductManfacturingViewController: BaseViewController
{
    
        //MARK: - IBOUTLET
 
    @IBOutlet weak var btnAddProduct: UIButton!

    @IBOutlet weak var txtProductName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMainCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSubCategory: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtGrandCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var addProductOption: UIButton!
    @IBOutlet weak var rawOptionButton: UIButton!
    
   
    @IBOutlet weak var imgVWProduct: UIImageView!
    @IBOutlet weak var txtVWDescription: UITextView!
    @IBOutlet weak var qrCodeText:UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var barCodeHeightConstraint: NSLayoutConstraint!
  
    
    //@IBOutlet weak var viewProductTax: UIView!
    @IBOutlet weak var tablebiewTaxList: UITableView!
    @IBOutlet weak var viewTaxList: UIView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonAddTax: UIButton!
    @IBOutlet weak var viewAddTax: UIView!
    
    
    @IBOutlet weak var addProductScrollView: UIScrollView!
    @IBOutlet weak var viewAddMaterial: UIView!
    @IBOutlet weak var txtMaterialName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMaterialPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMaterialQutantity: SkyFloatingLabelTextField!
    @IBOutlet weak var buttonAddMaterial: UIButton!
    
//  MARK: - VARIABLES
    var placeholderLabel : UILabel!
    var dropdowns : Dropdowns!
    var mainID = String()
    var childID = String()
    var grandChildID = String()
    var product : Productlist!
    var updateProductList : (()-> Void)!
    var barCodeId = String()
    var productDetailData: ManfacturingProductDetail?
  
    var isComingFrom = ""
    var productImageFromEdit = ""
    var unitConversionID = String()
    var dropDownUnitMeasurementList : [UnitMeasurementList]?
    
    var subSkillList : [SubSkillList]?
    var selectedSubSkillId = [String]()
    var selectedSubSkillName = [String]()
    var selectedQuantity = [String]()
    var selectedPrice = [String]()
    
    var radioSelectedImage = UIImage()
    
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addProductScrollView.isHidden = false
        self.viewAddMaterial.isHidden = true
        
        if isComingFrom == "EditProduct"{
           // btnLeftMenu.setImage(UIImage(named: "leftarrow"), for: .normal)
          
          //  guard let url = URL(string: productImageFromEdit) else{return}
           // imgVWProduct.kf.setImage(with: url,placeholder: UIImage(named: "imagePlaceholder"))
        }else{
            //btnLeftMenu.setImage(UIImage(named: "menu-icon"), for: .normal)
            
        }
        self.barCodeId = ""
        self.qrCodeText.text = CommonConstant.ScanBarcode
        self.qrCodeImageView.image = UIImage(named: "barcode")
        self.tickImageView.isHidden = true
       
        getMainCategories()
        getConversionListDropdwon()
        addTextVWPlaceholder()
        updateUI()
        updateUI_Raw()
        getProductDetail()
        txtProductName.delegate = self
        print("Status:",Singleton.sharedInstance.retailerData?.taxStatus ?? "")
        print("Type:",Singleton.sharedInstance.retailerData?.taxType ?? "")
        self.taxDetails()
        navigationSetup()
        
        radioSelectedImage = self.addProductOption.image(for: .normal) ?? UIImage()
        self.navigationController?.navigationBar.isHidden = false
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK:- ****** Navigation Setup  ********************
    fileprivate func navigationSetup() {
       
        if isComingFrom == "EditProduct"{
            let sideMenuButton =  self.getBackButton()
            sideMenuButton.0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: AddProductControllerConstant.UpdateProduct,barTintcolor: self.themeRed , titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
        }else{
            let sideMenuButton =  self.getMenuButton()
            sideMenuButton.0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
            navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: AddProductControllerConstant.AddProduct,barTintcolor: self.themeRed , titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
            
            
        }
        
    }
    @objc func backButtonAction() {
        if isComingFrom == "EditProduct"{
        self.navigationController?.popViewController(animated: true)
        }else{
            self.sideMenuViewController?.presentLeftMenuViewController()
        }
    }
        //MARK: - IBACTIONS
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
       // When Product EDITt MODE
        if product != nil{
            self.navigationController?.popViewController(animated: true)
        }else{
        self.sideMenuViewController?.presentLeftMenuViewController()
        }
    }
    @IBAction func addProductImageAction(_ sender: UIButton) {
       checkCameraAccess()
    }
    
    @IBAction func addProductOptionAction(_ sender: UIButton) {
        self.addProductScrollView.isHidden = false
        self.viewAddMaterial.isHidden = true
        self.addProductOption.setImage(radioSelectedImage, for: .normal)
        self.rawOptionButton.setImage(UIImage.init(named: "radioUnSelectedI"), for: .normal)
        
    }
    @IBAction func addRawOptionAction(_ sender: UIButton) {
        self.addProductScrollView.isHidden = true
        self.viewAddMaterial.isHidden = false
        self.rawOptionButton.setImage(radioSelectedImage, for: .normal)
        self.addProductOption.setImage(UIImage.init(named: "radioUnSelectedI"), for: .normal)
        
    }
    @IBAction func addRawMaterial(_ sender: UIButton) {
        validations_addRawMaterial()
    }
    //    MARK: - FUNCTION TABLEVIEWTAXLIST
    func makeUIAddMaterialRaw(){
        txtMaterialName.text = AddProductManfacturingViewControllerConstant.EnterMaterialName
        txtMaterialPrice.text = AddProductManfacturingViewControllerConstant.EnterMaterialPrice
        buttonAddMaterial.setTitle(AddProductManfacturingViewControllerConstant.AddRawMaterial, for: .normal)
        txtMaterialName.font = UIFont().MontserratRegular(size: 13.0)
        txtMaterialPrice.font = UIFont().MontserratRegular(size: 13.0)
        buttonAddMaterial.titleLabel?.font =  UIFont().MontserratSemiBold(size: 13.0)
    }
    
    
//    MARK: - FUNCTION TABLEVIEWTAXLIST
    func  taxDetails(){
        self.tablebiewTaxList.delegate = self
        self.tablebiewTaxList.dataSource = self
        self.viewTaxList.isHidden = true
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
        alertController.addAction(UIAlertAction(title: CommonConstant.Settings, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        
        present(alertController, animated: true)
    }
    @IBAction func btnAddProductAction(_ sender: UIButton) {
        if sender.currentTitle == AddProductControllerConstant.EditProduct{
            validations(isUpdate: true)
        }else{
            validations(isUpdate: false)
        }
    }
    @IBAction func buttonProductTaxAction(_ sender: UIButton) {
        if self.product == nil{
            let vc = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "SubSkillViewController") as! SubSkillViewController
            vc.delegate = self
            vc.selectedId = self.selectedSubSkillId
            vc.selectedName = self.selectedSubSkillName
            vc.selectedQuantity = self.selectedQuantity
            vc.selectedPrice = self.selectedPrice
            vc.show()
        }else{
            let vc = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "SubSkillViewController") as! SubSkillViewController
            vc.come = "edit"
            vc.productId = self.product.ProductId ?? ""
            vc.selectedId = self.selectedSubSkillId
            vc.selectedName = self.selectedSubSkillName
            vc.selectedQuantity = self.selectedQuantity
            vc.selectedPrice = self.selectedPrice
            vc.delegate = self
            vc.show()
        }
    }
    //MARK: - PARAS BarCode
    @IBAction func barCodeAction(_ sender: UIButton){
        let scanner = UIStoryboard().returnMain().instantiateViewController(withIdentifier: "QRCodeScannerController") as! QRCodeScannerController
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)

    }

    func updateUI(){
        let addMaterial = " " + AddProductManfacturingViewControllerConstant.AddMaterial
        buttonAddTax.setTitle(addMaterial, for: .normal)
        
        txtProductName.placeholder = AddProductControllerConstant.ProductName
        txtMainCategory.placeholder =  AddProductControllerConstant.MainCategory
        txtGrandCategory.placeholder = AddProductManfacturingViewControllerConstant.GrandCategory
        
        rawOptionButton.setTitle(AddProductManfacturingViewControllerConstant.AddRawMaterial, for: .normal)
       
        addProductOption.setTitle(AddProductManfacturingViewControllerConstant.dealAddProduct, for: .normal)
        
        
        
        txtGrandCategory.delegate = self
        
        
        placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
        txtVWDescription.layer.cornerRadius = 2
        txtVWDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtVWDescription.layer.borderWidth = 1
        
        self.viewAddTax.isHidden = false
        
    }
    func getProductDetail(){
        guard let product = self.product else {return}
        self.geProductDetailsByID(productId: product.productId ?? "")
    }
    func updateForumIfProductEdit(){
    
     //  btnLeftMenu.setImage(UIImage(named: "leftarrow"), for: .normal)
      // lblTitle.text = AddProductControllerConstant.UpdateProduct
        let addMaterial = " " + AddProductManfacturingViewControllerConstant.AddMaterial
        buttonAddTax.setTitle(addMaterial, for: .normal)
        
        
        
        
       btnAddProduct.setTitle(AddProductControllerConstant.UpdateProduct, for: .normal)
      
        txtProductName.text = productDetailData?.productName ?? ""
       txtMainCategory.text = productDetailData?.categoryName
        txtSubCategory.text = productDetailData?.childCategoryName
        txtGrandCategory.text = productDetailData?.grandChildCategoryName
        
      
     
        
        
        
        
        
      
        
       self.barCodeHeightConstraint.constant = 0
       txtVWDescription.text = product.productShortDescription
    
        mainID = productDetailData?.categoryId ?? ""
       childID = productDetailData?.childCategoryId ?? ""
       grandChildID =  productDetailData?.grandChildCategoryId ?? ""
        
        
        
       placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
       guard let url = URL(string: product.productIconImage ?? "") else{return}
       imgVWProduct.kf.setImage(with: url,placeholder: UIImage(named: "imagePlaceholder"))
       qrCodeImageView.alpha = 0
       qrCodeImageView.isHidden = true
      
        if Singleton.sharedInstance.retailerData.taxStatus ?? "" == "enable"{
            if Singleton.sharedInstance.retailerData.taxType ?? "" == "exclusive"{
                //self.viewProductTax.isHidden = false
            }else if Singleton.sharedInstance.retailerData.taxType ?? "" == "inclusive"{
                //self.viewProductTax.isHidden = false
            }else{
               // self.viewProductTax.isHidden = true
            }
        }else{
           // self.viewProductTax.isHidden = true
        }
        
    }
   
    //MARK: - TEXTVIEW PLACEHOLDER
    func addTextVWPlaceholder(){
                placeholderLabel = UILabel()
        placeholderLabel.attributedText = getAttrbText(char: "*", text: AddProductControllerConstant.Description)
                placeholderLabel.font = UIFont.init(name: "Montserrat-Regular", size: 14)!
                txtVWDescription.addSubview(placeholderLabel)
                placeholderLabel.frame = CGRect.init(x: 5, y: 5, width: 150, height: 20)
                placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
    }
    func getAttrbText(char:String,text:String) -> NSMutableAttributedString{
    
            let range = (text as NSString).range(of: String(text))
            let range1 = (text as NSString).range(of: String(char))
    
            let attribute = NSMutableAttributedString.init(string: text)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: range)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range1)
            return attribute
        }
    //MARK: - GET MAIN CATEGORIES
    func getMainCategories(){
        WebServiceManager.sharedInstance.getMainCategoryAPI { dropdowns, msg, status in
            if status == "1"{
            self.dropdowns = dropdowns
            }else{
            FTIndicator.showToastMessage(msg)
            }
          }
       }
    
    //MARK: - GET MAIN CATEGORIES
    func getConversionListDropdwon(){
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId!,
            "role":Singleton.sharedInstance.retailerData.access!,
        ] as [String : Any]
        WebServiceManager.sharedInstance.getConversionListDropdwonAPI(parameters:params) { dropdowns, msg, status in
            if status == "1"{
            self.dropDownUnitMeasurementList = dropdowns
            }else{
            FTIndicator.showToastMessage(msg)
            }
          }
       }
    
//MARK: - GET ProductDetails BY ID
    func geProductDetailsByID(productId:String){
        WebServiceManagerDeal.sharedInstance.getManufacturingProductsDetail(product_id: productId) {taxlist,msg, status in
            if status == "1"{
                self.productDetailData = taxlist
                print(self.productDetailData!)
                
                self.selectedSubSkillId.removeAll()
                self.selectedSubSkillName.removeAll()
                
                for i in self.productDetailData?.subSkillsList ?? []{
                    self.selectedSubSkillId.append(i.id ?? "")
                    self.selectedSubSkillName.append(i.name ?? "")
                }
                self.viewTaxList.isHidden = true
                self.viewAddTax.isHidden = true
                self.buttonAddTax.isHidden = true
             /*   if self.productDetailData?.taxList?.count ?? 0 == 0{
                    self.viewTaxList.isHidden = true
                }else{
                    
                    self.viewTaxList.isHidden = false
                    self.tableviewHeight.constant = CGFloat(self.productDetailData?.taxList?.count ?? 0) * 50
                }*/
                self.updateForumIfProductEdit()
                self.tablebiewTaxList.reloadData()
            }else{
                FTIndicator.showToastMessage(msg)
            }
          }
    }
    //MARK: - ADD PRODUCT API
    func addProductAPI(productImage: UIImage,  name: String, shortDescr: String, currencyType: String, mainID: String, childID: String, grandChildID: String,subSkills:String){
        showIndicator()
        var childID1 = childID
        if childID1 == "0"{
            childID1 = ""
        }
        WebServiceManagerDeal.sharedInstance.addProduct(productImage: productImage, name: name, shortDescr: shortDescr, currencyType: currencyType, mainID: mainID, childID: childID, grandChildID: grandChildID, barcodeId: self.barCodeId, subSkills: subSkills) { msg, status in
            self.hideIndicator()
            if status == "1"{
                self.txtProductName.text = ""
                self.txtMainCategory.text = ""
                self.txtSubCategory.text = ""
                
//                self.txtCurrency.text = ""
                self.txtVWDescription.text = ""
                self.childID = ""
                self.mainID = ""
                self.grandChildID = ""
                
                
                self.selectedSubSkillId.removeAll()
                self.selectedSubSkillName.removeAll()
                
                self.tablebiewTaxList.reloadData()
                self.tableviewHeight.constant = 0
                self.imgVWProduct.image = UIImage(named:"add-image")
                FTIndicator.showToastMessage(AddProductControllerConstant.ProductAddedSuccessfully)

            }else{
                FTIndicator.showToastMessage(msg)
            }
          }
       }
    //MARK: - EDIT PRODUCT API
    func editProductAPI(productImage: UIImage,  name: String, shortDescr: String, currencyType: String, mainID: String, childID: String, productID: String, grandChildID: String,subSkills:String){
        showIndicator()
        var childID1 = childID
        if childID1 == "0"{
            childID1 = ""
        }
        
        WebServiceManagerDeal.sharedInstance.editProduct_manfacturing(productImage: productImage, grandChildID: grandChildID, name: name, shortDescr: shortDescr, currencyType: currencyType, mainID: mainID, childID: childID, productID: productID, subSkills: subSkills) { msg, status in
            self.hideIndicator()
            if status == "1"{
                self.updateProductList()
                FTIndicator.showToastMessage(AddProductControllerConstant.ProductUpdatedSuccessfully)
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
          }
        
       }
    //MARK: - VALIDATIONS
    func validations(isUpdate:Bool){
        do {
            guard imageCompare(image1: self.imgVWProduct.image!, isEqualTo: UIImage(named: "add-image")!) == false else{
                FTIndicator.showToastMessage(AddProductControllerConstant.PleaseSelectProductImage)
                return
             }
            let productname = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtProductName.text!, fieldName: "product name")
            
            
          
            let mainCat = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtMainCategory.text!, fieldName: "main category")
            let subCat = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtSubCategory.text!, fieldName: "sub category")
            let subCat2 = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtGrandCategory.text!, fieldName: "Grand Child category")
            
            var skillArray :[[String:String]] = []
                if self.product == nil{
                    if self.selectedSubSkillId.count == 0{
                        FTIndicator.showToastMessage(AddProductManfacturingViewControllerConstant.PleaseSelectMaterial )
                        return
                    }
                    for (index,_) in self.selectedSubSkillId.enumerated(){
                        var dict : [String:String] = [:]
                        dict["name"] = self.selectedSubSkillName[index]
                        dict["quantity"] = self.selectedQuantity[index]
                        dict["price"] = self.selectedPrice[index]
                        skillArray.append(dict)
                    }
                }else{
                   
                }
          
           
            guard let skillString =  self.json(from: skillArray) else { return  }
           
            let description = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtVWDescription.text!, fieldName: "description")
            

            guard product != nil else {
                addProductAPI(productImage: self.imgVWProduct.image!, name: productname, shortDescr: description, currencyType: "", mainID: mainID, childID: childID, grandChildID: self.grandChildID, subSkills: skillString)
                
                
                return
                
            }
            editProductAPI(productImage: self.imgVWProduct.image!, name: productname, shortDescr: description, currencyType: "", mainID: mainID, childID: childID, productID: product.productId ?? "", grandChildID: self.grandChildID, subSkills: "")
            
            } catch(let error){
              let message = (error as! ValidationError).message
                FTIndicator.showToastMessage(message)
              }
            }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

       }


    //MARK: - UITextFieldDelegate
extension AddProductManfacturingViewController:UITextViewDelegate,UITextFieldDelegate,DropDownDelegate{
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .mainCategory:
            txtMainCategory.text = value?.name ?? ""
            mainID = value?.mainId ?? ""
        case .subCategory:
            txtSubCategory.text = value?.name ?? ""
            childID = value?.FKCHILDCATEGORYID ?? ""
        case  .fkGrandChildCategoryId:
            txtGrandCategory.text = value?.name ?? ""
            grandChildID = value?.FKGRANDCHILDCATEGORYID ?? ""
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
            let data1 = dropdowns.mainCategory!
           // MainCategory(id:data.id,name:data.n)
            
            
            var data: [MainCategory] = []
            for object in data1{
            let data11 =    MainCategory(id1: object.id ?? "", name1: object.name ?? "", mainId1: object.mainId ?? "", dbName1: object.dbname ?? "")
                
                data.append(data11)
            }
           
            
            let drop  = DropdownPopUp(title: "Select Main Category", type: .mainCategory, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }else if textField == txtSubCategory{
            if txtMainCategory.text! == ""{
                FTIndicator.showToastMessage(AddProductControllerConstant.Pleaseselectmaincategoryfirst)
                return false
            }
            let data  = dropdowns.subCategory1!.filter( {
                $0.FKMAINCATEGORYID!.range(of: mainID, options: .caseInsensitive) != nil
            })
            let drop  = DropdownPopUp(title: AddProductControllerConstant.SelectSubCategory, type: .subCategory, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }
        else if textField == txtGrandCategory{
            if txtSubCategory.text! == ""{
                FTIndicator.showToastMessage(AddProductManfacturingViewControllerConstant.PleaseSelectSubCategory)
                return false
            }
            let data  = dropdowns.subCategory2!.filter( {
                $0.FKCHILDCATEGORYID!.range(of: childID, options: .caseInsensitive) != nil
            })
            let drop  = DropdownPopUp(title: AddProductManfacturingViewControllerConstant.SelectGrandCategory, type: .fkGrandChildCategoryId, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }
        
        
        else{
            print(textField.text!)
            return true
        }
       }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
       if textField == txtProductName {
           
           let maxLength = 50
           let currentString: NSString = txtProductName.text as! NSString
           let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

              return newString.length <= maxLength
      }else if textField == txtMaterialName {
          
          let maxLength = 50
          let currentString: NSString = txtMaterialName.text as! NSString
          let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

             return newString.length <= maxLength
     }else if textField == txtMaterialPrice{
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
         if range.location > 12 - 1 {
             return false
             //textField.text?.removeLast()
         }
         return true
     }
        else
        {return true}
    }
}
extension AddProductManfacturingViewController: QRScannerCodeDelegate {
    func qrCodeScanningDidCompleteWithResult(result: String) {
        print("result:\(result)")
        dismiss(animated: true)
        guard  let url:URL = URL(string:result) else{return}
       //  if result.contains("bbc.newforceltd.com") || result.contains("bbcuat.newforceltd.com") || result.contains("retail.maaserp.com") { //Staging

        if  result.contains("SKU") {
            self.barCodeId = url.lastPathComponent
            self.qrCodeText.text = CommonConstant.Barcodescannedsuccessfully
            self.tickImageView.isHidden = false
//            self.qrCodeImageView.image = UIImage(named: "settlementReport")
            print(url.lastPathComponent)
        }else{
            FTIndicator.showToastMessage(CommonConstant.InvalidQRCode)
           
           }
        }
    
    func qrCodeScanningFailedWithError(error: String) {
        print("error:\(error)")
    }
}

extension AddProductManfacturingViewController:SendSubSkill{
    func tableviewReload(selectedId: [String], selectedName: [String], selectedQuantity: [String], selectedPrice1: [String]) {
        self.selectedSubSkillId = selectedId
        self.selectedSubSkillName = selectedName
        self.selectedQuantity = selectedQuantity
        self.selectedPrice = selectedPrice1
        
      if self.product == nil{
          self.viewTaxList.isHidden = false
          self.tablebiewTaxList.reloadData()
          self.tableviewHeight.constant = CGFloat(selectedName.count) * 50
          
      }else{
          self.geProductDetailsByID(productId: self.product.productId ?? "")
      }
   
  }
    
      
    

}
//  MARK: - TABLEVIEW EXTENSION
extension AddProductManfacturingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.product == nil{
            return selectedSubSkillName.count
        }else{
            return self.productDetailData?.subSkillsList?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tablebiewTaxList.dequeueReusableCell(withIdentifier: "AddProductTaxListTableviewViewCell", for: indexPath) as! AddProductTaxListTableviewViewCell
        if self.product == nil{
            let text =  selectedSubSkillName[indexPath.row]
            let qty = "  " + AddProductManfacturingViewControllerConstant.Qty + selectedQuantity[indexPath.row]
            cell.labelTax.text = selectedSubSkillName[indexPath.row] + qty
            cell.buttonRemove.isHidden = true
            
        }else{
            cell.labelTax.text = self.productDetailData?.subSkillsList?[indexPath.row].name ?? ""
            cell.buttonRemove.isHidden = false
            cell.buttonRemove.tag = indexPath.row
            cell.buttonRemove.addTarget(self, action: #selector(removeTaxAction), for: .touchUpInside)
            
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func removeTaxAction(_ sender: UIButton){
      
    }

}

