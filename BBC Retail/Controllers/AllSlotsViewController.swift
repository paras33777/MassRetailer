//
//  AllSlotsViewController.swift
//  BBC Retail
//
//  Created by Himanshu on 05/10/22.
//

import UIKit
import FTIndicator

var selectedDate = Date()

class AllSlotsViewController: UIViewController,DropDownDelegate {
    //MARK:- Outlets
    @IBOutlet weak var btnShowHideBookedSlots: UIButton!
    @IBOutlet weak var labelFullDate: UILabel!
    @IBOutlet weak var labelDoctor: UILabel!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    @IBOutlet weak var allSlotTableView: UITableView!
    
    var fromTime = ""
    var endTime = ""
    var startInd = Int()
    var endInd = Int()
    var strut : [stime]?
    //MARK:- Var
    var allDateArray = [Date]()
    var totalSquares = [Date]()
    var selecedindex = 0
    var selectedDoctor = ""
    var selectedDoctorId = ""
    var currentSelectedDate = ""
    var dropdowns : [DoctorData]!
    var allSlotTime : SlotTime!
    var isSelectedCheckbox : Bool = false
    var timeArray:Array = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    var timeArray1:Array = ["00","00:00","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30"]
    var month = [String]()
    var bokedSlotssss = [String]()
    var slotsss = [String]()
    var endTimes = [String]()
    var slotEnd = [String]()
    var orderIds = [String]()
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnShowHideBookedSlots.isSelected = false
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.translatesAutoresizingMaskIntoConstraints = false
        setWeekView()
        //        calenderCollectionView.reloadData()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.calenderCollectionView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.calenderCollectionView.addGestureRecognizer(swipeLeft)
        getDoctorDetail()
        
        //MARK: - TABLE VIEW
        self.allSlotTableView.register(UINib(nibName: "allSlotTableViewCellUpper", bundle: nil), forCellReuseIdentifier: "allSlotTableViewCellUpper")
        self.allSlotTableView.register(UINib(nibName: "allSlotTableViewCellMid", bundle: nil), forCellReuseIdentifier: "allSlotTableViewCellMid")
        self.allSlotTableView.register(UINib(nibName: "allSlotBottomCell", bundle: nil), forCellReuseIdentifier: "allSlotBottomCell")
        self.allSlotTableView.register(UINib(nibName: "allSlotNoDataCell", bundle: nil), forCellReuseIdentifier: "allSlotNoDataCell")
        self.allSlotTableView.delegate = self
        self.allSlotTableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        setUpCollectionView()
    }
    
    func setWeekView(){
        totalSquares.removeAll()
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        while (current < nextSunday){
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        self.month.removeAll()
        for id in totalSquares{
            month.append(CalendarHelper().monthString1(date: id))
        }
        calenderCollectionView.reloadData()
    }
    //MARK: COLLECTIONVIEW SETUP
    fileprivate func setUpCollectionView(){
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .horizontal
        collectionFlowLayout.itemSize = CGSize(width: (calenderCollectionView.frame.size.width - 2) / 7 , height:(calenderCollectionView.frame.size.height - 2) )
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 0
        calenderCollectionView!.collectionViewLayout = collectionFlowLayout
        calenderCollectionView.setCollectionViewLayout(collectionFlowLayout, animated: false)
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left:
                print("Swiped left")
                selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
                
                setWeekView()
                let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
                swipeRight.direction = .right
                self.calenderCollectionView.addGestureRecognizer(swipeRight)
                
                let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
                swipeLeft.direction = .left
                self.calenderCollectionView.addGestureRecognizer(swipeLeft)
            case .right:
                print("Swiped right")
                selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
                
                setWeekView()
                let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
                swipeRight.direction = .right
                self.calenderCollectionView.addGestureRecognizer(swipeRight)
                
                let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
                swipeLeft.direction = .left
                self.calenderCollectionView.addGestureRecognizer(swipeLeft)
            default:
                break
            }
        }
    }
    //MARK:- Button Action
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    @IBAction func buttonChangeDoctor(_ sender: UIButton) {
        self.dropDownAction()
    }
    @IBAction func buttonSetAvailability(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAvailabilityVC") as! SetAvailabilityVC
        vc.doctorName = self.labelDoctor.text ?? ""
        vc.doctorId = selectedDoctorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonShowBookedSlots(_ sender: UIButton) {
        btnShowHideBookedSlots.isSelected = !btnShowHideBookedSlots.isSelected
        if btnShowHideBookedSlots.isSelected == true {
            isSelectedCheckbox = true
            allSlotTableView.reloadData()
        }else{
            isSelectedCheckbox = false
            allSlotTableView.reloadData()
        }
    }
    @IBAction func buttonCancel(_ sender: UIButton) {
        
    }
    
    //MARK: FUNCTION
    //MARK:- DropDown Function
    func dropDownAction(){
        self.view.endEditing(true)
        let data = dropdowns
        
        let drop  = DropdownPopUp(title: "Select Doctor",isComingFromStatus: "Yes" ,type: .doctors, dropDownType: .defaultType, data: data!, sender: self)
        drop.dropDownVC.delegate = self
        
//        let drop  = DropdownPopUp(title: "Select Doctor", type: .doctors, dropDownType: .defaultType, data: data!, sender: self)
//        drop.dropDownVC.delegate = self
    }
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        switch dataType {
        case .doctors:
            showIndicator()
            if value?.doctor_name ?? "" == "" {
                
            }else{
                self.selectedDoctor = value?.doctor_name ?? ""
                self.selectedDoctorId = value?.doctor_id ?? ""
                self.labelDoctor.text = value?.doctor_name ?? ""
            }
            let dates = convertdates(dates: selectedDate)
            
            self.labelFullDate.text = dates
            setWeekView()
            
            let date = convertdatess(dates: selectedDate)
            let day = convertday(dates: selectedDate)
            
            self.doctorAvability(doctor_id: self.selectedDoctorId, date: date, day: day)
            
        default: break
        }
    }
    //MARK: GET SLOTS DATA
    func getDoctorDetail(){
        WebServiceManager.sharedInstance.getDoctorDetailByStoreId { doctorDetail, msg, status in
            
            if status == "1"{
                self.dropdowns = doctorDetail
                self.selectedDoctor = self.dropdowns?.first?.doctor_name ?? ""
                self.selectedDoctorId = self.dropdowns?.first?.doctor_id ?? ""
                self.labelDoctor.text = self.dropdowns?.first?.doctor_name ?? ""
                self.labelFullDate.text = Date.getCurrentDates()
                let date = Date.getCurrentDate()
                let day = Date.getDay()
                self.doctorAvability(doctor_id: self.dropdowns?.first?.doctor_id ?? "", date: date, day: day)
            }else{
                FTIndicator.showToastMessage("No Data Found")
            }
        }
    }
    func doctorAvability(doctor_id:String,date:String,day:String){
        WebServiceManager.sharedInstance.getDoctorAvability(doctor_id: doctor_id, date: date, day: day) { avaibality, msg, status in
            if status == "0"{
                self.hideIndicator()
                FTIndicator.showToastMessage("No data found")
                self.allSlotTableView.reloadData()
                self.allSlotTableView.isHidden = true
            }else if status == "1"{
                self.hideIndicator()
                self.allSlotTime = nil
                self.allSlotTime = avaibality
                let startFullTime = self.allSlotTime?.docAvailSlot?.first?.Doctor_availability_starttime?.split(separator: ":")
                self.fromTime = String(startFullTime?.first ?? "")
                let endFullTime = self.allSlotTime?.docAvailSlot?.first?.Doctor_availability_endtime?.split(separator: ":")
                self.endTime = String(endFullTime?.first ?? "")
                self.startInd = self.timeArray1.firstIndex(of: "\(startFullTime?[0] ?? ""):\(startFullTime?[1] ?? "")") ?? 0
                self.endInd = self.timeArray1.firstIndex(of: "\(endFullTime?[0] ?? ""):\(endFullTime?[1] ?? "")") ?? 0
                self.slotsss.removeAll()
                self.orderIds.removeAll()
                self.bokedSlotssss.removeAll()
                for i in self.allSlotTime.bookedSlot ?? []{
                    let value  = i.srarTime?.split(separator: ":")
                    print("print end time ",value?.first ?? "")
                    self.bokedSlotssss.append("\(String(value?[0] ?? "")):\(String(value?[1] ?? ""))")
                }
                for id in self.timeArray1{
                    if self.bokedSlotssss.contains(id){
                        self.slotsss.append(id)
                    }else{
                        self.slotsss.append("0")
                    }
                }
                self.orderIds.removeAll()
                print("Booked Slots ---->",self.bokedSlotssss.count , self.timeArray1.count, self.bokedSlotssss,self.slotsss.count,self.slotsss,self.orderIds.count,self.orderIds)
                
                self.allSlotTableView.reloadData()
                self.allSlotTableView.isHidden = false
            }else{
            }
        }
    }
    func convertdate(date:String) -> Date{
        let isoDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let date = dateFormatter.date(from: isoDate)!
        return date
    }
    func convertdates(dates:Date) -> String{
        let isoDate = dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let date = dateFormatter.string(from: isoDate)
        return date
    }
    func convertdatess(dates:Date) -> String{
        let isoDate = dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: isoDate)
        return date
    }
    func convertday(dates:Date) -> String{
        let isoDate = dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let date = dateFormatter.string(from: isoDate)
        return date
    }
}
//MARK: Collection View Cell
class CalenderCell : UICollectionViewCell{
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var labelDate: UILabel!
}
//MARK: Collection View Delegate And Data Source -
extension AllSlotsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderCell", for: indexPath) as! CalenderCell
        let date = totalSquares[indexPath.item]
        cell.labelDate.text = String(CalendarHelper().dayOfMonth(date: date))
        cell.labelMonth.text = month[indexPath.row]//CalendarHelper().monthString1(date: selectedDate)
        cell.labelDay.text = CalendarHelper().monthString2(date: date)
        if(date == selectedDate){
            cell.labelDate.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            cell.viewDate.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
            cell.viewDate.borderWidth = 1
            self.selecedindex = indexPath.item
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let datestring = dateFormatter.string(from: totalSquares[self.selecedindex])
            self.labelFullDate.text = datestring
        }else{
            cell.labelDate.textColor = .black
            cell.viewDate.borderColor = .clear
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if String(CalendarHelper().dayOfMonth(date: Date)) ==
        self.selecedindex = indexPath.item
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let datestring = dateFormatter.string(from: totalSquares[self.selecedindex])
        self.currentSelectedDate = datestring
        self.labelFullDate.text = currentSelectedDate
        selectedDate = totalSquares[self.selecedindex]
        self.calenderCollectionView.reloadData()
        let date = convertdatess(dates: selectedDate)
        let day = convertday(dates: selectedDate)
        self.doctorAvability(doctor_id: self.selectedDoctorId, date: date, day: day)
    }
}
//MARK: EXTENSION DATE
extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
    static func getCurrentDates() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: Date())
    }
    static func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: Date())
    }
    static func getCurrentDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: Date())
    }
}
//MARK: EXTENSION TABLE VIEW DELEGATE AND DATA SOURCE
extension AllSlotsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray1.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == startInd{
            let cell = tableView.dequeueReusableCell(withIdentifier: "allSlotTableViewCellUpper", for: indexPath) as! allSlotTableViewCellUpper
            cell.lblTime.text = timeArray1[indexPath.row]
            if slotsss.count == 0{
                cell.desView.isHidden = true
            }else{
                for i in self.allSlotTime.bookedSlot ?? []{
                    let value  = i.srarTime?.split(separator: ":")
                    print("print end time ",value?.first ?? "")
                    let value1 =  "\(String(value?[0] ?? "")):\(String(value?[1] ?? ""))"
                    if slotsss.contains(value1){
                        print("Order id of index === ",i.OrderId ?? "")
                        cell.btnOrderDetailHandler = {
                            print("SElected order id --",i.OrderId ?? "")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as! OrderDetailController
                            vc.orderIdAppointmemnt = i.OrderId ?? ""
                            vc.isComingFromAppointment = "true"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        print("Order id of index === ")
                    }
                }
                if timeArray1[indexPath.row] == slotsss[indexPath.row]{
                    let value  = slotsss[indexPath.row]
                    
                    let df1 = DateFormatter()
                    df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                    df1.dateFormat = "HH:mm"
                    let start_time = df1.date(from: value)
                    
                    let addingTime = start_time?.addingTimeInterval(30 * 60)
                    df1.dateFormat = "HH:mm"
                    let endtime = df1.string(from: addingTime!)
                    cell.desView.isHidden = false
                    cell.lblDescr.text = "\("Appointment timing: " + (value)  + " to " + (endtime))"
                }else{
                    cell.desView.isHidden = true
                }
            }
            return cell
        }else if indexPath.row == endInd{
            let cell = tableView.dequeueReusableCell(withIdentifier: "allSlotBottomCell", for: indexPath) as! allSlotBottomCell
            cell.lblTime.text = timeArray1[indexPath.row]
            if slotsss.count == 0{
                cell.desView.isHidden = true
            }else{
                for i in self.allSlotTime.bookedSlot ?? []{
                    let value  = i.srarTime?.split(separator: ":")
                    print("print end time ",value?.first ?? "")
                    let value1 =  "\(String(value?[0] ?? "")):\(String(value?[1] ?? ""))"
                    if slotsss.contains(value1){
                        print("Order id of index === ",i.OrderId ?? "")
                        cell.btnOrderDetailHandler = {
                            print("SElected order id --",i.OrderId ?? "")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as! OrderDetailController
                            vc.orderIdAppointmemnt = i.OrderId ?? ""
                            vc.isComingFromAppointment = "true"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        print("Order id of index === ")
                    }
                }
                if timeArray1[indexPath.row] == slotsss[indexPath.row]{
                    cell.desView.isHidden = false
                    let value  = slotsss[indexPath.row]
                    
                    let df1 = DateFormatter()
                    df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                    df1.dateFormat = "HH:mm"
                    let start_time = df1.date(from: value)
                    
                    let addingTime = start_time?.addingTimeInterval(30 * 60)
                    df1.dateFormat = "HH:mm"
                    let endtime = df1.string(from: addingTime!)
                    
                    cell.lblDescr.text = "\("Appointment timing: " + (value)  + " to " + (endtime) )"
                }else{
                    cell.desView.isHidden = true
                }
            }
            return cell
        }else if (startInd...endInd).contains(indexPath.row){
            let cell = tableView.dequeueReusableCell(withIdentifier: "allSlotTableViewCellMid", for: indexPath) as! allSlotTableViewCellMid
            cell.lblTime.text = timeArray1[indexPath.row]
            if slotsss.count == 0{
                cell.desView.isHidden = true
            }else{
                for i in self.allSlotTime.bookedSlot ?? []{
                    let value  = i.srarTime?.split(separator: ":")
                    print("print end time ",value?.first ?? "")
                    let value1 =  "\(String(value?[0] ?? "")):\(String(value?[1] ?? ""))"
                    if slotsss[indexPath.row].contains(value1){
                        print("Order id of index === ",i.OrderId ?? "")
                        cell.btnOrderDetailHandler = {
                            print("SElected order id --",i.OrderId ?? "")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as! OrderDetailController
                            vc.orderIdAppointmemnt = i.OrderId ?? ""
                            vc.isComingFromAppointment = "true"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        print("Order id of index === ")
                    }
                }
                if timeArray1[indexPath.row] == slotsss[indexPath.row]{
                    cell.desView.isHidden = false
                    let value  = slotsss[indexPath.row]
                    
                    let df1 = DateFormatter()
                    df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                    df1.dateFormat = "HH:mm"
                    let start_time = df1.date(from: value)
                    
                    let addingTime = start_time?.addingTimeInterval(30 * 60)
                    df1.dateFormat = "HH:mm"
                    let endtime = df1.string(from: addingTime!)
                    
                    cell.lblDescr.text = "\("Appointment timing: " + (value)  + " to " + (endtime) )"
                }else{
                    cell.desView.isHidden = true
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "allSlotNoDataCell", for: indexPath) as! allSlotNoDataCell
            cell.lblTime.text = timeArray1[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (startInd...endInd).contains(indexPath.row){
            if isSelectedCheckbox == true{
                return 0
            }else{
                return 70
            }
        }else{
            return 70
        }
    }
}
extension String {
    func convertDatetring_TopreferredFormat(currentFormat: String, toFormat : String) ->  String {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = currentFormat
        let resultDate = dateFormator.date(from: self)
        dateFormator.dateFormat = toFormat
        return dateFormator.string(from: resultDate ?? Date())
    }
    
}
struct stime{
    var stime = ""
    
}
