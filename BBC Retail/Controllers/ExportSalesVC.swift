//
//  ExportSalesVC.swift
//  BBC Retail
//
//  Created by Himanshu on 13/10/22.
//

import UIKit
import FSCalendar
import TLMonthYearPicker
import FTIndicator

class ExportSalesVC: UIViewController,DropDownDelegate,UITextFieldDelegate,TLMonthYearPickerDelegate {
    //MARK: IBOUTLETS AND VARIABLES
    @IBOutlet weak var textFieldMonth: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var labelCalendarType: UILabel!
    @IBOutlet weak var stackViewMain: UIStackView!
    @IBOutlet weak var monthYearPicker: TLMonthYearPickerView!
    @IBOutlet var monthPickerView : UIView!{
        didSet{
            monthPickerView.alpha = 0
        }
    }
    var currentDate = ""
    let datePicker = UIDatePicker()
    var openpickerFor = ""
    var iscustom : Bool = false
    var selectedDate = Date()
    var monthPickerSelected = ""
    var selectedMonth = ""
    var selectedYear = ""
    internal var selectedMonthYear: Date!
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let myDate = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let resultString = format.string(from: myDate)
        currentDate = resultString
        textFieldMonth.delegate = self
        textFieldStartDate.delegate = self
        textFieldEndDate.delegate = self
        
        self.labelCalendarType.text = "Today"
        
        if labelCalendarType.text == "Today"{
            iscustom = false
            stackViewMain.subviews[0].isHidden = false
            stackViewMain.subviews[1].isHidden = true
            stackViewMain.subviews[2].isHidden = true
            //    stackViewMain.subviews[3].isHidden = false
        }
        monthYearPicker.minimumDate = self.minimumDate
        monthYearPicker.maximumDate = Date()
        monthYearPicker.delegate = self
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM_yyyy"
        selectedMonthYear = date
    }
    
    
    
    internal var minimumDate: Date {
        var components = Calendar.current.dateComponents([.month, .year], from: Date())
        components.year = components.year! - 5
        components.month = (components.month! - 6) % 12
        return Calendar.current.date(from: components)!
    }
    
    internal var maximumDate: Date {
        var components = Calendar.current.dateComponents([.month, .year], from: Date())
        components.year = components.year! + 5
        components.month = (components.month! + 6) % 12
        return Calendar.current.date(from: components)!
    }
    //MARK: BUTTON ACTION
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCalendarType(_ sender: UIButton) {
        dropDownAction()
        
    }
    @IBAction func btnOpenMonthPicker(_ sender : Any){
        monthPickerView.alpha = 1
    }
    @IBAction func buttonExportPDF(_ sender: UIButton) {
        if labelCalendarType.text == "Monthly" {
            allSalesExportData(startDate: "\(selectedYear)-\(selectedMonth)-1" , exportType: "pdf", endDate: "\(selectedYear)-\(selectedMonth)-\(ExportSalesVC.lastDayOfMonth(year: Int(selectedYear) ?? 0, month: Int(selectedMonth) ?? 0))", month: monthPickerSelected , day_type: "monthwise" )
        }else if labelCalendarType.text == "Weekly" {
            if textFieldStartDate.text == "" {
                FTIndicator.showToastMessage("Please select start date")
            }else{
                allSalesExportData(startDate: self.textFieldStartDate.text ?? "" , exportType: "pdf", endDate: self.textFieldEndDate.text ?? "", month: monthPickerSelected, day_type: "weekly" )
            }
        }else if labelCalendarType.text == "Today"{
            allSalesExportData(startDate: self.currentDate , exportType: "pdf", endDate: self.currentDate, month: monthPickerSelected, day_type: "today" )
        }else {
            if textFieldStartDate.text == ""{
                FTIndicator.showToastMessage("Please select start date")
            }else if textFieldEndDate.text == "" {
                FTIndicator.showToastMessage("Please select end date")
            }else{
                allSalesExportData(startDate: self.textFieldStartDate.text ?? "" , exportType: "pdf", endDate: self.textFieldEndDate.text ?? "", month: monthPickerSelected, day_type: "datewise" )
            }
        }
    }
    @IBAction func buttonExportCSV(_ sender: UIButton) {
        if labelCalendarType.text == "Monthly" {
            allSalesExportData(startDate: "\(selectedYear)-\(selectedMonth)-1" , exportType: "csv", endDate: "\(selectedYear)-\(selectedMonth)-\(ExportSalesVC.lastDayOfMonth(year: Int(selectedYear) ?? 0, month: Int(selectedMonth) ?? 0))", month: monthPickerSelected, day_type: "monthwise" )
        }else if labelCalendarType.text == "Weekly" {
            if textFieldStartDate.text == "" {
                FTIndicator.showToastMessage("Please select start date")
            }else{
                allSalesExportData(startDate: self.textFieldStartDate.text ?? "" , exportType: "csv", endDate: self.textFieldEndDate.text ?? "", month: monthPickerSelected, day_type: "weekly" )
            }
        }else if labelCalendarType.text == "Today"{
            allSalesExportData(startDate: self.currentDate , exportType: "pdf", endDate: self.currentDate, month: monthPickerSelected, day_type: "today" )
        }else if labelCalendarType.text == "Custom"{
            if textFieldStartDate.text == ""{
                FTIndicator.showToastMessage("Please select start date")
            }else if textFieldEndDate.text == "" {
                FTIndicator.showToastMessage("Please select end date")
            }else{
                allSalesExportData(startDate: self.textFieldStartDate.text ?? "" , exportType: "csv", endDate: self.textFieldEndDate.text ?? "", month:  monthPickerSelected, day_type: "datewise")
            }
        }
    }
    @IBAction func btnDoneMonthPickerAction(_ sender : Any){
        monthPickerView.alpha = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        self.selectedMonth = formatter.string(from: selectedMonthYear)
        print("Month in numeric form ",self.selectedMonth)
        formatter.dateFormat = "MMM_yyyy"
        monthPickerSelected = formatter.string(from: selectedMonthYear)
        textFieldMonth.text = formatter.string(from: selectedMonthYear)
        self.view.endEditing(true)
        let selcMonth = textFieldMonth.text?.split(separator: "_")
        self.selectedYear = String(selcMonth?[1] ?? "")
        ExportSalesVC.lastDayOfMonth(year: Int(selectedYear) ?? 0, month: Int(selectedMonth) ?? 0)
    }
    @IBAction func btnCancelMonthPickerAction(_ sender : Any){
        monthPickerView.alpha = 0
    }
    //MARK: FUNCTIONS
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldStartDate{
            self.openpickerFor = "StartDate"
            showDatePicker()
        }else if textField == textFieldEndDate{
            if textFieldStartDate.text == ""{
                FTIndicator.showToastMessage("Add Start date first")
                
            }else{
                self.openpickerFor = "EndDate"
            }
            showDatePicker()
        }
        return true
    }
    func monthYearPickerView(picker: TLMonthYearPickerView, didSelectDate date: Date) {
        self.selectedMonthYear = date
        
    }
    func allSalesExportData(startDate:String,exportType:String,endDate:String,month:String,day_type:String){
        WebServiceManager.sharedInstance.allSalesExportData(startDate: startDate, exportType: exportType, endDate: endDate, month: month, day_type: day_type) { filepath, msg, status in
            if status == "1"{
                print("File path -->",filepath)
                self.downloadFile(file: filepath)
                let text = filepath
                let textToShare = [ text ]
                
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                self.present(activityViewController, animated: true, completion: nil)
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
    static func lastDayOfMonth(year:Int, month:Int) -> Int {
        let calendar:Calendar = Calendar.current
        var dc:DateComponents = DateComponents()
        dc.year = year
        dc.month = month + 1
        dc.day = 0
        let lastDateOfMonth:Date = calendar.date(from:dc)!
        let lastDay = calendar.component(Calendar.Component.day, from: lastDateOfMonth)
        return lastDay
    }
    
    func downloadFile(file : String){
        let url = file
        let fileName = "MyFile"
        savePdf(urlString: url, fileName: fileName)
    }
    func savePdf(urlString:String, fileName:String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
            } catch {
                print("Pdf could not be saved")
            }
        }
    }
    //    MARK:- DropDown Function
    func dropDownAction(){
        self.view.endEditing(true)
        let data = Calender.getStaticStatus()
        let drop  = DropdownPopUp(title: "Select Time Interval", type: .calendar, dropDownType: .defaultType, data: data, sender: self)
        drop.dropDownVC.delegate = self
    }
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .calendar:
            if value?.name ?? "" == "Monthly"{
                let formatter = DateFormatter()
                formatter.dateFormat = "MM"
                self.selectedMonth = formatter.string(from: selectedMonthYear)
                formatter.dateFormat = "MMM_yyyy"
                textFieldMonth.text = formatter.string(from: selectedMonthYear)
                monthPickerSelected = formatter.string(from: selectedMonthYear)
                let selcMonth = textFieldMonth.text?.split(separator: "_")
                self.selectedYear = String(selcMonth?[1] ?? "")
                ExportSalesVC.lastDayOfMonth(year: Int(selectedYear) ?? 0, month: Int(selectedMonth) ?? 0)
                iscustom = false
                stackViewMain.subviews[0].isHidden = false
                stackViewMain.subviews[1].isHidden = false
                stackViewMain.subviews[2].isHidden = true
                self.labelCalendarType.text =  value?.name ?? ""
            }else if value?.name ?? "" == "Weekly"{
                monthPickerView.alpha = 0
                iscustom = false
                textFieldEndDate.text = ""
                textFieldStartDate.text = ""
                stackViewMain.subviews[0].isHidden = false
                stackViewMain.subviews[1].isHidden = true
                stackViewMain.subviews[2].isHidden = false
                self.labelCalendarType.text =  value?.name ?? ""
            }else if value?.name ?? "" == "Today"{
                monthPickerView.alpha = 0
                iscustom = false
                stackViewMain.subviews[0].isHidden = false
                stackViewMain.subviews[1].isHidden = true
                stackViewMain.subviews[2].isHidden = true
                self.labelCalendarType.text =  value?.name ?? ""
            }else if value?.name ?? "" == "Custom"{
                monthPickerView.alpha = 0
                iscustom = true
                textFieldEndDate.text = ""
                textFieldStartDate.text = ""
                stackViewMain.subviews[0].isHidden = false
                stackViewMain.subviews[1].isHidden = true
                stackViewMain.subviews[2].isHidden = false
                self.labelCalendarType.text =  value?.name ?? ""
            }
        default: break
        }
    }
    func showDatePicker(){
        if self.openpickerFor == "MonthYear"{
            datePicker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }else{
            }
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: CommonConstant.Cancel, style: .plain, target: self, action: #selector(cancelDatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
            textFieldMonth.inputAccessoryView = toolbar
            textFieldMonth.inputView = datePicker
        }else if self.openpickerFor == "StartDate" {
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }else{
            }
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: CommonConstant.Cancel, style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: true)
            textFieldStartDate.inputAccessoryView = toolbar
            textFieldStartDate.inputView = datePicker
        }else if self.openpickerFor == "EndDate" {
            datePicker.datePickerMode = .date
            if labelCalendarType.text == "Custom"{
            }else{
            }
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }else{
            }
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            //  let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: true)
            textFieldEndDate.inputAccessoryView = toolbar
            textFieldEndDate.inputView = datePicker
        }
    }
    @objc func donedatePicker(){
        if self.openpickerFor == "StartDate"  {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if textFieldStartDate.isFirstResponder{
                textFieldStartDate.text = formatter.string(from: datePicker.date)
                selectedDate = datePicker.date
                if iscustom == true{
                    textFieldEndDate.isUserInteractionEnabled = true
                }else{
                    textFieldEndDate.isUserInteractionEnabled = false
                    let nextSeven = Calendar.current.date(byAdding: .day, value: 6, to: datePicker.date)
                    textFieldEndDate.text = formatter.string(from: nextSeven ?? Date())
                }
                self.view.endEditing(true)
            }
        }else if self.openpickerFor == "EndDate"  {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if datePicker.date < selectedDate {
                FTIndicator.showToastMessage("End date should not be less than start date")
            }else{
                if textFieldEndDate.isFirstResponder{
                    textFieldEndDate.text = formatter.string(from: datePicker.date)
                    self.view.endEditing(true)
                }
            }
            
        }
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}

