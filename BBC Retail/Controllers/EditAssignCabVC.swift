//
//  EditAssignCabVC.swift
//  BBC Retail
//
//  Created by Himanshu on 22/11/22.
//

import UIKit
import DropDown
import FTIndicator
class EditAssignCabVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFieldSelectStatus: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldSelectDriver: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldSelectCab: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldStoreName: SkyFloatingLabelTextField!
    @IBOutlet var stackView : UIStackView!
    var trcData : TRCList?
    let dropDown = DropDown()
    var isFromEditCab = ""
    var selectedStatus = ""
    var updateProductList : (()-> Void)!
    var serviceID = ""
    var allocationType = ""
    var allocationID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSelectStatus.delegate = self
        textFieldSelectCab.delegate = self
        textFieldSelectDriver.delegate = self
        if isFromEditCab == "edit"{
            stackView.subviews[0].isHidden = false
            stackView.subviews[1].isHidden = true
            stackView.subviews[2].isHidden = true
            stackView.subviews[3].isHidden = false
            textFieldStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
            textFieldStoreName.isUserInteractionEnabled = false
            textFieldSelectStatus.text = trcData?.trcStatus
            if trcData?.trcStatus == "Active" {
                self.selectedStatus = "1"
            }else{
                self.selectedStatus = "0"
            }
        }else{
            stackView.subviews[0].isHidden = false
            stackView.subviews[1].isHidden = false
            stackView.subviews[2].isHidden = false
            stackView.subviews[3].isHidden = true
            textFieldStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
            textFieldStoreName.isUserInteractionEnabled = false
            serviceID = trcData?.productId ?? ""
            textFieldSelectCab.text = trcData?.mainCategoryName ?? ""
            allocationID = trcData?.trcAllocationId ?? ""
            textFieldSelectDriver.text = trcData?.allocationType ?? ""
        }
    }
    
    //MARK:- DropDown Function
    func dropDownAction(){
            dropDown.dataSource = ["Active", "Inactive"]
            dropDown.anchorView = textFieldSelectStatus //
            dropDown.bottomOffset = CGPoint(x: 0, y: textFieldSelectStatus.frame.size.height) //6
            dropDown.backgroundColor = .white
            dropDown.textColor = .black
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
                self!.textFieldSelectStatus.text =  "\(item)"
                if item == "Active" {
                    self!.selectedStatus = "1"
                }else{
                    self!.selectedStatus = "2"
                }
                print("selectedStatus",self!.selectedStatus)
                guard let _ = self else { return }
            }
       
      
    }
    func assignCabAPI(){
        showIndicator()
        WebServiceManager.sharedInstance.AssignCabLocationData(create_by: Singleton.sharedInstance.retailerData.ADMINID ?? "", store_id: Singleton.sharedInstance.retailerData.storeId ?? "", allocation_type: "Driver", service_id: serviceID, trcstore_Id: trcData?.trcstoreId ?? "", allocation_id: allocationID) { msg, status in
            self.hideIndicator()
            if status == "1"{
                self.updateProductList()
                FTIndicator.showToastMessage(msg)
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    func editCabAPI(){
        showIndicator()
        WebServiceManager.sharedInstance.updateCabLocationData(storeId: Singleton.sharedInstance.retailerData.storeId ?? "", number: "", trcstore_Id: trcData?.trcstoreId ?? "", floor: "", location: "", status: selectedStatus) { msg, status in
            self.hideIndicator()
            if status == "1"{
                self.updateProductList()
                FTIndicator.showToastMessage(msg)
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
  
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      if textField == textFieldSelectCab{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
            vc.fromSearchService = true
            
            vc.updateService = { (id,name) in
                self.serviceID = id
                self.textFieldSelectCab.text = name.capitalized
            }
            self.present(vc, animated: true, completion: nil)
        }else if textField == textFieldSelectDriver{
            self.view.endEditing(true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
//                    vc.fromSearchService = true
            vc.updateNurseDoc = { (type,id,name) in
                self.allocationType = name
                self.allocationID = id
                self.textFieldSelectDriver.text = name.capitalized
            }
            self.present(vc, animated: true, completion: nil)
        }else if textField == textFieldSelectStatus{
            dropDownAction()
        }
        return true
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSubmit(_ sender: UIButton) {
        if isFromEditCab == "edit"{
            editCabAPI()
        }else{
            assignCabAPI()
        }
    }
}
