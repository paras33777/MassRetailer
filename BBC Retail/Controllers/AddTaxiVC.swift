//
//  AddTaxiVC.swift
//  BBC Retail
//
//  Created by Himanshu on 18/11/22.
//

import UIKit
import GooglePlaces
import FTIndicator

class AddTaxiVC: UIViewController,UITextFieldDelegate {

   
    @IBOutlet weak var txtSelectDriver: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSelectService: SkyFloatingLabelTextField!
   
    @IBOutlet weak var txtStoreName: SkyFloatingLabelTextField!
    @IBOutlet var lblTitle : UILabel!
    var fromLat = ""
    var fromLong = ""
    var toLat = ""
    var toLong = ""
    var allocationType = ""
    var allocationID = ""
    var serviceID = ""
    var isFromToField : Bool = false
    var updateCabList : (()-> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        txtSelectService.delegate = self
        txtSelectDriver.delegate = self
        txtStoreName.text = Singleton.sharedInstance.retailerData.StoreName ?? ""
        txtStoreName.isUserInteractionEnabled = false
    }
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSubmit(_ sender: UIButton) {
        if txtStoreName.text == "" {
            FTIndicator.showToastMessage("Please add store")
        }else if txtSelectService.text == "" {
            FTIndicator.showToastMessage("Please select cab")
        }else if txtSelectDriver.text == "" {
            FTIndicator.showToastMessage("Please select driver")
        }else{
            self.addAndAssignTaxiData(setting_type: "Service", allocation_type: allocationType, to_address: "", title: "taxi", from_latitude: fromLat, create_by: Singleton.sharedInstance.retailerData.ADMINID ?? "", number: "", to_longitude: toLong, from_longitude: fromLong, product_id: serviceID, allocation_id: allocationID, to_latitude: toLat, location: "", floor: "", from_address: "")
        }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      if textField == txtSelectService{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
            vc.fromSearchService = true
            vc.isFrom = "Select Cab"
            vc.updateService = { (id,name) in
                self.serviceID = id
                self.txtSelectService.text = name.capitalized
            }
            self.present(vc, animated: true, completion: nil)
        }else if textField == txtSelectDriver{
            self.view.endEditing(true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
//                    vc.fromSearchService = true
            vc.updateNurseDoc = { (type,id,name) in
                self.allocationType = name
                self.allocationID = id
                self.txtSelectDriver.text = name.capitalized
            }
            self.present(vc, animated: true, completion: nil)
        }
        return true
    }
    
    
    func addAndAssignTaxiData(setting_type:String,allocation_type:String, to_address:String,title:String,from_latitude:String,create_by:String,number:String,to_longitude:String, from_longitude:String,product_id:String,allocation_id:String,to_latitude:String,location:String,floor:String,from_address:String){
        WebServiceManager.sharedInstance.addAndAssignTaxiData(setting_type: setting_type, allocation_type: "Driver", to_address: to_address, title: title, from_latitude: from_latitude, create_by: create_by, number: number, to_longitude: to_longitude, from_longitude: from_longitude, product_id: product_id, allocation_id: allocation_id, to_latitude: to_latitude, location: location, floor: floor, from_address: from_address) { msg, status in
            if status == "1"{
                self.updateCabList()
                FTIndicator.showToastMessage("Cab Asssigned Successfully")
                self.navigationController?.popViewController(animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }


}
//MARK: GOOGLE PLACES DELEGATE
extension AddTaxiVC : GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        if isFromToField == true{
//            txtTo.text =  "\(place.name ?? "")"
//            toLat = "\(place.coordinate.latitude)"
//            toLong = "\(place.coordinate.longitude)"
        }else{
//            txtFrom.text =  "\(place.name ?? "")"
//            fromLat = "\(place.coordinate.latitude)"
//            fromLong = "\(place.coordinate.longitude)"
        }
        print("LAtitude and longitude from --",fromLat,fromLong)
        print("LAtitude and longitude to --",toLat,toLong)
        print(place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
