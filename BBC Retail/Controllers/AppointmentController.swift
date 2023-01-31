//
//  AppointmentController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 09/08/22.
//

import UIKit
import FTIndicator
import Alamofire

class AppointmentController: UIViewController {
    //MARK: - IBOUTLET
    @IBOutlet weak var colAvailableTime: UICollectionView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    //MARK: - VARIABLES
    
    var orderInfo : OrderInfo!
    var serviceInfo : Productlist!
    var slotTime : SlotTime?
    var configuration = Configuration()
    var orderBatchInfo : OrderBatchInfo!
    var isComingFrom = ""
    var dates = [Date]()
    var count = 6
    
    var allDateArray = [Date]()
    var totalSquares = [Date]()
    var selecedindex = 0
    
    var isSelectedCheckbox : Bool = false
    var currentSelectedDate = ""
    var month = [String]()
    var doctorId = ""
    var selectedDay = ""
    var avaialableIndex = -1
    var productId = ""
    
    var timeArray = [String]()
    var startTimes = ""
    var endTimes = ""
    var currentTime = ""
    var room_id = ""
    var slotStartTime = ""
    var slotEndTime = ""
    var slotId = ""
    var slotDate = ""
    var selecDate = ""
    var mainCurrentDate = Date()
    var sele = ""
//    var slotStartTime = ""
//    var slotEndTime = ""
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isComingFrom == "Detail"{
            self.lblTitle.text = "Reschedule Appointment"
            self.btnSubmit.setTitle("Reschedule Appointment", for: .normal)
        }else{
            self.lblTitle.text = "Sales Order List"
            self.btnSubmit.setTitle("Submit", for: .normal)
        }
        
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colAvailableTime.delegate = self
        colAvailableTime.dataSource = self
        colAvailableTime.translatesAutoresizingMaskIntoConstraints = false
        selectedDate = self.getCurrentShortDate()
        self.mainCurrentDate = self.getCurrentShortDate()
        setWeekView()
        self.lblDate.text = Date.getCurrentDates()
        self.lblSelectedDate.text = Date.getCurrentDate()
        self.currentSelectedDate = Date.getCurrentDatesFormat()
        self.selecDate = Date.getCurrentDatesFormat()
        
        self.selectedDay = Date.getCurrentDay()
        self.currentTime = Date.getCurrentTimeFormat()
        print("Selected Dates------> ",self.currentSelectedDate,doctorId,productId,currentTime)
        print("appointment time---->>>>",self.serviceInfo?.appointmentTime ?? "")
        print("appointment date---->>>>",self.serviceInfo?.appointmentDate ?? "")
        print("selected date---->>>>",self.currentSelectedDate)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.calenderCollectionView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.calenderCollectionView.addGestureRecognizer(swipeLeft)
        getSlotData(doctor_Id: serviceInfo.doctorId ?? "", date: self.lblSelectedDate.text ?? "", serviceID: serviceInfo.ProductId ?? "", day: selectedDay)//20/08/2022
    }
    override func viewDidLayoutSubviews() {
        setUpCollectionView()
        setUpAppoinmentTimeCollectionView()
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
    fileprivate func setUpAppoinmentTimeCollectionView(){
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.itemSize = CGSize(width: (colAvailableTime.frame.size.width - 2) / 3 , height: 60 )
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 0
        colAvailableTime!.collectionViewLayout = collectionFlowLayout
        colAvailableTime.setCollectionViewLayout(collectionFlowLayout, animated: false)
        colAvailableTime.delegate = self
        colAvailableTime.dataSource = self
    }
    func getCurrentShortDate() -> Date {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss ssZZZ"
        let dd = dateFormatter.string(from: todaysDate as Date)
        let DateInFormat = dateFormatter.date(from: dd)!

           return DateInFormat
       }

    func setWeekView(){
        totalSquares.removeAll()
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        while (current < nextSunday){
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        if totalSquares.contains(self.mainCurrentDate){
            self.sele = "current"
        }else{
            self.sele = ""
        }
        self.month.removeAll()
        for id in totalSquares{
            month.append(CalendarHelper().monthString1(date: id))
        }
        calenderCollectionView.reloadData()
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
                if self.totalSquares.contains(self.mainCurrentDate){
                    
                }else{
                    selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
                    setWeekView()
                    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
                    swipeRight.direction = .right
                    self.calenderCollectionView.addGestureRecognizer(swipeRight)
                    
                    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
                    swipeLeft.direction = .left
                    self.calenderCollectionView.addGestureRecognizer(swipeLeft)
                }
               
            default:
                break
            }
        }
    }
    
    //MARK: - IBACTIONS
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goToCurrentDate(_ sender: UIButton) {
        //        datepicker.selectedDate = Date()
        //        datepicker.scrollToSelectedDate(animated: true)
        //        showSelectedDate()
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if slotStartTime == "" || slotStartTime == nil{
            FTIndicator.showToastMessage("Please select time slot")
        }else{
            if isComingFrom == "Detail"{
                rescaduleAppointment(slot_id: self.serviceInfo?.slotId ?? "", service_id: self.serviceInfo?.ProductId ?? "", user_id: self.orderInfo?.userId ?? "", slot_date: self.currentSelectedDate, slot_start_time: self.slotStartTime, slot_end_time: self.slotEndTime, order_id:self.orderInfo?.orderId ?? "" , status: "rescheduled", doctor_name: serviceInfo?.doctorName ?? "", payment_method: self.orderInfo?.storePaymentType ?? "", previous_date:
                                        "\(self.serviceInfo?.appointmentDate ?? "") (\(self.self.serviceInfo?.appointmentTime ?? ""))", room_id: self.serviceInfo?.roomId ?? "", doctor_id: serviceInfo?.doctorId ?? "" )
            }else{
                rescaduleAppointment(slot_id: self.serviceInfo?.slotId ?? "", service_id: self.serviceInfo?.ProductId ?? "", user_id: self.orderBatchInfo?.userId ?? "", slot_date: self.currentSelectedDate, slot_start_time: self.slotStartTime, slot_end_time: self.slotEndTime, order_id:self.orderBatchInfo?.orderId ?? "" , status: "rescheduled", doctor_name: serviceInfo?.doctorName ?? "", payment_method: self.orderBatchInfo?.storePaymentType ?? "", previous_date:
                                        "\(self.serviceInfo?.appointmentDate ?? "") (\(self.self.serviceInfo?.appointmentTime ?? ""))", room_id: self.serviceInfo?.roomId ?? "", doctor_id: serviceInfo?.doctorId ?? "" )
            }
        }
    }
    
    //MARK: GET SLOTS DATA
    func getSlotData(doctor_Id:String,date:String,serviceID:String,day:String){
        showIndicator()
        WebServiceManager.sharedInstance.getResceduleDataSlot( doctor_Id: doctor_Id, date: date, service_Id: serviceID, day: day) { slotTime,msg, status  in
            self.hideIndicator()
            if status == "1"{
                self.slotTime = slotTime
                self.timeArray.removeAll()
                for i in self.slotTime?.docAvailSlot ?? []{
                    let starttime  = i.srarTime?.components(separatedBy: ":")
                    let st = "\(starttime?[0] ?? ""):\(starttime?[1] ?? "")"
                    
                    let endtime = i.endTime?.convertDatetring_TopreferredFormat(currentFormat: "HH:mm:ss", toFormat: "HH:mm")
                    self.startTimes = st
                    self.endTimes = i.endTime?.convertDatetring_TopreferredFormat(currentFormat: "HH:mm:ss", toFormat: "HH:mm") ?? ""
                    let df1 = DateFormatter()
                    df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                    df1.dateFormat = "HH:mm"
                    let start_time = df1.date(from: st )
                    
                    let end_time = df1.date(from: endtime ?? "")
                    
                    let minutes =  self.getMinutesDifferenceFromTwoDates(start: start_time!, end: end_time!)
                    let slot = minutes / 30
                    print("Time slot for object ----",slot)
                    let slot1 = String(slot)
                    if slot1.contains("-") == true{
                        
                    }else{
                        for ii in 0..<slot{
                            let df1 = DateFormatter()
                            df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                            df1.dateFormat = "HH:mm"
                            let start_time = df1.date(from: self.startTimes)
                            
                            let addingTime = start_time?.addingTimeInterval(30 * 60)
                            df1.dateFormat = "HH:mm"
                            self.startTimes = df1.string(from: addingTime!)
                            self.timeArray.append(self.startTimes)
                            print("Start Time ---===---==--==- \(self.timeArray)")
                            
                        }
                        //self.startTimes = ""
                    }
                    print("Start and end time --->",self.timeArray.count, self.timeArray )
                    
                }
                self.colAvailableTime.reloadData()
            }else if status == "0"{
                FTIndicator.showToastMessage("No Data Found")
                self.timeArray.removeAll()
                self.colAvailableTime.reloadData()
            }else{
                
            }
        }
    }
    //MARK: RESCHEDULE SLOT
    func rescaduleAppointment(slot_id: String, service_id: String, user_id: String, slot_date: String, slot_start_time: String, slot_end_time: String, order_id: String, status: String, doctor_name: String, payment_method: String, previous_date: String, room_id: String, doctor_id: String){
        WebServiceManager.sharedInstance.resceduleSlot(slot_id: slot_id, service_id: service_id, user_id: user_id, slot_date: slot_date, slot_start_time: slot_start_time, slot_end_time: slot_end_time, order_id: order_id, status: status, doctor_name: doctor_name, payment_method: payment_method, previous_date: previous_date, room_id: room_id, doctor_id: doctor_id ) { mag, status in
            if status == "1"{
                self.navigationController?.popViewController(animated: true)
                FTIndicator.showToastMessage("Booking rescheduled successfully")
            }else{
                FTIndicator.showToastMessage(mag)
            }
        }
    }
    
    func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> Int{
        let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)
        let hours = diff / 3600
        let minutes = hours * 60
        return minutes
    }
}

//MARK: Collection View Delegate And Data Source -
extension AppointmentController: UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calenderCollectionView{
            return totalSquares.count
        }else{
            return timeArray.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calenderCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calenderAppoinmentCell", for: indexPath) as! calenderAppoinmentCell
            
            let date = totalSquares[indexPath.item]
            cell.labelDate.text = String(CalendarHelper().dayOfMonth(date: date))
            cell.labelMonth.text = month[indexPath.row]//CalendarHelper().monthString1(date: selectedDate)
            cell.labelDay.text = CalendarHelper().monthString2(date: date)
            if self.sele == "current"{
                if totalSquares[indexPath.item] == self.mainCurrentDate{
                    self.selecedindex = indexPath.item
                    cell.labelDate.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                    cell.viewDate.layer.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                    cell.viewDate.layer.borderWidth = 1
                    print("Colord Date",date)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM, yyyy"
                    let datefrom = dateFormatter.string(from: date)
                    self.lblSelectedDate.text = datefrom
                    dateFormatter.dateFormat = "MMM yyyy"
                    let datefrom1 = dateFormatter.string(from: date)
                    self.lblDate.text = datefrom1
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let datestring1 = dateFormatter.string(from: totalSquares[self.selecedindex])
                    
                    dateFormatter.dateFormat = "EEE"
                    self.selectedDay = dateFormatter.string(from: totalSquares[self.selecedindex])
                    self.currentSelectedDate = datestring1
                }else{
                    cell.labelDate.textColor = .black
                    cell.viewDate.layer.borderColor = UIColor.clear.cgColor
                }
            }else{
                if(date == selectedDate){
                    self.selecedindex = indexPath.item
                    cell.labelDate.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                    cell.viewDate.layer.borderColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                    cell.viewDate.layer.borderWidth = 1
                    print("Colord Date",date)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM, yyyy"
                    let datefrom = dateFormatter.string(from: date)
                    self.lblSelectedDate.text = datefrom
                    dateFormatter.dateFormat = "MMM yyyy"
                    let datefrom1 = dateFormatter.string(from: date)
                    self.lblDate.text = datefrom1
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let datestring1 = dateFormatter.string(from: totalSquares[self.selecedindex])
                    
                    dateFormatter.dateFormat = "EEE"
                    self.selectedDay = dateFormatter.string(from: totalSquares[self.selecedindex])
                    self.currentSelectedDate = datestring1
                }else{
                    cell.labelDate.textColor = .black
                    cell.viewDate.layer.borderColor = UIColor.clear.cgColor
                }
            }
           
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSlotCollVW", for: indexPath) as! CellSlotCollVW
            cell.mainView.layer.cornerRadius = 5
            cell.lblTime.text = timeArray[indexPath.row]
            
            let df12 = DateFormatter()
            df12.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            df12.dateFormat = "dd/MM/yyyy"
            let start_time0 = df12.date(from: self.currentSelectedDate)
            df12.dateFormat = "dd/MM/yyyy"
            let start_time1 = df12.date(from: Date.getCurrentDatesFormat())
       
            
            if start_time0 == start_time1{
                let time = serviceInfo?.appointmentTime ?? ""
                
                var value = ""
                if time == "" || time == nil{
                    
                }else{
                    let sepTime = time.components(separatedBy: "to")
                    let time1 = sepTime[0]
                    let timeee = time1.components(separatedBy: ":")
                    let times = "\(timeee[0]):\(timeee[1])"
                    value = times
                }
                let df1 = DateFormatter()
                df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                df1.dateFormat = "dd/MM/yyyy"
                let start_time = df1.date(from: serviceInfo?.appointmentDate ?? "" )
                
                df1.dateFormat = "dd/MM/yyyy"
                let datefrom = df1.string(from: start_time!)
                
                if datefrom ==  self.currentSelectedDate{
                    if timeArray[indexPath.row] < currentTime{
                        if value == timeArray[indexPath.row]{
                            cell.mainView.backgroundColor = hexStringToUIColor(hex: "#FCEDED")
                            cell.lblTime.textColor = .systemRed
                            if #available(iOS 13.0, *) {
                                cell.mainView.layer.borderColor = UIColor.systemGray5.cgColor
                            } else {
                            }
                            cell.mainView.layer.borderWidth = 1
                        }else{
                            if #available(iOS 13.0, *) {
                                cell.mainView.backgroundColor = .systemGray6
                            } else {
                            }
                            cell.mainView.layer.borderColor = UIColor.clear.cgColor
                            cell.mainView.layer.borderWidth = 0
                            cell.lblTime.textColor = .lightGray
                        }
                    }else{
                        if value == timeArray[indexPath.row]{
                            cell.mainView.backgroundColor = hexStringToUIColor(hex: "#FCEDED")
                            cell.lblTime.textColor = .systemRed
                            if #available(iOS 13.0, *) {
                                cell.mainView.layer.borderColor = UIColor.systemGray5.cgColor
                            } else {
                            }
                            cell.mainView.layer.borderWidth = 1
                        }else{
                            
                            if avaialableIndex == indexPath.row{
                                cell.mainView.backgroundColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                                cell.lblTime.textColor = .white
                            }else{
                                if #available(iOS 13.0, *) {
                                    cell.mainView.backgroundColor = .systemGray6
                                    cell.lblTime.textColor = .black
                                } else {
                                    
                                }
                            }
                        }
                    }
                }else{
                    if timeArray[indexPath.row] < currentTime{
                        if #available(iOS 13.0, *) {
                            cell.mainView.backgroundColor = .systemGray6
                        } else {
                        }
                        cell.mainView.layer.borderColor = UIColor.clear.cgColor
                        cell.mainView.layer.borderWidth = 0
                        cell.lblTime.textColor = .lightGray
                    }else{
                        if avaialableIndex == indexPath.row{
                            cell.mainView.backgroundColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                            cell.lblTime.textColor = .white
                        }else{
                            if #available(iOS 13.0, *) {
                                cell.mainView.backgroundColor = .systemGray6
                                cell.lblTime.textColor = .black
                            } else {
                            }
                        }
                    }
                }
            }else if start_time1 ?? Date() > start_time0 ?? Date(){
                let time = serviceInfo?.appointmentTime ?? ""
                var value = ""
                if time == "" || time == nil{
                }else{
                    let sepTime = time.components(separatedBy: "to")
                    let time1 = sepTime[0]
                    let timeee = time1.components(separatedBy: ":")
                    let times = "\(timeee[0]):\(timeee[1])"
                    value = times
                }
                let df1 = DateFormatter()
                df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                df1.dateFormat = "dd/MM/yyyy"
                let start_time = df1.date(from: serviceInfo?.appointmentDate ?? "" )
                df1.dateFormat = "dd/MM/yyyy"
                let datefrom = df1.string(from: start_time!)
                if datefrom ==  self.currentSelectedDate{
                    if value == timeArray[indexPath.row]{
                        cell.mainView.backgroundColor = hexStringToUIColor(hex: "#FCEDED")
                        cell.lblTime.textColor = .systemRed
                        if #available(iOS 13.0, *) {
                            cell.mainView.layer.borderColor = UIColor.systemGray5.cgColor
                        } else {
                        }
                        cell.mainView.layer.borderWidth = 1
                    }else{
                        if #available(iOS 13.0, *) {
                            cell.mainView.backgroundColor = .systemGray6
                        } else {
                        }
                        cell.mainView.layer.borderColor = UIColor.clear.cgColor
                        cell.mainView.layer.borderWidth = 0
                        cell.lblTime.textColor = .lightGray
                    }
                }else{
                    if #available(iOS 13.0, *) {
                        cell.mainView.backgroundColor = .systemGray6
                    } else {
                    }
                    cell.mainView.layer.borderColor = UIColor.clear.cgColor
                    cell.mainView.layer.borderWidth = 0
                    cell.lblTime.textColor = .lightGray
                }
            }else{
                let time = serviceInfo?.appointmentTime ?? ""
                var value = ""
                if time == "" || time == nil{
                    
                }else{
                    let sepTime = time.components(separatedBy: "to")
                    let time1 = sepTime[0]
                    let timeee = time1.components(separatedBy: ":")
                    let times = "\(timeee[0]):\(timeee[1])"
                    value = times
                }
                let df1 = DateFormatter()
                df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                df1.dateFormat = "dd/MM/yyyy"
                let start_time = df1.date(from: serviceInfo?.appointmentDate ?? "" )
                df1.dateFormat = "dd/MM/yyyy"
                let datefrom = df1.string(from: start_time!)
                if datefrom == self.currentSelectedDate{
                    if datefrom > Date.getCurrentDatesFormat(){
                        
                        if value == timeArray[indexPath.row]{
                            //                        print("Value time for selected --> ",value,timeArray[indexPath.row])
                            cell.mainView.backgroundColor = hexStringToUIColor(hex: "#FCEDED")
                            cell.lblTime.textColor = .systemRed
                            if #available(iOS 13.0, *) {
                                cell.mainView.layer.borderColor = UIColor.systemGray5.cgColor
                            } else {
                            }
                            cell.mainView.layer.borderWidth = 1
                        }else{
                            if avaialableIndex == indexPath.row{
                                cell.mainView.backgroundColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                                cell.lblTime.textColor = .white
                            }else{
                                if #available(iOS 13.0, *) {
                                    cell.mainView.backgroundColor = .systemGray6
                                    cell.lblTime.textColor = .black
                                } else {
                                }
                            }
                        }
                    }else{
                        if value == timeArray[indexPath.row]{
                            cell.mainView.backgroundColor = hexStringToUIColor(hex: "#FCEDED")
                            cell.lblTime.textColor = .systemRed
                            if #available(iOS 13.0, *) {
                                cell.mainView.layer.borderColor = UIColor.systemGray5.cgColor
                            } else {
                            }
                            cell.mainView.layer.borderWidth = 1
                        }else{
                            if #available(iOS 13.0, *) {
                                cell.mainView.backgroundColor = .systemGray6
                            } else {
                                
                            }
                            cell.mainView.layer.borderColor = UIColor.clear.cgColor
                            cell.mainView.layer.borderWidth = 0
                            cell.lblTime.textColor = .black
                        }
                    }
                }else{
                    if avaialableIndex == indexPath.row{
                        cell.mainView.backgroundColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                        cell.lblTime.textColor = .white
                    }else{
                        if #available(iOS 13.0, *) {
                            cell.mainView.backgroundColor = .systemGray6
                            cell.lblTime.textColor = .black
                        } else {
                        }
                    }
                }
                
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.sele = ""
        if collectionView == calenderCollectionView{
            self.selecedindex = indexPath.row
            if totalSquares[self.selecedindex] < self.mainCurrentDate{
                
            }else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM yyyy"
                let datestring = dateFormatter.string(from: totalSquares[self.selecedindex])
                
                self.lblDate.text = datestring
                dateFormatter.dateFormat = "dd MMM, yyyy"
                self.lblSelectedDate.text = dateFormatter.string(from: totalSquares[self.selecedindex])
                selectedDate = totalSquares[self.selecedindex]
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let datestring1 = dateFormatter.string(from: totalSquares[self.selecedindex])
                self.currentSelectedDate = datestring1
                dateFormatter.dateFormat = "E"
                self.selectedDay = dateFormatter.string(from: totalSquares[self.selecedindex])
                print("Selected Dates------> ",self.currentSelectedDate,selectedDay)
                
                self.getSlotData(doctor_Id: serviceInfo.doctorId ?? "", date: currentSelectedDate, serviceID: serviceInfo.ProductId ?? "", day: selectedDay)
                calenderCollectionView.reloadData()
            }
      
        }else{
            
            let df12 = DateFormatter()
            df12.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            df12.dateFormat = "dd/MM/yyyy"
            let start_time0 = df12.date(from: self.currentSelectedDate)
            df12.dateFormat = "dd/MM/yyyy"
            let start_time1 = df12.date(from: Date.getCurrentDatesFormat())
     
            
            if start_time0 == start_time1{
                if timeArray[indexPath.row] < currentTime{
                    print("Time Selected")
                    
                    let time = serviceInfo?.appointmentTime ?? ""
                    var value = ""
                    if time == "" || time == nil{
                        
                    }else{
                        let sepTime = time.components(separatedBy: "to")
                        let time1 = sepTime[0]
                        let timeee = time1.components(separatedBy: ":")
                        let times = "\(timeee[0]):\(timeee[1])"
                        value = times
                    }
                    if value == timeArray[indexPath.row]{
                        FTIndicator.showToastMessage("Slot already selected")
                    }else{
                        FTIndicator.showToastMessage("Please select active time")
                    }
                }else{
                    
                    let time = serviceInfo?.appointmentTime ?? ""
                    var value = ""
                    if time == "" || time == nil{
                    }else{
                        let sepTime = time.components(separatedBy: "to")
                        let time1 = sepTime[0]
                        let timeee = time1.components(separatedBy: ":")
                        let times = "\(timeee[0]):\(timeee[1])"
                        value = times
                    }
                    if value == timeArray[indexPath.row]{
                        FTIndicator.showToastMessage("Slot already selected")
                    }else{
                        self.slotStartTime = timeArray[indexPath.row]
                        let df1 = DateFormatter()
                        // df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                        df1.dateFormat = "HH:mm"
                        let start_time = df1.date(from: self.slotStartTime)
                        
                        let addingTime = start_time?.addingTimeInterval(30 * 60)
                        df1.dateFormat = "HH:mm"
                        self.slotEndTime = df1.string(from: addingTime!)
                        
                        avaialableIndex = indexPath.row
                        colAvailableTime.reloadData()
                    }
                }
            } else if start_time1 ?? Date() > start_time0 ?? Date(){
//                if timeArray[indexPath.row] < currentTime{
                    print("Time Selected")
                    
                    let time = serviceInfo?.appointmentTime ?? ""
                    var value = ""
                    if time == "" || time == nil{
                        
                    }else{
                        let sepTime = time.components(separatedBy: "to")
                        let time1 = sepTime[0]
                        let timeee = time1.components(separatedBy: ":")
                        let times = "\(timeee[0]):\(timeee[1])"
                        value = times
                    }
                    if value == timeArray[indexPath.row]{
                        FTIndicator.showToastMessage("Please select active time")
                    }else{
                        FTIndicator.showToastMessage("Please select active time")
                    }

            }else{

                    let time = serviceInfo?.appointmentTime ?? ""
                    var value = ""
                    if time == "" || time == nil{
                    }else{
                        let sepTime = time.components(separatedBy: "to")
                        let time1 = sepTime[0]
                        let timeee = time1.components(separatedBy: ":")
                        let times = "\(timeee[0]):\(timeee[1])"
                        value = times
                    }
                    if value == timeArray[indexPath.row]{
                        FTIndicator.showToastMessage("Slot already selected")
                    }else{
                        self.slotStartTime = timeArray[indexPath.row]
                        let df1 = DateFormatter()
                        // df1.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                        df1.dateFormat = "HH:mm"
                        let start_time = df1.date(from: self.slotStartTime)
                        
                        let addingTime = start_time?.addingTimeInterval(30 * 60)
                        df1.dateFormat = "HH:mm"
                        self.slotEndTime = df1.string(from: addingTime!)
                        
                        avaialableIndex = indexPath.row
                        colAvailableTime.reloadData()
                    }
//                }
            }
            
            

        }
    }
}
extension Date {
    static func getCurrentDate1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: Date())
    }
    static func getCurrentDates1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: Date())
    }
    static func getCurrentDatesFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
    static func getCurrentTimeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
    static func getDay1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: Date())
    }
}
extension String {
    func convertDatetring_TopreferredFormat1(currentFormat: String, toFormat : String) ->  String {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = currentFormat
        let resultDate = dateFormator.date(from: self)
        dateFormator.dateFormat = toFormat
        return dateFormator.string(from: resultDate ?? Date())
    }
}

class CellSlotCollVW: UICollectionViewCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet var mainView : UIView!
}

//MARK: Collection View Cell
class calenderAppoinmentCell : UICollectionViewCell{
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var labelDate: UILabel!
}
