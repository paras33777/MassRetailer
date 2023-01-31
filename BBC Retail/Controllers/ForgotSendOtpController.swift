//
//  ForgotSendOtpController.swift
//  Newforce Admin
//
//  Created by MAC-mini on 02/02/21.
//  Copyright © 2021 NewforceTechnologies. All rights reserved.
//

import UIKit
import FTIndicator
class ForgotSendOtpController: UIViewController {
    //MARK: IBOTLET
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    //MARK: VARIABLE
   
    //MARK: IBACTIONS
    @IBAction func btnSendOtpAction(_ sender: UIButton) {
       textFieldValidations()
       }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    //MARK: ***********************SEND OTP ON MAIL API
    func sendOtpOnMail(username:String){
        showIndicator()
        WebServiceManager.sharedInstance.checkUserExist(username: username) { msg, status in
            if status == "1"{
                self.hideIndicator()
                FTIndicator.showToastMessage(msg!)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotVerifyOtpController") as! ForgotVerifyOtpController
                vc.username = username
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.hideIndicator()
                FTIndicator.showToastMessage(msg!)
            }
        }
     }
    //MARK: ************TEXTFIELD VALIDATION
    func textFieldValidations(){
        do {
            let username = try Validation.shared.validate(type: ValidationType.emailPhone, inputValue: txtEmail.text!, fieldName: "email or phone number")
             sendOtpOnMail(username: username)
        } catch(let error) {
            let message = (error as! ValidationError).message
            FTIndicator.showToastMessage(message)
          }
         }
    

}
