//
//  SetAvailabilityVC.swift
//  BBC Retail
//
//  Created by Himanshu on 07/10/22.
//

import UIKit
import DropDown
import FTIndicator
import AVFoundation
import SwiftUI
import Alamofire

class SetAvailabilityVC: UIViewController,UITextFieldDelegate,DropDownDelegate{
    //MARK:- IBOUTLETS 
    @IBOutlet weak var labelSunday: UILabel!
    @IBOutlet weak var viewSunday: UIView!
    @IBOutlet weak var btnSunday: UIButton!
    
    @IBOutlet weak var labelMonday: UILabel!
    @IBOutlet weak var viewMonday: UIView!
    @IBOutlet weak var btnMonday: UIButton!
    
    @IBOutlet weak var labelTuesday: UILabel!
    @IBOutlet weak var viewTuesday: UIView!
    @IBOutlet weak var btnTuesday: UIButton!
    
    @IBOutlet weak var labelWednesday: UILabel!
    @IBOutlet weak var viewWednesday: UIView!
    @IBOutlet weak var btnWednesday: UIButton!
    
    @IBOutlet weak var labelThursday: UILabel!
    @IBOutlet weak var viewThursday: UIView!
    @IBOutlet weak var btnThursday: UIButton!
    
    @IBOutlet weak var labelFriday: UILabel!
    @IBOutlet weak var viewFriday: UIView!
    @IBOutlet weak var btnFriday: UIButton!
    
    @IBOutlet weak var labelSaturday: UILabel!
    @IBOutlet weak var viewSaturday: UIView!
    @IBOutlet weak var btnSaturday: UIButton!
    
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var textFieldRecurrence: UITextField!
    @IBOutlet weak var textFieldEndTime: UITextField!
    @IBOutlet weak var textFieldStartTime: UITextField!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var labelClientName: UILabel!
    @IBOutlet weak var btnEndDate: UIButton!
    //MARK:- VARIABLES
    let datePicker = UIDatePicker()
    let dropDown = DropDown()
    var selectedRecurrence = ""
    var selectedState = ""
    var selectedDayArray = [Int]()
    var PickerFor = ""
    var arrDoctorSlot : [SlotEventsRepeat]?
    var doctorId = ""
    var doctorName = ""
    var selecteddayString = ""
    var selectedDay = [String]()
    var startTime = ""
    var selecStartTime = ""
    var endTime = ""
    var startDate = ""
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSunday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
        viewMonday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
        viewTuesday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
        viewWednesday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
        viewThursday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
        viewFriday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
        viewSaturday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
        self.textFieldStartDate.delegate = self
        self.textFieldStartTime.delegate = self
        self.textFieldEndTime.delegate = self
        self.allDaySwitch.isOn = false
        getDoctorSlot()
        self.labelClientName.text = doctorName
    }
    //MARK:- BUTTON ACTION
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonAllDay(_ sender: UISwitch) {
        if sender.isOn == true{
            textFieldStartTime.text = "0:01 AM"
            self.startTime = "00:01"
            textFieldEndTime.text = "23:59 PM"
            self.endTime = "23:59"
        }else{
            textFieldStartTime.text = ""
            self.startTime = ""
            textFieldEndTime.text = ""
            self.endTime = ""
        }
    }
    @IBAction func buttonRecurrence(_ sender: UIButton) {
        dropDownAction()
    }
    func selectDay(day:String){
        if self.selectedDay.contains(day){
            let firstindex = self.selectedDay.firstIndex(of: day) ?? 0
            self.selectedDay.remove(at: firstindex)
        }else{
            self.selectedDay.append(day)
        }
    }
    @IBAction func buttonSunday(_ sender: UIButton) {
        
       if selectedRecurrence == "Custom"{
           self.selectDay(day: "Sun")
            if btnSunday.isSelected == true{
                viewSunday.borderWidth = 0
                labelSunday.textColor = .black
                btnSunday.isSelected = false
            }else{
                viewSunday.borderWidth = 1
                viewSunday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                viewSunday.layer.cornerRadius = 5
                labelSunday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                btnSunday.isSelected = true
            }
        }
    }
    @IBAction func buttonMonday(_ sender: UIButton) {
     if selectedRecurrence == "Custom"{
         self.selectDay(day: "Mon")
            if btnMonday.isSelected == true{
                viewMonday.borderWidth = 0
                labelMonday.textColor = .black
                btnMonday.isSelected = false
            }else{
                viewMonday.borderWidth = 1
                viewMonday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                viewMonday.layer.cornerRadius = 5
                labelMonday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                btnMonday.isSelected = true
            }
        }
    }
    @IBAction func buttonTuesday(_ sender: UIButton) {
       if selectedRecurrence == "Custom"{
           self.selectDay(day: "Tue")
            if btnTuesday.isSelected == true{
                viewTuesday.borderWidth = 0
                labelTuesday.textColor = .black
                btnTuesday.isSelected = false
            }else{
                viewTuesday.borderWidth = 1
                viewTuesday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                viewTuesday.layer.cornerRadius = 5
                labelTuesday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                btnTuesday.isSelected = true
            }
        }
    }
    @IBAction func buttonWednesday(_ sender: UIButton) {
        if selectedRecurrence == "Custom"{
            self.selectDay(day: "Wed")
            if btnWednesday.isSelected == true{
                viewWednesday.borderWidth = 0
                labelWednesday.textColor = .black
                btnWednesday.isSelected = false
            }else{
                viewWednesday.borderWidth = 1
                viewWednesday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                viewWednesday.layer.cornerRadius = 5
                labelWednesday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                btnWednesday.isSelected = true
            }
        }
    }
    @IBAction func buttonThursday(_ sender: UIButton) {
       if selectedRecurrence == "Custom"{
           self.selectDay(day: "Thu")
            if btnThursday.isSelected == true{
                viewThursday.borderWidth = 0
                labelThursday.textColor = .black
                btnThursday.isSelected = false
            }else{
                viewThursday.borderWidth = 1
                viewThursday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                viewThursday.layer.cornerRadius = 5
                labelThursday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                btnThursday.isSelected = true
            }
        }
    }
    @IBAction func buttonFriday(_ sender: UIButton) {
      if selectedRecurrence == "Custom"{
          self.selectDay(day: "Fri")
            if btnFriday.isSelected == true{
                viewFriday.borderWidth = 0
                labelFriday.textColor = .black
                btnFriday.isSelected = false
            }else{
                viewFriday.borderWidth = 1
                viewFriday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                viewFriday.layer.cornerRadius = 5
                labelFriday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                btnFriday.isSelected = true
            }
        }
    }
    @IBAction func buttonSaturday(_ sender: UIButton) {
       if selectedRecurrence == "Custom"{
           self.selectDay(day: "Sat")
            if btnSaturday.isSelected == true{
                viewSaturday.borderWidth = 0
                labelSaturday.textColor = .black
                btnSaturday.isSelected = false
            }else{
                viewSaturday.borderWidth = 1
                viewSaturday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                viewSaturday.layer.cornerRadius = 5
                labelSaturday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                btnSaturday.isSelected = true
            }
        }
    }
    @IBAction func buttonSave(_ sender: UIButton) {
        if textFieldStartDate.text == ""{
            FTIndicator.showToastMessage("Please select date")
        }else if textFieldStartTime.text == "" {
            FTIndicator.showToastMessage("Please select start time")
        }else if textFieldEndTime.text == "" {
            FTIndicator.showToastMessage("Please select end time")
        }else if textFieldRecurrence.text == "" {
            FTIndicator.showToastMessage("Please select event type")
        }else if selectedRecurrence == "Custom"{
            if selectedDay.isEmpty == true{
                FTIndicator.showToastMessage("Please select custom days")
            }else{
                selecteddayString = self.selectedDay.joined(separator: ",")
                showIndicator()
                createSlot(doctor_Id: doctorId, doctor_Name: doctorName, event_Type: selectedRecurrence, days:selecteddayString , start_Time: self.startTime, End_Time: self.endTime, from_date: self.startDate, recurring: "1", status: "active")
            }
            
        }else if selectedRecurrence == "Daily"{
            selecteddayString = "Sun,Mon,Tue,Wed,Thu,Fri,Sat"
                showIndicator()
                createSlot(doctor_Id: doctorId, doctor_Name: doctorName, event_Type: selectedRecurrence, days:selecteddayString , start_Time: self.startTime, End_Time: self.endTime, from_date: self.startDate, recurring: "1", status: "active")
        }else if selectedRecurrence == "Weekday(Monday to Friday)"{
                selecteddayString = "Mon,Tue,Wed,Thu,Fri"
                showIndicator()
                createSlot(doctor_Id: doctorId, doctor_Name: doctorName, event_Type: selectedRecurrence, days:selecteddayString , start_Time: self.startTime, End_Time: self.endTime, from_date: self.startDate, recurring: "1", status: "active")
        }else if selectedRecurrence == "Weekend(Saturday , Sunday )"{
                selecteddayString = "Sun,Sat"
                showIndicator()
                createSlot(doctor_Id: doctorId, doctor_Name: doctorName, event_Type: selectedRecurrence, days:selecteddayString , start_Time: self.startTime, End_Time: self.endTime, from_date: self.startDate, recurring: "1", status: "active")
        }else{
            showIndicator()
            createSlot(doctor_Id: doctorId, doctor_Name: doctorName, event_Type: selectedRecurrence, days:selecteddayString , start_Time: self.startTime, End_Time: self.endTime, from_date: self.startDate, recurring: "1", status: "active")
        }
    }
    @IBAction func buttonEndDate(_ sender: UIButton) {
        self.allDaySwitch.isOn = false
        FTIndicator.showToastMessage("Please select start time first")
//            self.view.endEditing(true)
        btnEndDate.isHidden = false
        btnEndDate.alpha = 1
    }
    //MARK:- FUNCTION
    func createSlot(doctor_Id:String,doctor_Name:String,event_Type:String,days:String,start_Time:String,End_Time:String,from_date:String,recurring:String,status:String){
        WebServiceManager.sharedInstance.createSlot(doctor_Id: doctor_Id, doctor_Name: doctor_Name, event_Type: event_Type, days: days, start_Time: start_Time, End_Time: End_Time, from_date: from_date, recurring: recurring, status: status, completionHandler: { msg, status in
            if status == "1"{
                self.hideIndicator()
                FTIndicator.showToastMessage("Availability set successfully")
                self.navigationController?.popViewController(animated: true)
            }else{
                self.hideIndicator()
            }
        })
    }
    func getDoctorSlot(){
        WebServiceManager.sharedInstance.getDoctorCommonDataSlot {doctorTiming, msg, status in
        //    print(status, doctorTiming)
            if status == "1"{
                self.arrDoctorSlot = doctorTiming
            }else{
            FTIndicator.showToastMessage(msg)
            }
        }
    }
    
    func endTimePickerOpen(){
        if textFieldStartTime.text == "" {
            self.allDaySwitch.isOn = false
            FTIndicator.showToastMessage("Please select start time first")
//            self.view.endEditing(true)
            btnEndDate.isHidden = false
            btnEndDate.alpha = 1
        }else{
            btnEndDate.isHidden = true
            btnEndDate.alpha = 0
            self.PickerFor = "endtime"
            showDatePicker()
        self.allDaySwitch.isOn = false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldStartDate{
            self.PickerFor = "startdate"
            showDatePicker()
        }else if textField == textFieldStartTime{
                self.PickerFor = "starttime"
                showDatePicker()
            self.allDaySwitch.isOn = false
        }else if textField == textFieldEndTime{
            self.PickerFor = "endtime"
            showDatePicker()
        self.allDaySwitch.isOn = false
        }
        return true
    }
    func showDatePicker(){
        if self.PickerFor == "startdate"{
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }else{
        }
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: CommonConstant.Cancel, style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
        textFieldStartDate.inputAccessoryView = toolbar
        textFieldStartDate.inputView = datePicker
        
        textFieldStartDate.inputAccessoryView = toolbar
        textFieldStartDate.inputView = datePicker
        }else if self.PickerFor == "starttime" {
            datePicker.datePickerMode = .time
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }else{
            }
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            //           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
           
            
            textFieldStartTime.inputAccessoryView = toolbar
            textFieldStartTime.inputView = datePicker
            textFieldStartTime.inputAccessoryView = toolbar
            textFieldStartTime.inputView = datePicker
        }else if self.PickerFor == "endtime" {
            datePicker.datePickerMode = .time
                  let isoDate = selecStartTime
                  let dateFormatter = DateFormatter()
                  dateFormatter.locale = Locale(identifier: "UTC")
                  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                  let date = dateFormatter.date(from: isoDate)
              //    print("Strt date ---> ",date)
            datePicker.minimumDate = date
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }else{
            }
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            //           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
            textFieldEndTime.inputAccessoryView = toolbar
            textFieldEndTime.inputView = datePicker
            textFieldEndTime.inputAccessoryView = toolbar
            textFieldEndTime.inputView = datePicker
        }
    }
    

    
    @objc func donedatePicker(){
         if self.PickerFor == "startdate" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if textFieldStartDate.isFirstResponder{
                textFieldStartDate.text = formatter.string(from: datePicker.date)
                formatter.dateFormat = "MM/dd/yyyy"
                let startDate = formatter.string(from: datePicker.date)
                self.startDate = startDate
                self.view.endEditing(true)
                self.textFieldStartTime.text = ""
                self.textFieldEndTime.text = ""
        }
     
        }else if self.PickerFor == "starttime"  {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            if textFieldStartTime.isFirstResponder{
                textFieldStartTime.text = formatter.string(from: datePicker.date)
                formatter.dateFormat = "HH:mm"
                let startTime = formatter.string(from: datePicker.date)
                self.startTime = startTime
                let outputFormatter2 = DateFormatter()
                     outputFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                     print("Start time date formatter",outputFormatter2.string(from: datePicker.date))
                     self.selecStartTime = outputFormatter2.string(from: datePicker.date)
                textFieldEndTime.text = ""
                self.view.endEditing(true)
                btnEndDate.isHidden = true
                btnEndDate.alpha = 0
        }
        }else if self.PickerFor == "endtime"  {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            if textFieldEndTime.isFirstResponder{
                textFieldEndTime.text = formatter.string(from: datePicker.date)
                formatter.dateFormat = "HH:mm"
                let endTime = formatter.string(from: datePicker.date)
                self.endTime = endTime
                self.view.endEditing(true)
        }
      }
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .event:
            if value?.name ?? "" == "" {
                
            }else{
            self.textFieldRecurrence.text =  value?.name ?? ""
            self.selectedRecurrence = value?.name ?? ""
            self.WeekdaysSetup()
            }
        default: break
        }
    }
    //MARK:- DropDown Function
    func dropDownAction(){

        self.view.endEditing(true)
        let data = arrDoctorSlot
//        let drop  = DropdownPopUp(title: "Select Doctor", type: .event, dropDownType: .defaultType, data: data!, sender: self)
        
        let drop  = DropdownPopUp(title: "Select Doctor",isComingFromStatus: "Yes" ,type: .event, dropDownType: .defaultType, data: data ?? [], sender: self)
        drop.dropDownVC.delegate = self
//        let list = self.arrDoctorSlot ?? []
//        let listname = list.map({ $0.name ?? "" })
//        let listId = list.map({ $0.value ?? "" })
//        dropDown.dataSource = listname
//        dropDown.anchorView = textFieldRecurrence
//        dropDown.bottomOffset = CGPoint(x: 0, y: textFieldRecurrence.frame.size.height)
//        dropDown.backgroundColor = .white
//        dropDown.textColor = .black
//        dropDown.show()
//        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
//            self!.textFieldRecurrence.text =  "\(item)"
//            self!.selectedRecurrence = item
//            self!.WeekdaysSetup()
//            print("selectedRecurrence")
//            guard let _ = self else { return }
//        }
    }
    
    func WeekdaysSetup(){
        if selectedRecurrence == "Daily"{
            
            viewSunday.borderWidth = 1
            viewSunday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewSunday.layer.cornerRadius = 5
            labelSunday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnSunday.isUserInteractionEnabled = false
            
            viewMonday.borderWidth = 1
            viewMonday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewMonday.layer.cornerRadius = 5
            labelMonday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnMonday.isUserInteractionEnabled = false
            
            viewTuesday.borderWidth = 1
            viewTuesday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewTuesday.layer.cornerRadius = 5
            labelTuesday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnTuesday.isUserInteractionEnabled = false
            
            viewWednesday.borderWidth = 1
            viewWednesday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewWednesday.layer.cornerRadius = 5
            labelWednesday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnWednesday.isUserInteractionEnabled = false
            
            viewThursday.borderWidth = 1
            viewThursday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewThursday.layer.cornerRadius = 5
            labelThursday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnThursday.isUserInteractionEnabled = false
            
            viewFriday.borderWidth = 1
            viewFriday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewFriday.layer.cornerRadius = 5
            labelFriday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnFriday.isUserInteractionEnabled = false
            
            viewSaturday.borderWidth = 1
            viewSaturday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewSaturday.layer.cornerRadius = 5
            labelSaturday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnSaturday.isUserInteractionEnabled = false
            
        }else if selectedRecurrence == "Weekday(Monday to Friday)"{
            viewSunday.borderWidth = 0
            viewSunday.borderColor = .clear
            labelSunday.textColor = .black
            btnSunday.isUserInteractionEnabled = false
            
            viewMonday.borderWidth = 1
            viewMonday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewMonday.layer.cornerRadius = 5
            labelMonday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnMonday.isUserInteractionEnabled = false
            
            viewTuesday.borderWidth = 1
            viewTuesday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewTuesday.layer.cornerRadius = 5
            labelTuesday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnTuesday.isUserInteractionEnabled = false
            
            viewWednesday.borderWidth = 1
            viewWednesday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewWednesday.layer.cornerRadius = 5
            labelWednesday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnWednesday.isUserInteractionEnabled = false
            
            viewThursday.borderWidth = 1
            viewThursday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewThursday.layer.cornerRadius = 5
            labelThursday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnThursday.isUserInteractionEnabled = false
            
            viewFriday.borderWidth = 1
            viewFriday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewFriday.layer.cornerRadius = 5
            labelFriday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnFriday.isUserInteractionEnabled = false
            
            viewSaturday.borderWidth = 0
            viewSaturday.borderColor = .clear
            labelSaturday.textColor = .black
            btnSaturday.isUserInteractionEnabled = false
            
        }else if selectedRecurrence == "Weekend(Saturday , Sunday )"{
            viewMonday.borderWidth = 0
            viewMonday.borderColor = .clear
            labelMonday.textColor = .black
            btnMonday.isUserInteractionEnabled = false
            
            viewSunday.borderWidth = 1
            viewSunday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewSunday.layer.cornerRadius = 5
            labelSunday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnSunday.isUserInteractionEnabled = false
            
            viewTuesday.borderWidth = 0
            viewTuesday.borderColor = .clear
            labelTuesday.textColor = .black
            btnTuesday.isUserInteractionEnabled = false
            
            viewWednesday.borderWidth = 0
            viewWednesday.borderColor = .clear
            labelWednesday.textColor = .black
            btnWednesday.isUserInteractionEnabled = false
            
            viewThursday.borderWidth = 0
            viewThursday.borderColor = .clear
            labelThursday.textColor = .black
            btnThursday.isUserInteractionEnabled = false
            
            viewFriday.borderWidth = 0
            viewFriday.borderColor = .clear
            labelFriday.textColor = .black
            btnFriday.isUserInteractionEnabled = false
            
            viewSaturday.borderWidth = 1
            viewSaturday.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            viewSaturday.layer.cornerRadius = 5
            labelSaturday.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            btnSaturday.isUserInteractionEnabled = false
            
        }else if selectedRecurrence == "Custom"{
            viewSunday.borderWidth = 0
            viewSunday.borderColor = .clear
            labelSunday.textColor = .black
            btnSunday.isUserInteractionEnabled = true
            
            viewMonday.borderWidth = 0
            viewMonday.borderColor = .clear
            labelMonday.textColor = .black
            btnMonday.isUserInteractionEnabled = true
            
            viewTuesday.borderWidth = 0
            viewTuesday.borderColor = .clear
            labelTuesday.textColor = .black
            btnTuesday.isUserInteractionEnabled = true
            
            viewWednesday.borderWidth = 0
            viewWednesday.borderColor = .clear
            labelWednesday.textColor = .black
            btnWednesday.isUserInteractionEnabled = true
            
            viewThursday.borderWidth = 0
            viewThursday.borderColor = .clear
            labelThursday.textColor = .black
            btnThursday.isUserInteractionEnabled = true
            
            viewFriday.borderWidth = 0
            viewFriday.borderColor = .clear
            labelFriday.textColor = .black
            btnFriday.isUserInteractionEnabled = true
            
            viewSaturday.borderWidth = 0
            viewSaturday.borderColor = .clear
            labelSaturday.textColor = .black
            btnSaturday.isUserInteractionEnabled = true
        }
    }
}
