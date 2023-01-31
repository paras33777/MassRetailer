//
//  LoginController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 12/04/22.
//

import UIKit
import FTIndicator
import CoreLocation
import DeviceCheck


import UIKit
import WebKit
//class LoginController: UIViewController, WKUIDelegate {
//   var webView: WKWebView!
//   override func viewDidLoad() {
//      super.viewDidLoad()
//    //  let myURL = URL(string:"https://bbc.newforceltd.com/")
//       let myURL = URL(string:"https://retail.maaserp.com/")
//      let myRequest = URLRequest(url: myURL!)
//      webView.load(myRequest)
//   }
//   override func loadView() {
//      let webConfiguration = WKWebViewConfiguration()
//      webView = WKWebView(frame: .zero, configuration: webConfiguration)
//      webView.uiDelegate = self
//      view = webView
//   }
//}


class LoginController: UIViewController {
    // MARK: - IBOUTLET
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    // MARK: - VARIABLE
    var location :String!
    var locationManager = CLLocationManager()
    // MARK: - IBACTIONS
    @IBAction func  btnForgotPassAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotSendOtpController") as! ForgotSendOtpController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnLoginAction(_ sender: UIButton) {
        ValidateTextField()
    }
    @IBAction func btnRedirectSignUp(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpController") as! SignUpController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEyeAction(_ sender: UIButton) {
       // let btnImg = sender.currentImage!
       // let compImg = #imageLiteral(resourceName: "closeEye")
        if txtPassword.isSecureTextEntry{
           sender.setImage(#imageLiteral(resourceName: "openEye"), for: .normal)
           txtPassword.isSecureTextEntry = false
        }else{
            sender.setImage(#imageLiteral(resourceName: "closeEye"), for: .normal)
            txtPassword.isSecureTextEntry = true
            }
    }
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
    super.viewDidLoad()
        let UUIDValue = UIDevice.current.identifierForVendor?.uuidString
        print("UUID: \(UUIDValue ?? "")")

      //  getLocation()
        txtEmail.setLeftPaddingPoints(30)
        txtPassword.setLeftPaddingPoints(30)
        txtPassword.setRightPaddingPoints(30)

    }
    func setRootVC(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootController") as! RootViewController
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    // MARK: - VALIDATION
    func ValidateTextField(){
        do {
            let email = try Validation.shared.validate(type: ValidationType.emailPhone, inputValue: txtEmail.text!, fieldName: "email or phone number")
            let password = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtPassword.text!, fieldName: "password")
           // if location != nil{
            loginAPI(username: email, password: password)
           // }else{
           //     self.checkLocationPermission()
           // }
        } catch(let error) {
            let message = (error as! ValidationError).message
            FTIndicator.showToastMessage(message)
        }
      }
    // MARK: - LOGIN API
    func loginAPI(username:String,password:String){
        SKActivityIndicator.show()
        WebServiceManager.sharedInstance.loginAPI(userName: username, password: password) { msg, status in
            SKActivityIndicator.dismiss()
            if status == "1"{
                FTIndicator.showToastMessage(msg)
                self.setRootVC()
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
}
extension LoginController:CLLocationManagerDelegate{
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        //  print("user latitude = \(userLocation.coordinate.latitude)")
        //  print("user longitude = \(userLocation.coordinate.longitude)")

        //   print("\(userLocation.coordinate.latitude)")
        //    print( "\(userLocation.coordinate.longitude)")
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in

            if (error != nil){
                print("error in reverseGeocode")
                self.locationManager.stopUpdatingLocation()
            }

            guard  let placemark = placemarks else{return}
            if placemark.count>0{
                let placemark = placemarks![0]
                // print(placemark.locality!)
                // print(placemark.administrativeArea!)
                // print(placemark.country!)

                self.location = "\(placemark.locality!) \(placemark.administrativeArea!) \(placemark.country!)"
                // print("\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                self.locationManager.stopUpdatingLocation()
            }
           }
          }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }


    //MARK: - CHECK CAMERA ACCESS

    func checkLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                DispatchQueue.main.async { [weak self] in
                    self?.alertUserCameraPermissionMustBeEnabled()
                }
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                DispatchQueue.main.async { [weak self] in
                    self!.getLocation()
                }
                @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
        }



    }

    func alertUserCameraPermissionMustBeEnabled() {

        let message = "Location access is necessary to use Augemented Reality for this app.\n\nPlease go to Settings to allow access to the Location.\n Please switch the button to the green color."

        let alert = UIAlertController (title: "Location Access Required", message: message, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title:CommonConstant.Settings, style: .default, handler: { (action) in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
                })
            }
        })

        alert.addAction(settingsAction)

        present(alert, animated: true, completion: nil)
    }

}
