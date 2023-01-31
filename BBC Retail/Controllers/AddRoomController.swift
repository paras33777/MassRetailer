//
//  AddRoomController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 01/08/22.
//

    import UIKit
    import AVFoundation
    import FTIndicator
    import DropDown

    class AddRoomController: UIViewController {
            //MARK: - IBOUTLET
        @IBOutlet weak var lblTitle: UILabel!
        @IBOutlet weak var txtStoreName: SkyFloatingLabelTextField!
        @IBOutlet weak var txtLocation: SkyFloatingLabelTextField!
        @IBOutlet weak var txtFloor: SkyFloatingLabelTextField!
        @IBOutlet weak var txtRoomNumber: SkyFloatingLabelTextField!
        @IBOutlet weak var txtSelectService: SkyFloatingLabelTextField!
        @IBOutlet weak var txtSSelectDoctor: SkyFloatingLabelTextField!
        @IBOutlet weak var stackSelectService: UIStackView!
        @IBOutlet weak var viewActiveStatus: UIView!
        @IBOutlet weak var txtActiveStatus: SkyFloatingLabelTextField!
        
        @IBOutlet var doctorView : UIView!
        @IBOutlet var serviceView : UIView!
        @IBOutlet var btnActive : UIButton!
        
            //MARK: - VARIABLES
        let dropDown = DropDown()
        var dropdowns : Dropdowns!
        var trcData : TRCList?
        var updateProductList : (()-> Void)!
        var fromAssignAction:Bool?
        var selectedUser = (type:"",id:"")
        var serviceID : String?
        var selectedStatus = ""
        var isFromEditTable = ""
        var isFromEditRack = ""
        var catId = ""
        var subCatId = ""
        var isFromHospitalEdit = ""
        var isFromEditCab = ""
        //MARK: - IBACTIONS
        @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
           
        }
        @IBAction func btnSubmitAction(_ sender: UIButton) {
            if Singleton.sharedInstance.retailerData.category == "restaurant"{
                if isFromEditTable == "edit"{
                    if txtLocation.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter location")
                    }else if txtFloor.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter floor")
                    }else if txtRoomNumber.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter table number")
                    }else if txtActiveStatus.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please select active status")
                    }else{
                        editTable()
                    }
                }else if isFromEditTable == "assign"{
                    if txtLocation.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter location")
                    }else if txtFloor.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter floor")
                    }else if txtRoomNumber.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter table number")
                    }else{
                        assignTable()
                    }
                }else{
                    if txtLocation.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter location")
                    }else if txtFloor.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter floor")
                    }else if txtRoomNumber.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter table number")
                    }else if txtSelectService.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please select worker")
                    }else{
                        addTable()
                    }
                    
                    
                    
                }
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                if sender.currentTitle == "Edit Room"{
                    validations(isUpdate: true)
                }else{
                    validations(isUpdate: false)
                }
            }else{
                if isFromEditRack == "edit"{
                    print("Coming from edit ")
                    if txtLocation.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter location")
                    }else if txtFloor.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter floor")
                    }else if txtRoomNumber.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter number")
                    }else if txtActiveStatus.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please select status")
                    }else{
                        editTable()
                    }
                }else if isFromEditRack == "assign"{
                    print("Coming from assign ")
                    if txtLocation.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter location")
                    }else if txtFloor.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter floor")
                    }else if txtRoomNumber.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter number")
                    }else if txtSSelectDoctor.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please select category")
                    }else{
                        assignReck()
                    }
                }else{
                    if txtLocation.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter location")
                    }else if txtFloor.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter floor")
                    }else if txtRoomNumber.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please enter number")
                    }else if txtSSelectDoctor.text?.isBlank == true{
                        FTIndicator.showToastMessage("Please select category")
                    }else{
                        addReckAPI()
                    }
                }
            }
        }
        @IBAction func buttonActiveStatus(_ sender: UIButton) {
            if Singleton.sharedInstance.retailerData.category == "restaurant"{
                dropDownAction()
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
//                dropDownAction()
                let data = UserStatus.getStaticStatus()
                let drop  = DropdownPopUp(title: InventoryViewControllerConstant.SelectStatus, type: .userStatus, dropDownType: .defaultType, data: data, sender: self)
                drop.dropDownVC.delegate = self
            }else{
                if isFromEditRack == "edit"{
                    dropDownAction()
              
                }else{
                    if txtSSelectDoctor.text! == ""{
                        FTIndicator.showToastMessage("Please select main category first")
                    }else{
                        let data  = dropdowns.subCategory1 ?? [].filter( {
                            $0.FKMAINCATEGORYID!.range(of: catId, options: .caseInsensitive) != nil
                        })
                        let drop  = DropdownPopUp(title: "Select Sub Category", type: .subCategory, dropDownType: .apiGetSearch, data: data, sender: self)
                        drop.dropDownVC.delegate = self
                    }
                }
            }
        }
        //MARK: - VIEW LIFE CYCLE
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if Singleton.sharedInstance.retailerData.category ?? "" == "restaurant"{
                if isFromEditTable == "edit"{
                    doctorView.alpha = 0
                    doctorView.isHidden = true
                    viewActiveStatus.isHidden = false
                    viewActiveStatus.alpha = 1
                    serviceView.alpha = 0
                    serviceView.isHidden = true
                    
                    lblTitle.text = "Edit Table"
                    txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
                    txtLocation.text = trcData?.location
                    txtFloor.text = trcData?.floor
                    txtRoomNumber.text = trcData?.number
                    txtActiveStatus.text = trcData?.trcStatus
                    if trcData?.trcStatus == "Active" {
                        self.selectedStatus = "1"
                    }else{
                        self.selectedStatus = "0"
                    }
                    updateUI()
                }else if isFromEditTable == "assign"{
                    doctorView.alpha = 0
                    doctorView.isHidden = true
                    viewActiveStatus.isHidden = true
                    viewActiveStatus.alpha = 0
                    serviceView.alpha = 1
                    serviceView.isHidden = false
                    
                    lblTitle.text = "Assign Table"
                    txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
                    txtLocation.text = trcData?.location
                    txtFloor.text = trcData?.floor
                    txtRoomNumber.text = trcData?.number
                    txtSelectService.text = trcData?.workerName ?? ""
                    selectedUser.type = trcData?.allocationType ?? ""
                    selectedUser.id = trcData?.trcAllocationId ?? ""
                    updateUI()
                }else{
                    doctorView.alpha = 0
                    doctorView.isHidden = true
                    viewActiveStatus.isHidden = true
                    viewActiveStatus.alpha = 0
                    serviceView.alpha = 1
                    serviceView.isHidden = false
                    lblTitle.text = "Add Table"
                    updateUI()
                }
                
                
            
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                doctorView.alpha = 1
                doctorView.isHidden = false
                viewActiveStatus.isHidden = true
                viewActiveStatus.alpha = 0
                serviceView.alpha = 1
                serviceView.isHidden = false
              
                getMainCategories()
                updateUI()
                txtActiveStatus.text = trcData?.trcStatus
                if trcData?.trcStatus == "Active" {
                    self.selectedStatus = "1"
                }else{
                    self.selectedStatus = "0"
                }
                updateForumIfProductEdit(trcData: trcData)
            } else{
                if isFromEditRack == "edit"{
                    doctorView.alpha = 0
                    doctorView.isHidden = true
                    viewActiveStatus.isHidden = false
                    viewActiveStatus.alpha = 1
                    serviceView.alpha = 0
                    serviceView.isHidden = true
                    
                    lblTitle.text = "Edit Rack"
                    txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
                    txtLocation.text = trcData?.location
                    txtFloor.text = trcData?.floor
                    txtRoomNumber.text = trcData?.number
                    txtActiveStatus.text = trcData?.trcStatus
                    if trcData?.trcStatus == "Active" {
                        self.selectedStatus = "1"
                    }else{
                        self.selectedStatus = "0"
                    }
                    updateUI()
                }else if isFromEditRack == "assign"{
                    lblTitle.text = "Assign Rack"
                    updateUI()
                    txtLocation.text = trcData?.location
                    txtFloor.text = trcData?.floor
                    txtRoomNumber.text = trcData?.number
                    txtSelectService.text = trcData?.productName ?? ""
                    self.serviceID = trcData?.productId ?? ""
                    self.catId = trcData?.mainCategoryId ?? ""
                    self.txtSSelectDoctor.text = trcData?.mainCategoryName ?? ""
                    self.subCatId = trcData?.childCategoryId ?? ""
                    self.txtActiveStatus.text = trcData?.childCategoryName ?? ""
//                    selectedUser.type = trcData?.allocationType ?? ""
//                    selectedUser.id = trcData?.trcAllocationId ?? ""
                    txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
                    getMainCategories()
                    updateUI()
                }else{
                    lblTitle.text = "Add Rack"
                    txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
                    updateUI()
                    getMainCategories()
                }
              
            }
            
           
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
                 
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
           // imgVWProduct.addDashedBorder(.lightGray, withWidth: 4, cornerRadius: 5, dashPattern: [6,4])
        }
        func updateUI(){
            if Singleton.sharedInstance.retailerData.category == "restaurant"{
                
                txtStoreName.placeholder = "Store Name *"
                txtLocation.placeholder = "Location *"
                txtFloor.placeholder = "Floor *"
                txtRoomNumber.placeholder = "Table Number"
                txtSelectService.placeholder = "Select worker *"
//                txtSSelectDoctor.placeholder = "Select Doctor/Nurse *"
                txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                txtStoreName.placeholder = "Store Name *"
                txtLocation.placeholder = "Location *"
                txtFloor.placeholder = "Floor *"
                txtRoomNumber.placeholder = "Room Number *"
                txtSelectService.placeholder = "Select Service *"
                txtSSelectDoctor.placeholder = "Select Doctor/Nurse *"
                txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
            }else{
                if isFromEditRack == "edit"{
                    txtStoreName.placeholder = "Store Name *"
                    txtLocation.placeholder = "Location *"
                    txtFloor.placeholder = "Floor *"
                    txtRoomNumber.placeholder = " Rack Number *"
//                    txtSelectService.placeholder = InventoryViewControllerConstant.SelectProduct
//                    txtSSelectDoctor.placeholder = "Select Category *"
                    txtActiveStatus.placeholder = InventoryViewControllerConstant.SelectStatus
                }else if isFromEditRack == "assign"{
                    txtStoreName.placeholder = "Store Name *"
                    txtLocation.placeholder = "Location *"
                    txtFloor.placeholder = "Floor *"
                    txtRoomNumber.placeholder = " Rack Number *"
                    txtSelectService.placeholder = InventoryViewControllerConstant.SelectProduct
                    txtSSelectDoctor.placeholder = "Select Category *"
                    txtActiveStatus.placeholder = "Select Sub-Category"
                }else{
                    txtStoreName.placeholder = "Store Name *"
                    txtLocation.placeholder = "Location *"
                    txtFloor.placeholder = "Floor *"
                    txtRoomNumber.placeholder = " Rack Number *"
                    txtSelectService.placeholder = InventoryViewControllerConstant.SelectProduct
                    txtSSelectDoctor.placeholder = "Select Category *"
                    txtActiveStatus.placeholder = "Select Sub-Category"
                }
               
            }
         
        }
       func updateForumIfProductEdit(trcData:TRCList?){
           guard trcData != nil else {return}
           if isFromHospitalEdit == "edit"{
               lblTitle.text = "Edit Room"
               self.viewActiveStatus.alpha = 1
               self.viewActiveStatus.isHidden = false
               
           }else{
               lblTitle.text = "Assign Room"
           }
           
          
           txtLocation.text = trcData?.location
           txtFloor.text = trcData?.floor
           txtRoomNumber.text = trcData?.number
//           txtActiveStatus.text = trcData?.allocationStatus
//           if trcData?.allocationStatus == "Active" {
//           self.selectedStatus = trcData?.allocationStatus ?? ""
//           }else{
//               self.selectedStatus = "inactive"
//           }
           if fromAssignAction == nil{
           stackSelectService.subviews[1].isHidden = true
           stackSelectService.subviews[2].isHidden = true
           viewActiveStatus.isHidden = false
           }else{
               txtLocation.isEnabled = false
               txtFloor.isEnabled = false
               txtRoomNumber.isEnabled = false
               txtSelectService.text = trcData?.productName?.capitalized
               txtSSelectDoctor.text = trcData?.workerName?.capitalized
               viewActiveStatus.isHidden = true
           }
        }
        //MARK:- DropDown Function
        func dropDownAction(){
            if Singleton.sharedInstance.retailerData.category == "restaurant"{
                if isFromEditTable == "edit"{
                    dropDown.dataSource = ["active", "inactive"]
                    dropDown.anchorView = txtActiveStatus //
                    dropDown.bottomOffset = CGPoint(x: 0, y: txtActiveStatus.frame.size.height) //6
                    dropDown.backgroundColor = .white
                    dropDown.textColor = .black
                    dropDown.show() //7
                    dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                        self!.txtActiveStatus.text =  "\(item)"
                        if item == "active" {
                            self!.selectedStatus = "1"
                        }else{
                            self!.selectedStatus = "0"
                        }
                        print("selectedStatus")
                        guard let _ = self else { return }
                    }
                }
//            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
//                dropDown.dataSource = ["Active", "Inactive"]
//                dropDown.anchorView = txtActiveStatus //
//                dropDown.bottomOffset = CGPoint(x: 0, y: txtActiveStatus.frame.size.height) //6
//                dropDown.backgroundColor = .white
//                dropDown.textColor = .black
//                dropDown.show() //7
//                dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
//                    self!.txtActiveStatus.text =  "\(item)"
//                    if item == "Active" {
//                        self!.selectedStatus = "1"
//                    }else{
//                        self!.selectedStatus = "2"
//                    }
//                    print("selectedStatus")
//                    guard let _ = self else { return }
//                }
            }else{
                dropDown.dataSource = ["Active", "Inactive"]
                dropDown.anchorView = txtActiveStatus //
                dropDown.bottomOffset = CGPoint(x: 0, y: txtActiveStatus.frame.size.height) //6
                dropDown.backgroundColor = .white
                dropDown.textColor = .black
                dropDown.show() //7
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                    self!.txtActiveStatus.text =  "\(item)"
                    if item == "Active" {
                        self!.selectedStatus = "1"
                    }else{
                        self!.selectedStatus = "2"
                    }
                    print("selectedStatus")
                    guard let _ = self else { return }
                }
            }
          
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
        //MARK: - ADD PRODUCT API
        func addRoomTrcAPI(number: String, allocation_type: String,allocation_id: String, location: String, floor: String, productID: String){
            showIndicator()
            WebServiceManager.sharedInstance.addRoomTRC(number: number,allocation_type:allocation_type, allocation_ID: allocation_id,location: location, floor: floor, productID: productID){ msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.txtStoreName.text = ""
                    self.txtLocation.text = ""
                    self.txtFloor.text = ""
                    self.txtRoomNumber.text = ""
                    self.txtSelectService.text = ""
                    self.txtSSelectDoctor.text = ""
                    self.txtStoreName.text = ""
                    FTIndicator.showToastMessage("Room added successfully!")
                    }else{
                    FTIndicator.showToastMessage(msg)
                 }
                }
               }
        //MARK: ADD RECK
        func addReckAPI(){
            showIndicator()
            WebServiceManager.sharedInstance.AddReckAPI(store_id: Singleton.sharedInstance.retailerData.storeId ?? "", create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "", number: txtRoomNumber.text!, setting_type: Singleton.sharedInstance.retailerData.storeType ?? "", allocation_type: "Product", product_id:  self.serviceID ?? "", location: txtLocation.text!, vertical: "FMCG", title: "Rack", floor: txtFloor.text!, assignSubcategory: self.subCatId, assignCategory: self.catId) { msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.updateProductList()
                    FTIndicator.showToastMessage("Rack added successfully!")
                    self.navigationController?.popViewController(animated: true)
                }else{
                   FTIndicator.showToastMessage(msg)
                }
              }
        }
       //MARK: ASSIGN RECK
        func assignReck(){
            showIndicator()
            WebServiceManager.sharedInstance.AssignReckAPI(store_id: Singleton.sharedInstance.retailerData.storeId ?? "", trcstore_Id: trcData?.trcstoreId ?? "", product_id: self.serviceID ?? "", allocation_type: "Product", assignSubcategory: self.subCatId, assignCategory: self.catId, create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "") { msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.updateProductList()
                    FTIndicator.showToastMessage("Allocation updated successfully!")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    FTIndicator.showToastMessage(msg)
                }
            }
        }
        
        //MARK: - ADD TABLE API
        func addTable(){
            showIndicator()
            WebServiceManager.sharedInstance.AddTableAPI(store_id: Singleton.sharedInstance.retailerData.storeId ?? "", create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "", number: txtRoomNumber.text!, setting_type: Singleton.sharedInstance.retailerData.storeType ?? "", allocation_type: selectedUser.type, allocation_id: selectedUser.id, location: txtLocation.text!, vertical: "restaurant", title: "table", floor: txtFloor.text!) { msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.updateProductList()
                    FTIndicator.showToastMessage("Allocation updated successfully!")
                    self.navigationController?.popViewController(animated: true)
                }else{
                   FTIndicator.showToastMessage(msg)
                }
              }
        }
        //MARK: EDIT TABLE
        func editTable(){
            showIndicator()
            
            WebServiceManager.sharedInstance.EditTableAPI(storeId: trcData?.storeId ?? "", trcstore_Id: trcData?.trcstoreId ?? "", number: txtRoomNumber.text!, location: txtLocation.text!, status: selectedStatus, floor: txtFloor.text!) { msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.updateProductList()
                    FTIndicator.showToastMessage("Allocation updated successfully!")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    FTIndicator.showToastMessage(msg)
                }
            }
        }
        //MARK: ASSIGN TABLE
        func assignTable(){
            showIndicator()
            WebServiceManager.sharedInstance.AssignTableAPI(store_id: trcData?.storeId ?? "", trcstore_Id: trcData?.trcstoreId ?? "", allocation_id: selectedUser.id, allocation_type: selectedUser.type, create_by: Singleton.sharedInstance.retailerData.RetailerId ?? "") { msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.updateProductList()
                    FTIndicator.showToastMessage("Allocation updated successfully!")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    FTIndicator.showToastMessage(msg)
                }
            }
        }
        
        
        func editTrcDataAPI(number: String, trcstore_Id: String, location: String, floor: String, status: String){
            showIndicator()
            WebServiceManager.sharedInstance.editRoomTRC(number: number, trcstore_Id: trcstore_Id, location: location, floor: floor, status: status) { msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.updateProductList()
                    FTIndicator.showToastMessage("Allocation updated successfully!")
                    self.navigationController?.popViewController(animated: true)
                }else{
                   FTIndicator.showToastMessage(msg)
                }
              }
            }
        //MARK: - ASSIGN  Room API
        func assignTrcDataAPI(allocationType: String, trcstore_Id: String,allocation_ID:String){
            showIndicator()
            if serviceID == nil{
                serviceID = trcData?.productId
            }
            WebServiceManager.sharedInstance.assignRoomTRC(trcstore_Id: trcstore_Id, allocation_type: allocationType, allocation_ID: allocation_ID, productID: self.serviceID!) {msg, status in
                self.hideIndicator()
                if status == "1"{
                    self.updateProductList()
                    FTIndicator.showToastMessage("Allocation assigned successfully!")
                    self.navigationController?.popViewController(animated: true)
                }else{
                   FTIndicator.showToastMessage(msg)
                }
              }
            }
        //MARK: - VALIDATIONS
        func validations(isUpdate:Bool){
            do {
//                let storeName = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtStoreName.text!, fieldName: "store name")
                let location = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtLocation.text!, fieldName: "location")
                let floor = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtFloor.text!, fieldName: "floor")
                let room = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtRoomNumber.text!, fieldName: "room")
              //  let status = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: selectedStatus, fieldName: "status")
                guard trcData != nil else {
                    _ = try Validation.shared.validate(type: ValidationType.isSelectBlank, inputValue: txtSelectService.text!, fieldName: "service")
                    _ = try Validation.shared.validate(type: ValidationType.isSelectBlank, inputValue: txtSSelectDoctor.text!, fieldName: "doctor/nurse")
//                    guard selectedUser != nil else{
//                        FTIndicator.showToastMessage("Please select service.")
//                        return
//                      }
                    addRoomTrcAPI(number: room, allocation_type: selectedUser.type, allocation_id: selectedUser.id, location: location, floor: floor, productID:serviceID!)
                    return}
                if fromAssignAction == nil{
                    editTrcDataAPI(number: room, trcstore_Id: trcData?.trcstoreId ?? "", location: location, floor: floor, status: self.selectedStatus)
                }else{
                    if selectedUser.type == ""{
                        selectedUser.type = trcData?.allocationType ?? ""
                        selectedUser.id = trcData?.allocationId ?? ""
                    }
                    _ = try Validation.shared.validate(type: ValidationType.isSelectBlank, inputValue: txtSelectService.text!, fieldName: "service")
                    _ = try Validation.shared.validate(type: ValidationType.isSelectBlank, inputValue: txtSSelectDoctor.text!, fieldName: "doctor/nurse")
                    assignTrcDataAPI(allocationType: selectedUser.type, trcstore_Id: trcData?.trcstoreId ?? "",allocation_ID: selectedUser.id)
                }
                } catch(let error){
                  let message = (error as! ValidationError).message
                    FTIndicator.showToastMessage(message)
                  }
                }
              }
        //MARK: - UITextFieldDelegate
    extension AddRoomController:UITextFieldDelegate,DropDownDelegate{
        func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
            switch dataType {
            case .mainCategory:
                print(dataType)
                txtSSelectDoctor.text = value?.name ?? ""
                catId = value?.mainId ?? ""
            case .subCategory:
                print(dataType)
                txtActiveStatus.text = value?.name ?? ""
                subCatId = value?.FKCHILDCATEGORYID ?? ""
            case .userStatus:
                self.txtActiveStatus.text = value?.name ?? ""
                
               if self.txtActiveStatus.text == "Active" {
                    self.selectedStatus = "1"
                }else{
                    self.selectedStatus = "0"
                }
            default: break
            }
        }
      
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
            //Apply FORUM TEXTFIELDS ACTION
            if textField == txtSelectService{
                self.view.endEditing(true)
                if Singleton.sharedInstance.retailerData.category == "restaurant"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
//                    vc.fromSearchService = true
                    vc.updateNurseDoc = { (type,id,name) in
                        self.selectedUser.type = type
                        self.selectedUser.id = id
                        self.txtSelectService.text = name.capitalized
                    }
                    self.present(vc, animated: true, completion: nil)
                }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
                    vc.fromSearchService = true
                    
                    vc.updateService = { (id,name) in
                        self.serviceID = id
                        self.txtSelectService.text = name.capitalized
                    }
                    self.present(vc, animated: true, completion: nil)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
                    vc.updateReckProducts = { (product,productId,category,categoryId,Subcategory,SubcategoryId) in
                        print("Reck products ---> ",product,productId,category,categoryId,Subcategory,SubcategoryId)
                        self.txtSelectService.text = product.capitalized
                        self.serviceID = productId
                        self.txtSSelectDoctor.text = category
                        self.catId = categoryId
                        self.txtActiveStatus.text = Subcategory
                        self.subCatId = ""
                        self.txtSSelectDoctor.isUserInteractionEnabled = false
                        self.btnActive.isUserInteractionEnabled = false
                        self.txtActiveStatus.isUserInteractionEnabled = false
                        
                    }

                    self.present(vc, animated: true, completion: nil)
                }
                
                return false
            }else if textField == txtSSelectDoctor{
                self.view.endEditing(true)
                if Singleton.sharedInstance.retailerData.category == "hospital"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
                    vc.fromSearchService = false
                    vc.updateNurseDoc = { (type,id,name) in
                        self.selectedUser.type = type
                        self.selectedUser.id = id
                        self.txtSSelectDoctor.text = name.capitalized
                    }
                    self.present(vc, animated: true, completion: nil)
                }else{
                    let data = dropdowns.mainCategory ?? []
                    let drop  = DropdownPopUp(title: "Select Main Category", type: .mainCategory, dropDownType: .apiGetSearch, data: data, sender: self)
                    drop.dropDownVC.delegate = self
                }
               
                return false
            }else{
                print(textField.text!)
                return true
            }
           }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == txtRoomNumber {
                 let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                 let compSepByCharInSet = string.components(separatedBy: aSet)
                 let numberFiltered = compSepByCharInSet.joined(separator: "")
                 if range.location > 12 - 1 {
                     textField.text?.removeLast()
                 }
                 return string == numberFiltered
                
            }else{return true}
        }
    }


