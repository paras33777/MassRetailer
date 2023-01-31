//
//  InventoryViewController.swift
//  BBC Retail
//
//  Created by Newforce MAC on 28/11/22.
//

import UIKit
import FTIndicator
import IBAnimatable

class InventoryViewController: UIViewController{
    
    
    //    MARK: - OUTLETS
    @IBOutlet weak var viewAddProductToStore: UIView!
    @IBOutlet weak var textFieldStstus: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldStoreTo: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldStoreProduct: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldQuantity: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldStandardPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldCostPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldOfferPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var textFieldMovemenytType: SkyFloatingLabelTextField!
   
    @IBOutlet weak var txtunitOfMeasurement: SkyFloatingLabelTextField!
    
    @IBOutlet weak var addStoreProduct: AnimatableButton!
    
    @IBOutlet weak var viewStoreTo: UIView!
    @IBOutlet weak var viewStoreProduct: UIView!
    @IBOutlet weak var viewQuantity: UIView!
    @IBOutlet weak var viewStandardPrice: UIView!
    @IBOutlet weak var viewCostPrice: UIView!
    @IBOutlet weak var viewOfferPrice: UIView!
    @IBOutlet weak var viewMovemenytType: UIView!
    
    @IBOutlet weak var viewUnitMeasurement: UIView!
    
    //    MARK: - VARIABLES
    var dropdowns :[StatusList]?
    var movementList :[StatusList]?
    var allAdminList :[AllAdminList]?
    var productList :[Productlist]?
    var placeholderLabel : UILabel!
    var statusId = ""
    var offerPrice = ""
    var StandardPrice = ""
    var costPrice = ""
    var courseId = ""

    var mainCat = ""
    var subCat = ""
    var productName = ""
    var receiveStoreId = ""
    var receiveProductId = ""
  
    var productDetail : ProductDetail?

    var unitConversionID = String()
    var unitIndex = String()
    
    var uoc_quantity = String()
    var dropDownUnitMeasurementList : [UnitMeasurementList]?
    
    //    MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Singleton.sharedInstance.qty)
        //self.unitConversionID = self.productDetail?.unitId ?? ""
        //self.txtunitOfMeasurement.text = self.productDetail?.productUnit ?? ""
        
        self.getConversionListDropdwon()
       
    }
 
    override func viewWillAppear(_ animated: Bool) {
      
        self.textFieldStstus.delegate = self
        self.textViewComment.delegate = self
        self.textFieldMovemenytType.delegate = self
        self.textFieldCostPrice.text = self.costPrice
        self.textFieldStandardPrice.text = self.StandardPrice
        self.textFieldOfferPrice.text = self.offerPrice
        self.textFieldStoreTo.delegate = self
        self.textFieldStoreProduct.delegate = self
        self.textFieldCostPrice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.textFieldCostPrice.isUserInteractionEnabled = true
        self.CallingAllApi()
        self.viewStoreTo.isHidden = true
        self.viewStoreProduct.isHidden = true
        self.viewMovemenytType.isHidden = true
        self.viewCostPrice.isHidden = true
        self.viewOfferPrice.isHidden = true
        self.viewStandardPrice.isHidden = true
        self.viewQuantity.isHidden = false
        self.viewUnitMeasurement.isHidden = true
        
    }
    
    
    //MARK: - GET Unit Conversion
    func getConversionListDropdwon(){
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId!,
            "role":Singleton.sharedInstance.retailerData.access!,
            "unit_class":self.productDetail?.unit_class ?? "",
            "unit_index":self.productDetail?.unit_priority ?? "",
            "unit_id":self.productDetail?.unitId ?? "",
            "status":statusId,
        ] as [String : Any]
        showSpinner(onView: self.view)
        WebServiceManager.sharedInstance.getConversionListDropdwonAPI(parameters:params) { dropdowns, msg, status in
            self.removeSpinner()
            if status == "1"{
            self.dropDownUnitMeasurementList = dropdowns
            }else{
            FTIndicator.showToastMessage(msg)
            }
          }
       }
//    MARK: - CALLING ALL API FOR MAIN QUEUE
    func CallingAllApi(){
    let dispatchGroup = DispatchGroup()
   // MARK: - GET INVENTORY STATUS
        dispatchGroup.enter()
        WebServiceManager.sharedInstance.getInventtoryStatusList{ dropdowns, msg, status in
            if status == "1"{
                self.dropdowns = dropdowns
                dispatchGroup.leave()
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
        
        dispatchGroup.enter()
        // MARK: - GET ALL ADMIN STORE LIST
        WebServiceManager.sharedInstance.getAllAdminStoreList{ dropdowns,msg,status in
            if status == "1"{
                self.allAdminList = dropdowns
                dispatchGroup.leave()
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }

        dispatchGroup.enter()
        // MARK: - GET MOVEMENT TYPE STATUS LIST
        WebServiceManager.sharedInstance.getMovementStatusList{ dropdowns, msg, status in
            if status == "1"{
                self.movementList = dropdowns
                dispatchGroup.leave()
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
        dispatchGroup.notify(queue: .main) {
             print("All API CALLED")
           }
        
    }

//    MARK: - API CALLING FOR GOOD RECEPT
    func goodReceptApi(){
        WebServiceManager.sharedInstance.insertRetailerProductlogsNewApi(course_id: self.courseId, prodcut_quantity: self.textFieldQuantity.text ?? "", standard_price: self.textFieldStandardPrice.text ?? "", sender_store_id: Singleton.sharedInstance.retailerData.storeId ?? "", status_comment: self.textViewComment.text ?? "", status: self.statusId, offer_price: self.textFieldOfferPrice.text ?? "", cost_price: self.textFieldCostPrice.text ?? "",create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "",conversion_id:self.unitConversionID,unit_id : self.productDetail?.unitId ?? "",product_unit : self.productDetail?.productUnit ?? ""){msg, status in
            SKActivityIndicator.show()
            if status == "1"{
                Singleton.sharedInstance.qty = "\((Int(Singleton.sharedInstance.qty) ?? 0) + (Int(self.textFieldQuantity.text ?? "") ?? 0))"
                print(Singleton.sharedInstance.qty)
                SKActivityIndicator.dismiss()
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
//    MARK: - API CALLING FOR GOOD ISSUE
    func goodIssuedApi(){
        WebServiceManager.sharedInstance.goodIssuelogsNewApi(course_id: self.courseId, prodcut_quantity: self.textFieldQuantity.text ?? "", standard_price: self.StandardPrice, sender_store_id: Singleton.sharedInstance.retailerData.storeId ?? "", status_comment: self.textViewComment.text ?? "", status: self.statusId, offer_price: self.offerPrice, cost_price: self.costPrice,create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "",movement_type: self.textFieldMovemenytType.text ?? "",conversion_id:self.unitConversionID,unit_id : self.productDetail?.unitId ?? "",product_unit : self.productDetail?.productUnit ?? ""){msg, status in
            SKActivityIndicator.show()
            if status == "1"{
                Singleton.sharedInstance.qty = "\((Int(Singleton.sharedInstance.qty) ?? 0) - (Int(self.textFieldQuantity.text ?? "") ?? 0))"
                print(Singleton.sharedInstance.qty)
                SKActivityIndicator.dismiss()
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }

//    MARK: - API CALLING FOR PHYSICAL INVENTORY
    func physicalInventoryApi(){
       let nameArray = Singleton.sharedInstance.retailerData.StoreName?.components(separatedBy: " ")
        let currency = nameArray?.last ?? ""
        WebServiceManager.sharedInstance.physicalInventorylogsNewApi(course_id: self.courseId, admin_id: Singleton.sharedInstance.retailerData.ADMINID ?? "", admin_type: Singleton.sharedInstance.retailerData.ADMINTYPE ?? "", prodcut_quantity: self.textFieldQuantity.text ?? "", currency: currency, page: "1", type: "Product", standard_price: self.StandardPrice, sender_store_id: Singleton.sharedInstance.retailerData.storeId ?? "", status_comment: self.textViewComment.text ?? "", status: self.statusId, offer_price: self.offerPrice, cost_price: self.costPrice, create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "",conversion_id:self.unitConversionID,unit_id : self.productDetail?.unitId ?? "",product_unit : self.productDetail?.productUnit ?? ""){msg, status in
            SKActivityIndicator.show()
            if status == "1"{
                Singleton.sharedInstance.qty = "\((Int(Singleton.sharedInstance.qty) ?? 0) + (Int(self.textFieldQuantity.text ?? "") ?? 0))"
                print(Singleton.sharedInstance.qty)
                SKActivityIndicator.dismiss()
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
//    MARK: - API CALLING FOR EDIT PRICE
    func editPriceApi(){
        WebServiceManager.sharedInstance.editPricelogsNewApi(course_id: self.courseId, prodcut_quantity: self.textFieldQuantity.text ?? "", standard_price: self.textFieldStandardPrice.text ?? "", sender_store_id: Singleton.sharedInstance.retailerData.storeId ?? "", status_comment: self.textViewComment.text ?? "", status: self.statusId, offer_price: self.textFieldOfferPrice.text ?? "", cost_price: self.textFieldCostPrice.text ?? "", create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "",conversion_id:self.unitConversionID,unit_id : self.productDetail?.unitId ?? "",product_unit : self.productDetail?.productUnit ?? ""){msg,status in
            SKActivityIndicator.show()
            if status == "1"{
                SKActivityIndicator.dismiss()
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }

//    MARK: - API CALLING FOR STOCK TRANSPORT
    func StockTransportApi(){
        WebServiceManager.sharedInstance.addStockTransportlogsNewAp(course_id: self.courseId, standard_price: self.textFieldStandardPrice.text ?? "", status_comment: self.textViewComment.text ?? "", new_product_add: "1", offer_price: self.textFieldOfferPrice.text ?? "", receiver_store_id: self.receiveStoreId , create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "", prodcut_quantity: self.textFieldQuantity.text ?? "", sender_store_id: Singleton.sharedInstance.retailerData.storeId ?? "", price: self.textFieldStandardPrice.text ?? "", receiver_product_id: self.receiveProductId, cost_price: self.textFieldCostPrice.text ?? "", status: self.statusId){msg, status in
            SKActivityIndicator.show()
            if status == "1"{
                Singleton.sharedInstance.qty = "\((Int(Singleton.sharedInstance.qty) ?? 0) - (Int(self.textFieldQuantity.text ?? "") ?? 0))"
                print(Singleton.sharedInstance.qty)
                SKActivityIndicator.dismiss()
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
//    MARK: - BUTTON ACTION
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonAddStoreProduct(_ sender: UIButton) {
        if self.productList?.count ?? 0 == 0{
            self.textFieldStoreProduct.text = self.productName
            self.viewAddProductToStore.isHidden = true
        }else{
      
        }
  
  
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let qty = Int(self.textFieldQuantity.text ?? "0") ?? 0
        
        let productQty = Int(self.productDetail?.productQuantity ?? "0")
        
        let costPriceDouble = Double(self.textFieldCostPrice.text ?? "0.0")
        let standardPriceDouble = Double(self.textFieldStandardPrice.text ?? "0.0")
        let offerPriceDouble = Double(self.textFieldOfferPrice.text ?? "0.0")
        
        let unit_priority = Int(self.productDetail?.unit_priority ?? "0")
         let unitIndext = Int(unitIndex)
        
        let uoc_quantity = Int(uoc_quantity) ?? 0
        var newQty = uoc_quantity * qty
        
        
        if self.statusId == "Good Receipt"{
            if self.textFieldStstus.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.SelectStatus)
            }else if self.txtunitOfMeasurement.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(AddProductControllerConstant.SelectUnitOfMeasurement)
            }
            else if self.textFieldQuantity.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterQuantity)
            }else if qty ?? 0 < 1{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.Availablequantityislessthan1)
            }
           
            else if self.textFieldStandardPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterStandardPrice)
            }else if self.textFieldCostPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage((InventoryViewControllerConstant.EnterCostPrice))
            }else if costPriceDouble > standardPriceDouble{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.CostPriceShouldbelessthanStandardPrice)
            }else if self.textFieldOfferPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterOfferPrice)
            }
            else if standardPriceDouble <  offerPriceDouble{
                    FTIndicator.showToastMessage(InventoryViewControllerConstant.OfferPriceshouldbelessthanStandardPrice)
            }else if self.textViewComment.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterComment)
            }else{
                self.goodReceptApi()
            }
            
        }else if statusId == "Good Issued"{
            if self.textFieldStstus.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.SelectStatus)
            }else if self.txtunitOfMeasurement.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(AddProductControllerConstant.SelectUnitOfMeasurement)
            }
            else if self.textFieldQuantity.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterQuantity)
            }
            else if  qty  < 1{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.Availablequantityislessthan1)
            }else if unit_priority == unitIndext && qty > productQty {
                FTIndicator.showToastMessage(InventoryViewControllerConstant.GoodIssuedquantitycantbemorethan)
            }
            else if unit_priority > unitIndext && newQty > productQty {
                FTIndicator.showToastMessage(InventoryViewControllerConstant.GoodIssuedquantitycantbemorethan)
            }
            else if qty > productQty {
                FTIndicator.showToastMessage(InventoryViewControllerConstant.GoodIssuedquantitycantbemorethan)
            }
            else if self.textFieldMovemenytType.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.SelectMovementType)
            }else if self.textViewComment.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterComment)
                
            }else{
                self.goodIssuedApi()
            }
            
        }else if statusId == "Stock Transport"{
            if self.textFieldStstus.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.SelectStatus)
            }else if self.textFieldStoreTo.text?.replacingOccurrences(of: " ", with: "") == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.SelectStore)
            }else if self.textFieldStoreProduct.text?.replacingOccurrences(of: " ", with: "") == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.SelectProduct)
            }else if self.textFieldQuantity.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterQuantity)
            }else if qty == 0{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.AvailableQuantityis0)
            }else if qty < 1{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.Availablequantityislessthan1)
            }else if unit_priority == unitIndext && qty > productQty {
                FTIndicator.showToastMessage(InventoryViewControllerConstant.StockTransportquantitycantbemorethan)
            }
            else if unit_priority > unitIndext && newQty > productQty {
                FTIndicator.showToastMessage(InventoryViewControllerConstant.StockTransportquantitycantbemorethan)
            }
            else if qty > productQty {
                FTIndicator.showToastMessage(InventoryViewControllerConstant.StockTransportquantitycantbemorethan)
            }
           else if self.textFieldStandardPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterStandardPrice)
            }else if self.textFieldCostPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterCostPrice)
            }else if self.textFieldOfferPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterOfferPrice)
            }else if costPrice > StandardPrice{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.CostPriceShouldbelessthanStandardPrice)
            }else if StandardPrice <  costPrice{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.OfferPriceshouldbelessthanStandardPrice)
            }else if self.textViewComment.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterComment)
            }else{
                self.StockTransportApi()
            }
        }else if statusId == "Physical Inventory"{
            if self.textFieldStstus.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.SelectStatus)
            }else if self.txtunitOfMeasurement.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(AddProductControllerConstant.SelectUnitOfMeasurement)
            }
            else if self.textFieldQuantity.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterQuantity)
            }else if qty == 0{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.AvailableQuantityis0)
            }else if qty ?? 0 <= 0{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.Availablequantityislessthan1)
            }else if unit_priority == unitIndext && qty > productQty {
                FTIndicator.showToastMessage(InventoryViewControllerConstant.PhysicalInventoryquantitycantbemorethan)
            }
            else if unit_priority > unitIndext && newQty > productQty {
                FTIndicator.showToastMessage(InventoryViewControllerConstant.PhysicalInventoryquantitycantbemorethan)
            }
            else if  qty > productQty{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.PhysicalInventoryquantitycantbemorethan)
            }
            else if self.textViewComment.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterComment)
            }else{
                self.physicalInventoryApi()
            }
        }else{
            if self.textFieldStandardPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterStandardPrice)
            }else if self.txtunitOfMeasurement.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(AddProductControllerConstant.SelectUnitOfMeasurement)
            }
            else if self.textFieldOfferPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterOfferPrice)
            }else if self.textFieldStandardPrice.text?.replacingOccurrences(of: " ", with: "") ?? "" <=  self.textFieldOfferPrice.text ?? ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.OfferPriceshouldbelessthanStandardPrice)
            }else if self.textViewComment.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""{
                FTIndicator.showToastMessage(InventoryViewControllerConstant.EnterComment)
            }else{
                self.editPriceApi()
            }
        }
    }
}

//MARK: - UITEXTFIELD DELEGATES, TEXTVIEW DELEGATES AND DROPDOWN DELEGATES
extension InventoryViewController:UITextViewDelegate,UITextFieldDelegate,DropDownDelegate{
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .statuslist:
            textFieldStstus.text = value?.name ?? ""
            statusId = value?.value ?? ""
            self.updateFields()
            getConversionListDropdwon()
        case .movementList:
            textFieldMovemenytType.text = value?.name ?? ""
            print(value?.value ?? "")
        case .unitConversionList:
            txtunitOfMeasurement.text = value?.uom ?? ""
            unitConversionID = value?.id ?? ""
            unitIndex = value?.unit_index ?? ""
            
            uoc_quantity = value?.uocQuantity ?? ""
            
            unitIndex = value?.unit_index ?? ""
            for object in self.dropDownUnitMeasurementList ?? []
            {
               /* let filterArr = multiSelectionArr.filter { ob in
                    ob.id == object.id ? true : false
                }*/
                if object.id == value?.id ?? ""{
                   object.isSelected = true
                }
                else{
                    object.isSelected = false
                }
            }
        default: break
        }
    }
    
    func updateFields(){
        if statusId == "Good Receipt"{
            self.viewStoreTo.isHidden = true
            self.viewStoreProduct.isHidden = true
            self.viewMovemenytType.isHidden = true
            self.viewCostPrice.isHidden = false
            self.viewOfferPrice.isHidden = false
            self.viewStandardPrice.isHidden = false
            self.viewQuantity.isHidden = false
            self.viewAddProductToStore.isHidden = true
            self.textFieldCostPrice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.textFieldCostPrice.isUserInteractionEnabled = true
            
            self.textFieldStoreTo.text = nil
            self.textFieldStoreProduct.text = nil
            self.textFieldMovemenytType.text = nil
            self.textFieldQuantity.text = nil
            self.textViewComment.text = nil
            
            self.viewUnitMeasurement.isHidden = false
  
        }else if statusId == "Good Issued" {
            self.viewStoreTo.isHidden = true
            self.viewStoreProduct.isHidden = true
            self.viewCostPrice.isHidden = true
            self.viewOfferPrice.isHidden = true
            self.viewStandardPrice.isHidden = true
            self.viewQuantity.isHidden = false
            self.viewMovemenytType.isHidden = false
            self.viewAddProductToStore.isHidden = true
            self.textFieldCostPrice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.textFieldCostPrice.isUserInteractionEnabled = true
            
            self.textFieldStoreTo.text = nil
            self.textFieldStoreProduct.text = nil
            self.textFieldMovemenytType.text = nil
            self.textFieldQuantity.text = nil
            self.textViewComment.text = nil
            self.viewUnitMeasurement.isHidden = false
            
        }else if statusId == "Stock Transport"{
            self.viewStoreTo.isHidden = false
            self.viewStoreProduct.isHidden = false
            self.viewCostPrice.isHidden = false
            self.viewOfferPrice.isHidden = false
            self.viewStandardPrice.isHidden = false
            self.viewMovemenytType.isHidden = true
            self.viewQuantity.isHidden = false
            self.viewAddProductToStore.isHidden = true
            self.textFieldCostPrice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.textFieldCostPrice.isUserInteractionEnabled = true
            
            self.textFieldStoreTo.text = nil
            self.textFieldStoreProduct.text = nil
            self.textFieldMovemenytType.text = nil
            self.textFieldQuantity.text = nil
            self.textViewComment.text = nil
            
            self.viewUnitMeasurement.isHidden = true
            
        }else if statusId == "Physical Inventory"{
            self.viewQuantity.isHidden = false
            self.viewStoreProduct.isHidden = true
            self.viewStoreTo.isHidden = true
            self.viewCostPrice.isHidden = true
            self.viewOfferPrice.isHidden = true
            self.viewStandardPrice.isHidden = true
            self.viewMovemenytType.isHidden = true
            self.viewAddProductToStore.isHidden = true
            self.textFieldCostPrice.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.textFieldCostPrice.isUserInteractionEnabled = true
            
            self.textFieldStoreTo.text = nil
            self.textFieldStoreProduct.text = nil
            self.textFieldMovemenytType.text = nil
            self.textFieldQuantity.text = nil
            self.textViewComment.text = nil
            
            self.viewUnitMeasurement.isHidden = false
        }else{
            self.viewStoreTo.isHidden = true
            self.viewStoreProduct.isHidden = true
            self.viewCostPrice.isHidden = false
            self.viewOfferPrice.isHidden = false
            self.viewStandardPrice.isHidden = false
            self.viewMovemenytType.isHidden = true
            self.viewQuantity.isHidden = true
            self.viewAddProductToStore.isHidden = true
            self.textFieldCostPrice.backgroundColor = #colorLiteral(red: 0.8437084556, green: 0.8836417794, blue: 0.9001467228, alpha: 1)
            self.textFieldCostPrice.isUserInteractionEnabled = false
            
            self.textFieldStoreTo.text = nil
            self.textFieldStoreProduct.text = nil
            self.textFieldMovemenytType.text = nil
            self.textFieldQuantity.text = nil
            self.textViewComment.text = nil
            self.viewUnitMeasurement.isHidden = false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        //Apply FORUM TEXTFIELDS ACTION
        if textField == self.textFieldStstus{
            self.view.endEditing(true)
            if let data = self.dropdowns{
                let drop  = DropdownPopUp(title: InventoryViewControllerConstant.SelectStatus, type: .statuslist, dropDownType: .defaultType, data: data, sender: self)
                drop.dropDownVC.delegate = self
            }else{
                self.CallingAllApi()
            }
            return false
        }else if textField == self.textFieldMovemenytType{
            self.view.endEditing(true)
            let data = self.movementList!
            let drop  = DropdownPopUp(title: InventoryViewControllerConstant.SelectStatus, type: .movementList, dropDownType: .defaultType, data: data, sender: self)
            drop.dropDownVC.delegate = self
            return false
        }else if textField == self.textFieldStoreTo{
            self.view.endEditing(true)
            self.viewAddProductToStore.isHidden = true
            let vc = UIStoryboard().returnProductUI().instantiateViewController(withIdentifier: "InventoryStoreViewController") as! InventoryStoreViewController
            vc.delegate = self
            vc.allAdminList = self.allAdminList
            self.present(vc, animated: true)
            return false
        }else if textField == self.textFieldStoreProduct{
            self.view.endEditing(true)
            if self.productList?.count ?? 0 == 0{
                self.textFieldStoreProduct.isUserInteractionEnabled = false
            }else{
                self.textFieldStoreProduct.isUserInteractionEnabled = true
                let vc = UIStoryboard().returnProductUI().instantiateViewController(withIdentifier: "InventoryStoreViewController") as! InventoryStoreViewController
                vc.delegate = self
                vc.come = "storeProduct"
                vc.productList = self.productList
                self.present(vc, animated: true)
            }
            return false
        } else if textField == txtunitOfMeasurement{
            
            print(self.dropDownUnitMeasurementList?[0].unit_index ?? 0)
            let drop  = DropdownPopUp(title: AddProductControllerConstant.SelectUnitOfMeasurement, type: .unitConversionList, dropDownType: .defaultType, data: self.dropDownUnitMeasurementList ?? [], sender: self)
            drop.dropDownVC.delegate = self
            return false
        }
        else{
            print(textField.text!)
            return true
        }
      
    }
}

extension InventoryViewController: StoreName {
    func storeProduct(name: String, productQty: String) {
        self.textFieldStoreProduct.text = "\(name) (\(productQty))"
    }
    
    func getstoreName(name: String, id: String) {
        self.receiveStoreId = id
        self.textFieldStoreTo.text = name
        self.viewAddProductToStore.isHidden = false
        self.textFieldStoreProduct.text = ""
        // MARK: - GET ALL STORE PRODUCT LIST
        WebServiceManager.sharedInstance.getStoreProductList(sub_cat: self.subCat, main_cat: self.mainCat, product_name: self.productName, Store_id: self.receiveStoreId){ dropdowns,msg,status in
            if status == "1"{
                self.productList = dropdowns
                self.receiveProductId = self.courseId
                if self.productList?.count ?? 0 == 0{
                    self.addStoreProduct.setTitle(" Add Product to the store ", for: .normal)
                    self.addStoreProduct.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                    self.addStoreProduct.layer.borderWidth = 1
                    self.addStoreProduct.layer.cornerRadius = 10
                    self.addStoreProduct.setTitleColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), for: .normal)
                    self.addStoreProduct.isUserInteractionEnabled = true
                    self.textFieldStoreProduct.isUserInteractionEnabled = false
                }else{
                    self.addStoreProduct.setTitle(" Product listing of \(name) Store ", for: .normal)
                    self.addStoreProduct.layer.borderColor = #colorLiteral(red: 0.1707492173, green: 0.5966171622, blue: 0.1686168611, alpha: 1)
                    self.addStoreProduct.layer.borderWidth = 1
                    self.addStoreProduct.layer.cornerRadius = 10
                    self.addStoreProduct.setTitleColor( #colorLiteral(red: 0.1707492173, green: 0.5966171622, blue: 0.1686168611, alpha: 1), for: .normal)
                    self.addStoreProduct.isUserInteractionEnabled = false
                    self.textFieldStoreProduct.isUserInteractionEnabled = true
                }
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }

}
