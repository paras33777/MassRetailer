//
//  AddCabServiceViewController.swift
//  BBC Retail
//
//  Created by Himanshu on 18/11/22.
//

import UIKit
import AVFoundation
import FTIndicator
import GoogleMaps
import GooglePlaces
class AddCabServiceViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    //MARK: OUTLETS
    @IBOutlet weak var imgVWProduct: UIImageView!
    @IBOutlet weak var txtCurrency: SkyFloatingLabelTextField!
    @IBOutlet var txtVWDescription : UITextView!
    @IBOutlet var txtServiceName : SkyFloatingLabelTextField!
    @IBOutlet var txtPrice : SkyFloatingLabelTextField!
  
    var fromLat = ""
    var fromLong = ""
    var toLat = ""
    var toLong = ""
    var isFromToField : Bool = false
    var allocationType = ""
    var allocationID = ""
    var placeholderLabel : UILabel!
    var imageSelected : Bool = false
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
//        txtFrom.delegate = self
//        txtTo.delegate = self
//        txtSelectDriver.delegate = self
        self.imageSelected = false
        txtCurrency.text = UserDefaults.standard.string(forKey: "currency") ?? ""
        txtVWDescription.layer.cornerRadius = 2
        txtVWDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtVWDescription.layer.borderWidth = 1
//        addTextVWPlaceholder()
        txtPrice.delegate = self
//        placeholderLabel.isHidden = !txtVWDescription.text.isEmpty

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPrice {
            let text = (textField.text ?? "") + string
            
            if text.contains(".") {
                if text.count < 9{
                   
                }else{
                    return false
                }
            }else{
                if text.count < 6{
                   
                }else{
                    return false
                }
            }
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }

            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.index(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
    return true
    }
    
    
    func addService(){
        WebServiceManager.sharedInstance.addCabServiceAPI(productImage: imgVWProduct.image!, SERVICE_NAME: txtServiceName.text!, PRICE: txtPrice.text!, allocation_type: allocationType, setting_type: "Service", to_address: "", title: "taxi", from_latitude: fromLat, create_by: Singleton.sharedInstance.retailerData.ADMINID ?? "", number: "", to_longitude: toLong, from_longitude: fromLong, SERVICE_SHORT_DESCRIPTION: txtVWDescription.text!, CURRENCY_TYPE: txtCurrency.text!, allocation_id: allocationID, STORE_ID: Singleton.sharedInstance.retailerData.storeId ?? "", to_latitude: toLat, location: "", floor: "", RETAILER_ID: Singleton.sharedInstance.retailerData.RetailerId ?? "", from_address: "") { msg, status  in
            self.hideIndicator()
            if status == "1"{
                self.imageSelected = false
                self.imgVWProduct.image = UIImage(named: "add-image")
              //  self.txtSelectDriver.text = ""
                self.allocationID = ""
                self.allocationType = ""
                self.txtPrice.text = ""
               // self.txtTo.text = ""
               // self.txtFrom.text = ""
                self.txtServiceName.text = ""
                self.fromLong = ""
                self.fromLat = ""
                self.toLat = ""
                self.toLong = ""
              //  self.txtFloor.text = ""
              //  self.txtNumber.text = ""
                self.txtVWDescription.text = ""
//                self.placeholderLabel.isHidden = !self.txtVWDescription.text.isEmpty
                FTIndicator.showToastMessage("Service added successfully!")
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == txtFrom{
//            self.isFromToField = false
//            self.view.endEditing(true)
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            present(autocompleteController, animated: true, completion: nil)
//        }else if textField == txtTo{
//            self.isFromToField = true
//            self.view.endEditing(true)
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            present(autocompleteController, animated: true, completion: nil)
//        }else if textField == txtSelectDriver{
//            self.view.endEditing(true)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")as! SearchController
////                    vc.fromSearchService = true
//            vc.updateNurseDoc = { (type,id,name) in
//                self.allocationType = name
//                self.allocationID = id
//                self.txtSelectDriver.text = name.capitalized
//            }
//            self.present(vc, animated: true, completion: nil)
//        }
//        return true
//    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !txtVWDescription.text.isEmpty
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
    //MARK: BUTTON ACTION
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    @IBAction func addProductImageAction(_ sender: UIButton) {
        checkCameraAccess()
    }
    @IBAction func btnAddProductAction(_ sender: UIButton) {
        //validations()
        if self.imageSelected != true{
            FTIndicator.showToastMessage("Please select service image")
      //  if imgVWProduct.image == UIImage(named: "add-image"){
            
        }else if txtServiceName.text?.isEmpty == true{
            FTIndicator.showToastMessage("Please enter Cab Name")
        }else if txtPrice.text?.isEmpty == true{
            FTIndicator.showToastMessage("Please enter charges")
        }else{
            showIndicator()
            addService()
        }
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
                self.imageSelected = true
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
}
//MARK: GOOGLE PLACES DELEGATE
extension AddCabServiceViewController : GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        if isFromToField == true{
         //   txtTo.text =  "\(place.name ?? "")"
//            toLat = "\(place.coordinate.latitude)"
//            toLong = "\(place.coordinate.longitude)"
        }else{
           // txtFrom.text =  "\(place.name ?? "")"
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
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
