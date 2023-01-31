//
//  AddProductController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 19/04/22.
//

import UIKit
import AVFoundation
import FTIndicator
import SwiftPopup

class AddProductTaxListTableviewViewCell:UITableViewCell{
    
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var labelTax: UILabel!
}


class AddProductController: UIViewController{
    
        //MARK: - IBOUTLET
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddProduct: UIButton!
    @IBOutlet weak var btnLeftMenu: UIButton!
    @IBOutlet weak var txtProductName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMainCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSubCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var txtQuantity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtOfferPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var txtStandardPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCostPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCurrency: SkyFloatingLabelTextField!
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
    
    @IBOutlet weak var txtUnitOfMeasurement: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPackage: SkyFloatingLabelTextField!
    
    @IBOutlet weak var viewPackage: UIView!
    
    
    @IBOutlet weak var pakageToggleButton: UISwitch!
    @IBOutlet weak var txtPackageQuantity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPackageOfferPrice: SkyFloatingLabelTextField!
    
    
    
    
    
//  MARK: - VARIABLES
    var placeholderLabel : UILabel!
    var dropdowns : Dropdowns!
    var mainID = String()
    var childID = String()
    var product : Productlist!
    var updateProductList : (()-> Void)!
    var barCodeId = String()
    var productDetailData: ProductDetail?
    var editProductId = [String]()
    var isComingFrom = ""
    var productImageFromEdit = ""
    var unitConversionID = String()
    var dropDownUnitMeasurementList : [UnitMeasurementList]?
    
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        if isComingFrom == "EditProduct"{
            btnLeftMenu.setImage(UIImage(named: "leftarrow"), for: .normal)
            lblTitle.text = AddProductControllerConstant.UpdateProduct
            guard let url = URL(string: productImageFromEdit) else{return}
            imgVWProduct.kf.setImage(with: url,placeholder: UIImage(named: "imagePlaceholder"))
        }else{
            btnLeftMenu.setImage(UIImage(named: "menu-icon"), for: .normal)
            lblTitle.text = AddProductControllerConstant.AddProduct
        }
        self.barCodeId = ""
        self.qrCodeText.text = CommonConstant.ScanBarcode
        self.qrCodeImageView.image = UIImage(named: "barcode")
        self.tickImageView.isHidden = true
        txtCurrency.text = UserDefaults.standard.string(forKey: "currency") ?? ""
        getMainCategories()
        getConversionListDropdwon()
        addTextVWPlaceholder()
        updateUI()
        getProductDetail()
        txtProductName.delegate = self
        print("Status:",Singleton.sharedInstance.retailerData?.taxStatus ?? "")
        print("Type:",Singleton.sharedInstance.retailerData?.taxType ?? "")
        self.taxDetails()
       
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
   
    //    MARK: - FUNCTION TABLEVIEWTAXLIST
    
    @IBAction func packageValueChanged(_ sender: Any) {
        self.checkPackegeUI()
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
            let vc = UIStoryboard().returnMain().instantiateViewController(withIdentifier: "ProductTaxViewController") as! ProductTaxViewController
            vc.delegate = self
            vc.show()
        }else{
            let vc = UIStoryboard().returnMain().instantiateViewController(withIdentifier: "ProductTaxViewController") as! ProductTaxViewController
            vc.come = "edit"
            vc.productId = self.product.ProductId ?? ""
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
        
        txtProductName.placeholder = AddProductControllerConstant.ProductName
        txtMainCategory.placeholder =  AddProductControllerConstant.MainCategory
        txtQuantity.placeholder = AddProductControllerConstant.Quantity
        txtOfferPrice.placeholder = AddProductControllerConstant.OfferPrice
        txtStandardPrice.placeholder =  AddProductControllerConstant.StandardPrice
        txtCostPrice.placeholder = AddProductControllerConstant.CostPrice
        txtCurrency.placeholder = AddProductControllerConstant.Currency
        
        txtPackage.placeholder = AddProductControllerConstant.Package
        txtUnitOfMeasurement.placeholder = AddProductControllerConstant.Unitofmeasurement
        txtPackageQuantity.placeholder = AddProductControllerConstant.packageQuantity
        txtPackageOfferPrice.placeholder = AddProductControllerConstant.PackageOfferPrice
        
        
        
        placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
        txtVWDescription.layer.cornerRadius = 2
        txtVWDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtVWDescription.layer.borderWidth = 1
        if Singleton.sharedInstance.retailerData.inventory  == "with inventory"{
            txtQuantity.isHidden = false
        }else{
            txtQuantity.isHidden = true
        }
      
        
        if Singleton.sharedInstance.retailerData.taxStatus ?? "" == "enable" && Singleton.sharedInstance.retailerData.inventory  == "with inventory"
        {
            if Singleton.sharedInstance.retailerData.taxType ?? "" == "exclusive"{
                self.viewAddTax.isHidden = false
                //self.viewProductTax.isHidden = false
            }else if Singleton.sharedInstance.retailerData.taxType ?? "" == "inclusive"{
                self.viewAddTax.isHidden = false
            //    self.viewProductTax.isHidden = false
            }else{
                self.viewAddTax.isHidden = true
                //self.viewProductTax.isHidden = true
            }
        }else{
            self.viewAddTax.isHidden = true
           // self.viewProductTax.isHidden = true
        }
    }
    func getProductDetail(){
        guard let product = self.product else {return}
        self.geProductDetailsByID(productId: product.ProductId ?? "")
    }
    func updateForumIfProductEdit(){
    
       btnLeftMenu.setImage(UIImage(named: "leftarrow"), for: .normal)
       lblTitle.text = AddProductControllerConstant.UpdateProduct
        buttonAddTax.setTitle(AddProductControllerConstant.EditTax, for: .normal)
       btnAddProduct.setTitle(AddProductControllerConstant.UpdateProduct, for: .normal)
      
        txtProductName.text = productDetailData?.productName ?? ""
       txtMainCategory.text = productDetailData?.mainCategoryName
        txtSubCategory.text = productDetailData?.childCategoryName
        txtQuantity.text =  productDetailData?.productQuantity
       txtQuantity.isEnabled = false
        
        txtOfferPrice.text = productDetailData?.productOfferPrice
        txtStandardPrice.text = product.ProductPrice ?? ""
       txtCostPrice.text = product.CostPrice ?? ""
        
        
        self.txtUnitOfMeasurement.text = self.productDetailData?.productUnit ?? ""
        self.unitConversionID = self.productDetailData?.unitId ?? ""
        
        self.txtPackageOfferPrice.text = self.productDetailData?.packagePrice ?? ""
        self.txtPackageQuantity.text = self.productDetailData?.packageQuantity ?? ""
        
        if productDetailData?.packageFlag == "1"{
            txtPackageQuantity.text = productDetailData?.packageQuantity ?? ""
            txtPackageOfferPrice.text = productDetailData?.packagePrice ?? ""
            self.pakageToggleButton.isOn = true
            
        }else{
            txtPackageQuantity.text = productDetailData?.packageQuantity ?? ""
            txtPackageOfferPrice.text = productDetailData?.packagePrice ?? ""
            self.pakageToggleButton.isOn = false
        }
        self.checkPackegeUI()
        
       self.barCodeHeightConstraint.constant = 0
       txtVWDescription.text = product.ProductSHORTDESCRIPTION
    
        mainID = productDetailData?.fkMainCategoryId ?? ""
       childID = productDetailData?.fkChildCategoryId ?? ""
        
        
        
       placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
       guard let url = URL(string: product.ProductImage ?? "") else{return}
       imgVWProduct.kf.setImage(with: url,placeholder: UIImage(named: "imagePlaceholder"))
       qrCodeImageView.alpha = 0
       qrCodeImageView.isHidden = true
      
        if Singleton.sharedInstance.retailerData.taxStatus ?? "" == "enable" && Singleton.sharedInstance.retailerData.inventory  == "with inventory"{
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
    func checkPackegeUI(){
        if self.pakageToggleButton.isOn{
            self.txtPackageQuantity.isHidden = false
            self.txtPackageOfferPrice.isHidden = false
        }else{
            self.txtPackageQuantity.isHidden = true
            self.txtPackageOfferPrice.isHidden = true
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
        WebServiceManager.sharedInstance.getProductDetailsById(product_id: productId) {taxlist,msg, status in
            if status == "1"{
                self.productDetailData = taxlist
                print(self.productDetailData!)
                for i in self.productDetailData?.taxList ?? []{
                    self.editProductId.append(i.TAX_ID ?? "")
                }
             
                if self.productDetailData?.taxList?.count ?? 0 == 0{
                    self.viewTaxList.isHidden = true
                }else{
                    
                    self.viewTaxList.isHidden = false
                    self.tableviewHeight.constant = CGFloat(self.productDetailData?.taxList?.count ?? 0) * 50
                }
                self.updateForumIfProductEdit()
                self.tablebiewTaxList.reloadData()
            }else{
                FTIndicator.showToastMessage(msg)
            }
          }
    }
    //MARK: - ADD PRODUCT API
    func addProductAPI(productImage: UIImage, costPrice: String, productPrice: String, offerPrice: String,  name: String, shortDescr: String, currencyType: String, productQuanty: String, mainID: String, childID: String, grandChildID: String,TAXTYPE:String,TAXID:String,UNIT:String,PACKAGE_FLAG:String,PACKAGE_PRICE:String,PACKAGE_QTY:String){
        showIndicator()
        var childID1 = childID
        if childID1 == "0"{
            childID1 = ""
        }
        WebServiceManager.sharedInstance.addProduct(productImage: productImage, costPrice: costPrice, productPrice: productPrice, offerPrice: offerPrice, name: name, shortDescr: shortDescr, currencyType: currencyType, productQuanty: productQuanty, mainID: mainID, childID: childID1, grandChildID: grandChildID,barcodeId: self.barCodeId,TAXTYPE: TAXTYPE, TAXID: TAXID ,UNIT:UNIT,PACKAGE_FLAG:PACKAGE_FLAG,PACKAGE_PRICE:PACKAGE_PRICE,PACKAGE_QTY:PACKAGE_QTY) { msg, status in
            self.hideIndicator()
            if status == "1"{
                self.txtProductName.text = ""
                self.txtMainCategory.text = ""
                self.txtSubCategory.text = ""
                self.txtQuantity.text = ""
                self.txtOfferPrice.text = ""
                self.txtStandardPrice.text = ""
                self.txtCostPrice.text = ""
//                self.txtCurrency.text = ""
                self.txtVWDescription.text = ""
                
                
                
                self.txtUnitOfMeasurement.text = ""
                self.txtPackageQuantity.text = ""
                self.txtPackageOfferPrice.text = ""
                
                
                self.childID = ""
                self.mainID = ""
                Singleton.sharedInstance.selectedTaxName.removeAll()
                Singleton.sharedInstance.selectedTaxId.removeAll()
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
    func editProductAPI(productImage: UIImage, costPrice: String, productPrice: String, offerPrice: String,  name: String, shortDescr: String, currencyType: String, productQuanty: String, mainID: String, childID: String, productID: String,TaxId:String,UNIT:String,PACKAGE_FLAG:String,PACKAGE_PRICE:String,PACKAGE_QTY:String){
        showIndicator()
        var childID1 = childID
        if childID1 == "0"{
            childID1 = ""
        }
        WebServiceManager.sharedInstance.editProduct(productImage: productImage, costPrice: costPrice, productPrice: productPrice, offerPrice: offerPrice, name: name, shortDescr: shortDescr, currencyType: currencyType, productQuanty: productQuanty, mainID: mainID, childID: childID1, productID: productID,TAXID: TaxId,UNIT:UNIT,PACKAGE_FLAG:PACKAGE_FLAG,PACKAGE_PRICE:PACKAGE_PRICE,PACKAGE_QTY:PACKAGE_QTY) { msg, status in
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
            //let mainCat = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtMainCategory.text!, fieldName: "main category")
            //let subCat = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtSubCategory.text!, fieldName: "sub category")
            var quantity:String = ""
            if Singleton.sharedInstance.retailerData.inventory  == "with inventory"{
                 quantity = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtQuantity.text!, fieldName: "quantity")
            }
            let offerPrice = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtOfferPrice.text!, fieldName: "offer price")
            let standardPrice = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtStandardPrice.text!, fieldName: "standard price")
            let costPrice = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCostPrice.text!, fieldName: "cost price")
            let currency = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtCurrency.text!, fieldName: "currency")
            
            let unitOfMeasurement = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtUnitOfMeasurement.text!, fieldName: "Unit of Measurement")
            
            var packageQuantity:String = ""
            var packageOfferPrice:String = ""
           
            if self.pakageToggleButton.isOn{
                packageQuantity = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtPackageQuantity.text!, fieldName: "Package Quantity")
                 packageOfferPrice = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtPackageOfferPrice.text!, fieldName: "Package Offer Price")
            }
            
            
            
            if Double(standardPrice) ?? 0 == 0{
                FTIndicator.showToastMessage(AddProductControllerConstant.StandardpricecantbeequalToZero )
            }
            if !txtOfferPrice.text!.isEmpty{
            if Double(txtOfferPrice.text ?? "0") ?? 0 > Double(standardPrice) ?? 0{
                FTIndicator.showToastMessage(AddProductControllerConstant.Offerpricecantbgeaterthanstandardprice )
                return
            }}
            if  Double(costPrice) ?? 0 == 0{
                FTIndicator.showToastMessage(AddProductControllerConstant.Costpricecantbeequaltozero )
                return
              }
          
            if  Double(costPrice) ?? 0 > Double(standardPrice) ?? 0{
                FTIndicator.showToastMessage(AddProductControllerConstant.Costpricecantbegreaterthanstandardprice )
                return
              }
            
            
            
            
          //  Costpricecantbegreaterthanstandardprice
            if Singleton.sharedInstance.retailerData.taxStatus ?? "" == "enable" && Singleton.sharedInstance.retailerData.inventory  == "with inventory"{
                if self.product == nil{
                    if Singleton.sharedInstance.selectedTaxId.count == 0{
                       // FTIndicator.showToastMessage(AddProductControllerConstant.Addyourproducttax )
                      //  return
                    }
                }else{
                    if self.editProductId.count == 0{
                       // FTIndicator.showToastMessage(AddProductControllerConstant.Addyourproducttax )
                       // return
                }
   
                }
            }else{
                
                
                //self.viewProductTax.isHidden = true
            }
           
            let description = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtVWDescription.text!, fieldName: "description")
            

            guard product != nil else {
                addProductAPI(productImage: self.imgVWProduct.image!, costPrice: costPrice, productPrice: standardPrice, offerPrice: offerPrice, name: productname, shortDescr: description, currencyType: currency, productQuanty: quantity, mainID: mainID, childID: childID, grandChildID: "",TAXTYPE: Singleton.sharedInstance.retailerData.taxType ?? "",TAXID: Singleton.sharedInstance.selectedTaxId.joined(separator: ","),UNIT: unitConversionID,PACKAGE_FLAG: self.pakageToggleButton.isOn ? "1" : "0",PACKAGE_PRICE: packageOfferPrice,PACKAGE_QTY: packageQuantity)
                return}
                    
            editProductAPI(productImage: self.imgVWProduct.image!, costPrice: costPrice, productPrice: standardPrice, offerPrice: txtOfferPrice.text!, name: productname, shortDescr: description, currencyType: currency, productQuanty: quantity, mainID: mainID, childID: childID, productID: product.ProductId ?? "", TaxId:self.editProductId.joined(separator: ","),UNIT: unitConversionID,PACKAGE_FLAG: self.pakageToggleButton.isOn ? "1" : "0",PACKAGE_PRICE: packageOfferPrice,PACKAGE_QTY: packageQuantity )
            } catch(let error){
              let message = (error as! ValidationError).message
                FTIndicator.showToastMessage(message)
              }
            }
       }
func imageCompare(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
    let data1: Data = image1.pngData()!
    let data2: Data = image2.pngData()!
    return data1 == (data2)
   }

    //MARK: - UITextFieldDelegate
extension AddProductController:UITextViewDelegate,UITextFieldDelegate,DropDownDelegate{
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .mainCategory:
            txtMainCategory.text = value?.name ?? ""
            mainID = value?.mainId ?? ""
        case .subCategory:
            txtSubCategory.text = value?.name ?? ""
            childID = value?.FKCHILDCATEGORYID ?? ""
        case .unitConversionList:
            txtUnitOfMeasurement.text = value?.uom ?? ""
            unitConversionID = value?.id ?? ""
            for object in self.dropDownUnitMeasurementList ?? []
            {
                let filterArr = multiSelectionArr.filter { ob in
                    ob.id == object.id ? true : false
                }
               if filterArr.count > 0{
                   object.isSelected = true
                }
                else{
                    object.isSelected = false
                }
            }
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
        else if textField == txtUnitOfMeasurement{
            
            let drop  = DropdownPopUp(title: AddProductControllerConstant.SelectUnitOfMeasurement, type: .unitConversionList, dropDownType: .defaultType, data: self.dropDownUnitMeasurementList ?? [], sender: self)
            drop.dropDownVC.delegate = self
            return false
        }
        
        else{
            print(textField.text!)
            return true
        }
       }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtQuantity || textField == txtPackageQuantity{
             let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
             let compSepByCharInSet = string.components(separatedBy: aSet)
             let numberFiltered = compSepByCharInSet.joined(separator: "")
             if range.location > 12 - 1 {
                 textField.text?.removeLast()
             }
             return string == numberFiltered
            
        }
       else if textField == txtCostPrice || textField == txtOfferPrice || textField == txtStandardPrice || textField == txtPackageOfferPrice{
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
           return true//string == numberFiltered
          // return true
//        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
//        let compSepByCharInSet = string.components(separatedBy: aSet)
//        let numberFiltered = compSepByCharInSet.joined(separator: "")
//        if range.location > 12 - 1 {
//            textField.text?.removeLast()
//        }
//        return string == numberFiltered
       }else if textField == txtProductName{
           
           let maxLength = 50
           let currentString: NSString = txtProductName.text as! NSString
           let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

              return newString.length <= maxLength
      }else{return true}
    }
}
extension AddProductController: QRScannerCodeDelegate {
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

extension AddProductController:SendTax{
    func tableviewReload(){
        if self.product == nil{
            self.viewTaxList.isHidden = false
            self.tablebiewTaxList.reloadData()
            self.tableviewHeight.constant = CGFloat(Singleton.sharedInstance.selectedTaxName.count) * 50
            
        }else{
            self.geProductDetailsByID(productId: self.product.ProductId ?? "")
        }
     
    }

}
//  MARK: - TABLEVIEW EXTENSION
extension AddProductController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.product == nil{
            return Singleton.sharedInstance.selectedTaxName.count
        }else{
            return self.productDetailData?.taxList?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tablebiewTaxList.dequeueReusableCell(withIdentifier: "AddProductTaxListTableviewViewCell", for: indexPath) as! AddProductTaxListTableviewViewCell
        if self.product == nil{
            cell.labelTax.text = Singleton.sharedInstance.selectedTaxName[indexPath.row]
            cell.buttonRemove.isHidden = true
            
        }else{
            cell.labelTax.text = "\(self.productDetailData?.taxList?[indexPath.row].NAME ?? "")@ \(self.productDetailData?.taxList?[indexPath.row].PERCENTAGE ?? "")%"
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
        WebServiceManager.sharedInstance.deleteProductTax(product_id: self.product.ProductId ?? "", tax_id: self.productDetailData?.taxList?[sender.tag].TAX_ID ?? ""){ msg, status in
            if status == "1"{
                self.geProductDetailsByID(productId: self.product.ProductId ?? "")
            }else{
                FTIndicator.showToastMessage(msg)
            }
            
        }
    }

}
