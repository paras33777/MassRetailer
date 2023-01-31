//
//  ForgotVerifyOtpController.swift
//  Newforce Admin
//
//  Created by MAC-mini on 02/02/21.
//  Copyright © 2021 NewforceTechnologies. All rights reserved.
//

import UIKit
import PopupDialog
import FTIndicator

class ForgotVerifyOtpController: UIViewController {
    //MARK: IBOTLET
    @IBOutlet var  otpTextFieldView: OTPFieldView!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var lblResendOtp: UILabel!
    //MARK: VARIABLE
    var username = String()
    var otp = String()
    var termText = "Didn't receive a code? Resend in 00:00 sec"
    let term = "Resend"
    var countdownTimer:Timer!
    var totalTime = 30
    //MARK: IBACTIONS
    @IBAction func btnVerifyOtpAction(_ sender: UIButton) {
        if otp.count < 3{
        FTIndicator.showToastMessage("Please enter valid OTP")
    
        }else{
            checkOtpAPI(username: username, otp: otp)
        }
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
    }
//    @IBAction func btnResendOTP(_ sender: Any) {
//      sendOtpOnMail(email: email)
//     }
    
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
        startTimer()
       }
    
    //MARK:*******START UPDATE END TIMER
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        lblResendOtp.alpha = 1
        termText = "Didn't receive a code? Resend in \(timeFormatted(totalTime)) sec"
        if totalTime != 0 {
            totalTime -= 1
            lblResendOtp.text = termText
        } else {
            termText = "Didn't receive a code? Resend"
            lblResendOtpSet()
            endTimer()
           }
        
    }
    func endTimer() {
        if countdownTimer != nil{
            countdownTimer.invalidate()
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func checkRange(_ range: NSRange, contain index: Int) -> Bool{
        return index > range.location && index < range.location + range.length
    }
    func lblResendOtpSet(){
        let formattedText = addBoldText(fullString: termText, boldPartOfString: term, baseFont: UIFont.init(name: "Montserrat-Regular", size: 14.0)!, boldFont: UIFont.init(name:"Montserrat-Medium", size: 15.0)!, boldColor: hexStringToUIColor(hex: Color.logoRed.rawValue), baseColor: UIColor.lightGray)
        lblResendOtp.attributedText = formattedText
        let tap = UITapGestureRecognizer(target:self, action: #selector(handleTermTapped))
        lblResendOtp.addGestureRecognizer(tap)
        lblResendOtp.isUserInteractionEnabled = true
        lblResendOtp.textAlignment = .center
    }
    func addBoldText(fullString: String, boldPartOfString: String, baseFont: UIFont, boldFont: UIFont,boldColor:UIColor,baseColor:UIColor) -> NSAttributedString {
        
       var attributedString = NSMutableAttributedString()
        attributedString = NSMutableAttributedString(string: termText as String, attributes: [NSAttributedString.Key.font:UIFont.init(name: "Montserrat-Regular", size: 14.0)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:hexStringToUIColor(hex: Color.logoRed.rawValue), range: NSRange(location:termText.count-term.count,length:term.count))
        attributedString.addAttribute( NSAttributedString.Key.font,value:UIFont.init(name: "Montserrat-Medium", size: 15.0)!, range: NSRange(location:termText.count-term.count,length:term.count))
        return attributedString
    }
    //MARK: ************Handler Term Tapped
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        let termString = termText as NSString
        let termRange = termString.range(of: term)
        let tapLocation = gesture.location(in: lblResendOtp)
        let index = lblResendOtp.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        if checkRange(termRange, contain: index) == true {
            reSendOTP()
            return
        }
    }
    //MARK: ************CHECK OTP API
    func checkOtpAPI(username:String,otp:String){
        showIndicator()
        WebServiceManager.sharedInstance.checkRetailerOtpExist(username: username, otp: otp) { msg, status in
            self.hideIndicator()
            if status == "1"{
                FTIndicator.showToastMessage(msg)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassController") as! ResetPassController
                vc.username = username
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
       
    }
    //MARK: ***********************SEND OTP ON MAIL API
    func reSendOTP(){
        showIndicator()
        WebServiceManager.sharedInstance.checkUserExist(username: username) { msg, status in
            self.hideIndicator()
            if status == "1"{
                self.totalTime = 30
                self.startTimer()
                FTIndicator.showToastMessage(msg!)
            }else{
                FTIndicator.showToastMessage(msg!)
            }
        }
     }
}
//MARK: *********** OTP Field Func
//MARK: *********** OTP Field Func
extension ForgotVerifyOtpController:OTPFieldViewDelegate{
    func setupOtpView(){
        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 2
        self.otpTextFieldView.defaultBorderColor = UIColor.darkGray
        self.otpTextFieldView.filledBorderColor = hexStringToUIColor(hex: Color.logoRed.rawValue)
        self.otpTextFieldView.cursorColor = UIColor.blue
        self.otpTextFieldView.displayType = .underlinedBottom
        self.otpTextFieldView.fieldSize = 40
        self.otpTextFieldView.separatorSpace = 15
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
        
    }
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        if  hasEntered{
            btnVerify.isUserInteractionEnabled = true
        }else{
            btnVerify.isUserInteractionEnabled = false
        }
        return false
    }
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        otp = otpString
    }
}
