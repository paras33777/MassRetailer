//
//  OrderDetailController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 20/04/22.
//

import UIKit
import FTIndicator
import UIView_Shimmer
enum productType :  String{
    case service = "Service",Product = "Product"
    
}
class OrderDetailController: UIViewController, UITextFieldDelegate ,GetStatus, cancelBooking ,confirmReschedule {
    func cancelConfirm() {
        showIndicator()
        let indexPath1 = IndexPath(row: 0, section: 1)
        let cell = tblVw.cellForRow(at: indexPath1) as! AppointmentCell
        
        
        updateSlotStatus(store_id: self.orderInfo?.storeId ?? "", room_id: self.orderInfo?.productList?[indexPath1.row].roomId ?? "", previous_date: "\(self.orderInfo?.productList?[indexPath1.row].appointmentDate ?? "") (\(orderInfo?.productList?[indexPath1.row].appointmentTime ?? ""))", user_id: self.orderInfo?.userId ?? "", slot_id: self.orderInfo?.productList?[indexPath1.row].slotId ?? "", service_id: self.orderInfo?.productList?[indexPath1.row].ProductId ?? "", vertical: Singleton.sharedInstance.retailerData.category ?? "", doctor_name: self.orderInfo?.productList?[indexPath1.row].doctorName ?? "", order_id: self.orderInfo?.orderId ?? "", payment_method: self.orderInfo?.storePaymentType ?? "", status: "cancel")
    }
    
    func appointmentResponse() {
        let indexPath1 = IndexPath(row: 0, section: 1)
        let cell = tblVw.cellForRow(at: indexPath1) as! AppointmentCell
        
//        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
//        guard let indexPath = self.tblVw.indexPathForRow(at:buttonPosition) else{return}
        
        let serviceInfo = orderInfo.productList![indexPath1.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentController") as! AppointmentController
        vc.serviceInfo = serviceInfo
        vc.orderInfo = orderInfo
        vc.isComingFrom = "Detail"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeStatus() {
        getOrderDetailByOrderID()
    }
    
    //MARK: - IBOUTLET
    
    @IBOutlet weak var viewAcceptReject: UIView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var imgDownloadInvoice: UIImageView!
    @IBOutlet weak var tblVw: UITableView!{
        didSet{
            tblVw.alpha = 0
        }
    }
    @IBOutlet weak var collStatus: UICollectionView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var heightCollView: NSLayoutConstraint!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var labelOrderStatus: UILabel!
    @IBOutlet weak var btnOpenDropdown: UIButton!
    @IBOutlet weak var labelDineIn: UILabel!
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var btnDownloadInvoiceHeight: NSLayoutConstraint!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var labelSubStatus: UILabel!
    @IBOutlet weak var viewAceeptAndOrdrStatusHeight: NSLayoutConstraint!
    
    //MARK: - VARIABLES
    let columnLayout = CustomViewFlowLayout()
    private var isLodinData = true
    var ordedrDetail : OrderList!
    var orderInfo : OrderInfo!
    var orderStatus : [DropDownModel]!
    var dropdowns : [OrderStatusType]!
    var selectedStatuIndexath : IndexPath? = nil
    let sectionTitles = ["Customer Name","Details","Payment Details"]
    var orderType = ""
    var paymentStatus = ""
    var paymentMode = ""
    var color = ""
    var subStatus = ""
    var currDate = ""
    var currTime = ""
    var orderIdAppointmemnt = ""
    var isComingFromAppointment = ""
    var product_type = ""
    //MARK: - IBACTIONS
    @IBAction func btnBackAction(_ sender: UIButton) {
        if isComingFromAppointment == "Self Booking" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }

    }
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderDetailByOrderID()
        self.showIndicator()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getOrderDetailByOrderID()
        self.showIndicator()
    }
    var updateOrderList : (() -> Void)!
    @IBAction func buttonReject(_ sender: UIButton) {
        orderStatusChange(store_id: self.orderInfo?.storeId ?? "", slot_start_time: self.orderInfo?.productList?[0].appointmentTime ?? "", slot_date: self.orderInfo?.productList?[0].appointmentDate ?? "", sub_status: self.orderInfo?.sub_status ?? "", service_name: self.orderInfo?.productList?[0].ProductName ?? "", retailer_id: Singleton.sharedInstance.retailerData.RetailerId ?? "", user_id: self.orderInfo?.userId ?? "", service_id: self.orderInfo?.productList?[0].ProductId ?? "", doctor_name: self.orderInfo?.productList?[0].doctorName ?? "", order_id: self.orderInfo?.orderId ?? "", payment_method: self.orderInfo?.storePaymentType ?? "", status: "cancelled")
    }
    @IBAction func buttonAccept(_ sender: UIButton) {
        orderStatusChange(store_id: self.orderInfo?.storeId ?? "", slot_start_time: self.orderInfo?.productList?[0].appointmentTime ?? "", slot_date: self.orderInfo?.productList?[0].appointmentDate ?? "", sub_status: self.orderInfo?.sub_status ?? "", service_name:  self.orderInfo?.productList?[0].ProductName ?? "", retailer_id: Singleton.sharedInstance.retailerData.RetailerId ?? "" , user_id: self.orderInfo?.userId ?? "", service_id: self.orderInfo?.productList?[0].ProductId ?? "", doctor_name: self.orderInfo?.productList?[0].doctorName ?? "", order_id: self.orderInfo?.orderId ?? "", payment_method: self.orderInfo?.storePaymentType ?? "", status: "Accepted")
    }
    @IBAction func buttonOpenStatusDropdown(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateStatusVC") as! UpdateStatusVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.paymentMethod = orderInfo.paymentStatus ?? ""
        vc.userID = orderInfo.userId
        vc.oderID = orderInfo.orderId ?? ""
        vc.comingStatus = self.labelOrderStatus.text ?? ""
        vc.statusDelegate = self
        vc.isFromStaus = "Yes"
        self.present(vc, animated: false,completion: nil)
    }
    //MARK: Current Date and Time
    func CurrentDateTime(){
        let format = DateFormatter()
        format.dateFormat = "dd MMM, yyyy"
        let resultString = format.string(from: Date())
        print(resultString)
        self.currDate = resultString
        
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:ss"
        let stringDate = timeFormatter.string(from: time)
        self.currTime = stringDate
    }
    //MARK: - Change Order Status API (Accept-Reject)
    func orderStatusChange(store_id: String, slot_start_time: String, slot_date: String, sub_status: String, service_name: String, retailer_id: String, user_id: String, service_id: String, doctor_name: String, order_id: String, payment_method: String, status: String){
        showIndicator()
        let vertical : String?
        if ordedrDetail.category == "" {
            vertical = Singleton.sharedInstance.retailerData.category
            hideIndicator()
        }else{
            vertical = ordedrDetail.category
            hideIndicator()
        }
        WebServiceManager.sharedInstance.changeOrderStatusAPI(store_id: store_id, slot_start_time: slot_start_time, slot_date: slot_date, sub_status: sub_status, service_name: service_name, retailer_id: retailer_id, vertical: vertical ?? "", user_id: user_id, service_id: service_id, doctor_name: doctor_name, order_id: order_id, payment_method: payment_method, status: status) { msg, status  in
            if status == "1"{
                FTIndicator.showToastMessage("Order status changed successfully")
                self.viewAcceptReject.alpha = 0
            }else{
                FTIndicator.showToastMessage(msg!)
            }
        }
    }
    
    //MARK: ************UPDATE NO DATA FOUND
    func updateNoData(message:String){
        if self.orderInfo != nil {
            self.tblVw.backgroundView = UIView()
        }else{
            let vwNoData = ViewNoData()
            self.tblVw.backgroundView = vwNoData
            vwNoData.imgVw.image = UIImage(named: "noDataFound")
            vwNoData.center.x = self.view.center.x
            vwNoData.center.y =  self.view.center.y
            vwNoData.label.text = message
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard orderInfo != nil else{
            btnDownload.alpha = 0
            btnDownloadInvoiceHeight.constant = 0
            imgDownloadInvoice.alpha = 0
            tblVw.tableHeaderView!.frame.size.height = 0
            return}
        if let status = orderInfo.paymentStatus?.lowercased(), status == "completed" || status == "complete"{
            btnDownload.alpha = 1
            btnDownloadInvoiceHeight.constant = 20
            imgDownloadInvoice.alpha = 1
        }else{
            btnDownload.alpha = 0
            btnDownloadInvoiceHeight.constant = 0
            imgDownloadInvoice.alpha = 0
        }
        guard let headerView = tblVw.tableHeaderView else {return}
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tblVw.tableHeaderView = headerView
            tblVw.layoutIfNeeded()
        }
    }
    
    //MARK: ******* UPDATE TABLE HEADER
    func updateTableHeader(){
        guard orderInfo != nil else{return}
        lblOrderID.text = orderInfo.orderId ?? ""
        lblTotal.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(orderInfo.totalAmount ?? "")"
        
        lblDate.text = orderInfo.orderdate ?? ""
        if orderInfo.paymentStatus?.lowercased() == "completed" || orderInfo.paymentStatus?.lowercased() == "complete"{
            btnDownload.alpha = 1
            btnDownloadInvoiceHeight.constant = 20
            imgDownloadInvoice.alpha = 1
            btnDownload.addTarget(self, action: #selector(btnDownloadInvoice(sender:)), for: .touchUpInside)
        }else{
            btnDownload.alpha = 0
            btnDownloadInvoiceHeight.constant = 0
            imgDownloadInvoice.alpha = 0
        }
    }
    
    //MARK: UPDATE SLOT STATUS
    func updateSlotStatus(store_id:String, room_id:String, previous_date:String,user_id:String,slot_id:String, service_id:String, vertical:String, doctor_name:String, order_id:String, payment_method:String, status:String){
        WebServiceManager.sharedInstance.updateSlotStatus(store_id: store_id, room_id: room_id, status: status, slot_id: slot_id, service_id: service_id, user_id: user_id, order_id: order_id, doctor_name: doctor_name, previous_date: previous_date, payment_method: payment_method) { msg, status in
            if status == "1"{
                self.hideIndicator()
                self.getOrderDetailByOrderID()
                FTIndicator.showToastMessage("Appointment cancelled")
            }else {
                self.hideIndicator()
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
    //MARK: ************UPDATE ORDER STATUS
    func updateOrderStatus(paymentMethod: String, userID: String, status: String, oderID: String){
        showIndicator()
        WebServiceManager.sharedInstance.updateOrderStatus(paymentMethod: paymentMethod, userID: userID, status: status, oderID: oderID){ msg, status in
            self.hideIndicator()
            if status == "1"{
                // self.orderStatus = orderStatus
                self.getOrderDetailByOrderID()
                FTIndicator.showToastMessage(msg!)
            }else{
                FTIndicator.showToastMessage(msg!)
            }
        }
    }
    //MARK: ************GET ORDER DETAIL
    func getOrderDetailByOrderID(){
        if isComingFromAppointment == "true"{
            let vertical : String?
            //            if ordedrDetail.category == "" {
            vertical = Singleton.sharedInstance.retailerData.category
            //            }else{
            //                vertical = ordedrDetail.category
            //            }
            
            let productType =  ordedrDetail.product_type ?? ""
            WebServiceManager.sharedInstance.getOrderDetails(orderID: orderIdAppointmemnt,vertical: vertical!,product_type: productType) { orderInfo, msg, status in
                self.isLodinData = false
                if status == "1"{
                    self.hideIndicator()
                    self.orderInfo = orderInfo
                    self.updateTableHeader()
                    //    self.collStatus.reloadData()
                    //  self.heightCollView.constant = self.collStatus.collectionViewLayout.collectionViewContentSize.height
                    self.tblVw.alpha = 1
                    self.tblVw.reloadData()
                    self.labelSubStatus.text = self.orderInfo.sub_status
                    self.labelPayment.text = self.paymentMode
                    self.labelOrderStatus.text? = self.orderInfo?.paymentStatus?.capitalized ?? ""
                    if orderInfo?.paymentStatus?.lowercased() == "complete" || orderInfo?.paymentStatus?.lowercased() == "completed" {
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "prepared" || orderInfo?.paymentStatus?.lowercased() == "Prepared" {
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "cancelled" || orderInfo?.paymentStatus?.lowercased() == "Cancelled"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Accepted" || orderInfo?.paymentStatus?.lowercased() == "preparing"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Accepted" || orderInfo?.paymentStatus?.lowercased() == "accepted"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Pending" || orderInfo?.paymentStatus?.lowercased() == "pending"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else{
                        
                    }
                    if self.orderInfo.sub_status  == "" && Singleton.sharedInstance.retailerData.category != "hospital" {
                        
                        self.viewAceeptAndOrdrStatusHeight.constant = 0
                    }else {
                        self.viewAceeptAndOrdrStatusHeight.constant = 22
                    }
                    self.labelDineIn.text = self.orderType
                    self.updateNoData(message: "")
                    if Singleton.sharedInstance.retailerData.category != "hospital"{
                        
                        self.viewStatus.backgroundColor = #colorLiteral(red: 0.9146992564, green: 0.9146992564, blue: 0.9146992564, alpha: 1)
                        self.viewStatus.cornerRadius = 5
                        self.btnOpenDropdown.isUserInteractionEnabled = true
                        self.viewAcceptReject.alpha = 0
                        self.btnOpenDropdown.alpha = 1
                    }else{
                        
                        self.viewStatus.backgroundColor = .clear
                        self.btnOpenDropdown.isUserInteractionEnabled = false
                        self.btnOpenDropdown.alpha = 0
                        if orderInfo?.paymentStatus?.lowercased() == "Pending" || orderInfo?.paymentStatus?.lowercased() == "pending"{
                            //    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                            if self.orderInfo.sub_status == "Payment cancelled"{
                                self.viewAcceptReject.alpha = 0
                            }else{
                                self.viewAcceptReject.alpha = 1
                            }
                            
                            
                        }else{
                            self.viewAcceptReject.alpha = 0
                        }
                    }
                }else{
                    self.hideIndicator()
                    self.updateNoData(message: msg!)
                    self.tblVw.reloadData()
                }
            }
        }else  if isComingFromAppointment == "notification"{
            let vertical : String?
            if ordedrDetail.category == "" {
                vertical = Singleton.sharedInstance.retailerData.category
            }else{
                vertical = ordedrDetail.category
            }
           let productType =  ordedrDetail.product_type ?? ""
            WebServiceManager.sharedInstance.getOrderDetails(orderID: ordedrDetail.orderId!,vertical: vertical!, product_type: productType) { orderInfo, msg, status in
                self.isLodinData = false
                if status == "1"{
                    self.hideIndicator()
                    self.orderInfo = orderInfo
                    self.updateTableHeader()
                    //    self.collStatus.reloadData()
                    //  self.heightCollView.constant = self.collStatus.collectionViewLayout.collectionViewContentSize.height
                    self.tblVw.alpha = 1
                    self.tblVw.reloadData()
                    self.labelSubStatus.text = self.orderInfo.sub_status
                    self.labelPayment.text = self.paymentMode
                    self.labelOrderStatus.text? = self.orderInfo?.paymentStatus?.capitalized ?? ""
                    if orderInfo?.paymentStatus?.lowercased() == "complete" || orderInfo?.paymentStatus?.lowercased() == "completed" {
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "prepared" || orderInfo?.paymentStatus?.lowercased() == "Prepared" {
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "cancelled" || orderInfo?.paymentStatus?.lowercased() == "Cancelled"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Accepted" || orderInfo?.paymentStatus?.lowercased() == "preparing"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Accepted" || orderInfo?.paymentStatus?.lowercased() == "accepted"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Pending" || orderInfo?.paymentStatus?.lowercased() == "pending"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else{
                        
                    }
                    if self.orderInfo.sub_status  == "" && Singleton.sharedInstance.retailerData.category != "hospital" {
                        self.viewAceeptAndOrdrStatusHeight.constant = 0
                    }else {
                        self.viewAceeptAndOrdrStatusHeight.constant = 22
                    }
                    self.labelDineIn.text = self.orderType
                    self.updateNoData(message: "")
                    if Singleton.sharedInstance.retailerData.category != "hospital"{
                        
                        self.viewStatus.backgroundColor = #colorLiteral(red: 0.9146992564, green: 0.9146992564, blue: 0.9146992564, alpha: 1)
                        self.viewStatus.cornerRadius = 5
                        self.btnOpenDropdown.isUserInteractionEnabled = true
                        self.viewAcceptReject.alpha = 0
                        self.btnOpenDropdown.alpha = 1
                    }else{
                        
                        self.viewStatus.backgroundColor = .clear
                        self.btnOpenDropdown.isUserInteractionEnabled = false
                        self.btnOpenDropdown.alpha = 0
                        if orderInfo?.paymentStatus?.lowercased() == "Pending" || orderInfo?.paymentStatus?.lowercased() == "pending"{
                            //    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                            if self.orderInfo.sub_status == "Payment cancelled"{
                                self.viewAcceptReject.alpha = 0
                            }else{
                                self.viewAcceptReject.alpha = 1
                            }
                        }else{
                            self.viewAcceptReject.alpha = 0
                        }
                    }
                }else{
                    self.hideIndicator()
                    self.updateNoData(message: msg!)
                    self.tblVw.reloadData()
                }
                
            }
        }else if isComingFromAppointment == "Self Booking"{
            let vertical : String?
            //            if ordedrDetail.category == "" {
            vertical = Singleton.sharedInstance.retailerData.category
            //            }else{
            //                vertical = ordedrDetail.category
            //            }
            
            let productType =  ordedrDetail.product_type ?? ""
            WebServiceManager.sharedInstance.getOrderDetails(orderID: orderIdAppointmemnt,vertical: vertical!,product_type:productType) { orderInfo, msg, status in
                self.isLodinData = false
                if status == "1"{
                    self.hideIndicator()
                    self.orderInfo = orderInfo
                    self.updateTableHeader()
                    //    self.collStatus.reloadData()
                    //  self.heightCollView.constant = self.collStatus.collectionViewLayout.collectionViewContentSize.height
                    self.tblVw.alpha = 1
                    self.tblVw.reloadData()
                    self.labelSubStatus.text = self.orderInfo.sub_status
                    self.labelPayment.text = self.paymentMode
                    self.labelOrderStatus.text? = self.orderInfo?.paymentStatus?.capitalized ?? ""
                    if orderInfo?.paymentStatus?.lowercased() == "complete" || orderInfo?.paymentStatus?.lowercased() == "completed" {
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "prepared" || orderInfo?.paymentStatus?.lowercased() == "Prepared" {
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "cancelled" || orderInfo?.paymentStatus?.lowercased() == "Cancelled"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Accepted" || orderInfo?.paymentStatus?.lowercased() == "preparing"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Accepted" || orderInfo?.paymentStatus?.lowercased() == "accepted"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Pending" || orderInfo?.paymentStatus?.lowercased() == "pending"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else{
                        
                    }
                    if self.orderInfo.sub_status  == "" && Singleton.sharedInstance.retailerData.category != "hospital" {
                        
                        self.viewAceeptAndOrdrStatusHeight.constant = 0
                    }else {
                        self.viewAceeptAndOrdrStatusHeight.constant = 22
                    }
                    self.labelDineIn.text = self.orderType
                    self.updateNoData(message: "")
                    if Singleton.sharedInstance.retailerData.category != "hospital"{
                        
                        self.viewStatus.backgroundColor = #colorLiteral(red: 0.9146992564, green: 0.9146992564, blue: 0.9146992564, alpha: 1)
                        self.viewStatus.cornerRadius = 5
                        self.btnOpenDropdown.isUserInteractionEnabled = true
                        self.viewAcceptReject.alpha = 0
                        self.btnOpenDropdown.alpha = 1
                    }else{
                        
                        self.viewStatus.backgroundColor = .clear
                        self.btnOpenDropdown.isUserInteractionEnabled = false
                        self.btnOpenDropdown.alpha = 0
                        if orderInfo?.paymentStatus?.lowercased() == "Pending" || orderInfo?.paymentStatus?.lowercased() == "pending"{
                            //    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                            if self.orderInfo.sub_status == "Payment cancelled"{
                                self.viewAcceptReject.alpha = 0
                            }else{
                                self.viewAcceptReject.alpha = 1
                            }
                            
                            
                        }else{
                            self.viewAcceptReject.alpha = 0
                        }
                    }
                }else{
                    self.hideIndicator()
                    self.updateNoData(message: msg!)
                    self.tblVw.reloadData()
                }
            }
        }else{
            let vertical : String?
            if ordedrDetail?.category ?? "" == "" {
                vertical = Singleton.sharedInstance.retailerData?.category
            }else{
                vertical = ordedrDetail?.category
            }
            let productType =  ordedrDetail.product_type ?? ""
            WebServiceManager.sharedInstance.getOrderDetails(orderID: ordedrDetail.orderId!,vertical: vertical!,product_type:productType) { orderInfo, msg, status in
                self.isLodinData = false
                if status == "1"{
                    self.hideIndicator()
                    self.orderInfo = orderInfo
                    self.updateTableHeader()
                    //    self.collStatus.reloadData()
                    //  self.heightCollView.constant = self.collStatus.collectionViewLayout.collectionViewContentSize.height
                    self.tblVw.alpha = 1
                    self.tblVw.reloadData()
                    self.labelSubStatus.text = self.orderInfo.sub_status
                    self.labelPayment.text = self.paymentMode
                    self.labelOrderStatus.text? = self.orderInfo?.paymentStatus?.capitalized ?? ""
                    if orderInfo?.paymentStatus?.lowercased() == "complete" || orderInfo?.paymentStatus?.lowercased() == "completed" {
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "prepared" || orderInfo?.paymentStatus?.lowercased() == "Prepared" {
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "cancelled" || orderInfo?.paymentStatus?.lowercased() == "Cancelled"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Accepted" || orderInfo?.paymentStatus?.lowercased() == "preparing"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Accepted" || orderInfo?.paymentStatus?.lowercased() == "accepted"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else if orderInfo?.paymentStatus?.lowercased() == "Pending" || orderInfo?.paymentStatus?.lowercased() == "pending"{
                        self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else{
                        
                    }
                    if self.orderInfo.sub_status  == "" && Singleton.sharedInstance.retailerData.category != "hospital" {
                        
                        self.viewAceeptAndOrdrStatusHeight.constant = 0
                    }else {
                        self.viewAceeptAndOrdrStatusHeight.constant = 22
                    }
                    self.labelDineIn.text = self.orderType
                    self.updateNoData(message: "")
                    if Singleton.sharedInstance.retailerData.category != "hospital"{
                        
                        self.viewStatus.backgroundColor = #colorLiteral(red: 0.9146992564, green: 0.9146992564, blue: 0.9146992564, alpha: 1)
                        self.viewStatus.cornerRadius = 5
                        self.btnOpenDropdown.isUserInteractionEnabled = true
                        self.viewAcceptReject.alpha = 0
                        self.btnOpenDropdown.alpha = 1
                    }else{
                        
                        self.viewStatus.backgroundColor = .clear
                        self.btnOpenDropdown.isUserInteractionEnabled = false
                        self.btnOpenDropdown.alpha = 0
                        if orderInfo?.paymentStatus?.lowercased() == "Pending" || orderInfo?.paymentStatus?.lowercased() == "pending"{
                            //    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                            if self.orderInfo.sub_status == "Payment cancelled"{
                                self.viewAcceptReject.alpha = 0
                            }else{
                                self.viewAcceptReject.alpha = 1
                            }
                        }else{
                            self.viewAcceptReject.alpha = 0
                        }
                    }
                }else{
                    self.hideIndicator()
                    self.updateNoData(message: msg!)
                    self.tblVw.reloadData()
                    FTIndicator.showToastMessage(msg)
                }
                
            }
        }
    }
}
extension OrderDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard isLodinData == false else{return 1}
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard self.orderInfo != nil else{return nil}
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 10, width: headerView.frame.width-20, height: 30)
        label.font = UIFont(name: "Montserrat-Bold",size: 14.0)!
        label.textColor = UIColor.black // my custom colour
        let seprator = UIView.init(frame: CGRect.init(x: 0, y: headerView.bounds.height, width: tableView.frame.width, height: 1))
        seprator.backgroundColor = .lightGray
        let sepratorFooter = UIView.init(frame: CGRect.init(x: 0, y: headerView.bounds.height-30, width: tableView.frame.width, height: 1))
        sepratorFooter.backgroundColor = .lightGray
    
        guard isLodinData == false else{return UIView()}
        switch sectionTitles[section]{
        case "":
            return UIView()
        case "Customer Name":
            return UIView()
        case "Details":
            if Singleton.sharedInstance.retailerData.category == "hospital"{
                label.text = "Appointment Details"
                label.textColor = #colorLiteral(red: 0.6987196207, green: 0.1431634426, blue: 0.1427366734, alpha: 1)
                headerView.addSubview(seprator)
                headerView.addSubview(label)
            }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                label.text = "Details"
                label.textColor = #colorLiteral(red: 0.6987196207, green: 0.1431634426, blue: 0.1427366734, alpha: 1)
                headerView.addSubview(seprator)
                headerView.addSubview(label)
            }else{
                label.text = "Details"
                label.textColor = #colorLiteral(red: 0.6987196207, green: 0.1431634426, blue: 0.1427366734, alpha: 1)
                headerView.addSubview(label)
            }
            
            return headerView
        case "Payment Details":
            label.text = "Payment Details"
            label.textColor = .black
            headerView.addSubview(sepratorFooter)
            headerView.addSubview(label)
            return headerView
        default :
            return UIView()
        }
    }
    @objc func btnDownloadInvoice(sender:UIButton){
        guard let url = orderInfo.invoiceLink else{return}
        FTIndicator.showToastMessage("Downloding...")
        WebServiceManager.sharedInstance.downloadFile(url: url) { fileURL, progressCompleted, msg, downloaded in
            switch msg{
            case "Error":
                self.dismiss(animated: true, completion: {
                    FTIndicator.showToastMessage("Downloding error from server.")
                })
            case "Success":
                self.dismiss(animated: true, completion:{
                    let activityViewController = UIActivityViewController(activityItems: [fileURL!], applicationActivities: nil)
                    activityViewController.excludedActivityTypes = [.markupAsPDF,.openInIBooks]
                    activityViewController.popoverPresentationController?.sourceView = UIView()
                    UIApplication.shared.keyWindow?.rootViewController!.present(activityViewController, animated: true, completion: nil)
                })
            case "":
                print(progressCompleted)
                //                var newProgress: CGFloat = self.progressVW.progress
                //                newProgress = CGFloat(progressCompleted)
                //                self.progressVW.animateTo(progress: newProgress)
            default:
                break
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard isLodinData == false else{return 0}
        if sectionTitles[section] == "" || sectionTitles[section] == "Customer Name"{
            return 0
        }else{
            return 40
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard isLodinData == false else{return 0}
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isLodinData == false else{return 5}
        guard orderInfo != nil else{return 0}
        guard let products = orderInfo.productList  else{return 0}
        switch sectionTitles[section]{
        case "Customer Name":
            return 1
        case "Details":
            return products.count
        case "Payment Details":
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //           let cell =  OrderDetailTableCell()
        //           guard orderInfo != nil else{return cell}
        //           guard let products = orderInfo.productList  else{return cell}
        switch sectionTitles[indexPath.section]{
        case "Customer Name":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserName") as! OrderDetailTableCell
            cell.selectionStyle = .none
            guard isLodinData == false else{return cell}
            cell.setTemplateWithSubviews(isLodinData)
            if orderInfo != nil{
                // cell.lblOrderType.text = orderInfo.orderType
                cell.lblConsumerName.text = orderInfo.userName.capitalized
                cell.lblMobile.text = "\(orderInfo.userMobile )"
                if orderInfo.Tablenumber == ""{
                    //          cell.lblTableNo.text = ""
                }else{
                    //       cell.lblTableNo.attributedText = getAttrbText(simpleText: orderInfo.Tablenumber, text:  "Table: \(orderInfo.Tablenumber)")
                }
                if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital"{
                    cell.viewDeliveryAddress.alpha = 0
                    cell.viewUnderlineDeliveryAddress.alpha = 0
                    cell.viewUnderlineDeliveryAddress.isHidden = true
                    cell.heightVwDeliveryAddress.constant = 0
                    cell.viewUnderLine.alpha = 0
                    cell.heightVwDeliveryAddress.constant = 0
                    //       cell.lblOrderType.text = orderInfo.paymentStatus?.capitalized
                    if orderInfo.paymentStatus?.lowercased() == "complete" || orderInfo.paymentStatus?.lowercased() == "completed" || orderInfo.paymentStatus?.lowercased() == "accept" || orderInfo.paymentStatus?.lowercased() == "accepted" {
                        //        cell.lblOrderType.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                    }else if orderInfo.paymentStatus?.lowercased() == "pending" {
                        //                        cell.lblOrderType.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                    }else{
                        //           cell.lblOrderType.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
                    }
                }else{
                    if self.orderInfo.orderType == "Delivery"{
                        cell.viewDeliveryAddress.alpha = 1
                        cell.viewUnderlineDeliveryAddress.alpha = 1
                        cell.viewUnderlineDeliveryAddress.isHidden = false
                        cell.heightVwDeliveryAddress.constant = 98
                        cell.viewUnderLine.alpha = 1
                        cell.heightViewUnderLine.constant = 5
                    }else{
                        cell.viewDeliveryAddress.alpha = 0
                        cell.viewUnderlineDeliveryAddress.alpha = 0
                        cell.viewUnderlineDeliveryAddress.isHidden = true
                        cell.heightVwDeliveryAddress.constant = 0
                        cell.viewUnderLine.alpha = 1
                        cell.heightViewUnderLine.constant = 2
                        
                    }
                }
            }else{
                cell.lblConsumerName.text = ordedrDetail.userName?.capitalized ?? ""
                cell.lblMobile.text = "\(ordedrDetail.userMobile ?? "")"
            }
            return cell
        case "Details"://cellApointment
            let product = orderInfo.productList![indexPath.row]
            if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital" && (product.productType == "" || product.productType == "Service" || product.productType == nil){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellApointment", for: indexPath) as! AppointmentCell
            
                cell.lblUserName.text = product.doctorName
                // cell.imgvwService
                cell.lblServiceName.text =  product.ProductName?.capitalized
                cell.lblRoomNo.attributedText = getAttrbText(simpleText: product.roomNumber ?? "", text:"Room Number: \(product.roomNumber ?? "" )")
                cell.lblFees.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product.ProductOfferPrice ?? "")"
                cell.lblDateTime.text = "\(product.appointmentDate ?? "") (\(product.appointmentTime ?? ""))"
                cell.lblDateTime.font = UIFont(name: "Montserrat-Bold", size: 10)
                if orderInfo?.paymentStatus?.lowercased() == "complete" || orderInfo?.paymentStatus?.lowercased() == "completed" {
                    if self.orderInfo?.productList?[0].appointmentDate ?? "" >= currDate {
                        cell.btnReschedule.alpha = 1
                        cell.viewAppointmentButton.alpha = 1
                        cell.imgRescheduleBtn.alpha = 1
                        cell.lblRescheduleBtn.alpha = 1
                        
                        cell.btnCancel.alpha = 1
                        cell.viewCancelButton.alpha = 1
                        cell.imgCancelBtn.alpha = 1
                        cell.lblCancelBtn.alpha = 1
                        cell.btnCancel.addTarget(self, action: #selector(cancelAppointmentAction(sender:)), for: .touchUpInside)
                        cell.btnReschedule.addTarget(self, action: #selector(rescheduleAppointmentAction(sender:)), for: .touchUpInside)
                    }else{
                        cell.btnReschedule.alpha = 0
                        cell.btnCancel.alpha = 0
                        cell.viewAppointmentButton.alpha = 0
                        cell.imgRescheduleBtn.alpha = 0
                        cell.lblRescheduleBtn.alpha = 0
                        cell.viewCancelButton.alpha = 0
                        cell.imgCancelBtn.alpha = 0
                        cell.lblCancelBtn.alpha = 0
                    }
                }else{
                    cell.btnReschedule.alpha = 0
                    cell.btnCancel.alpha = 0
                    cell.viewAppointmentButton.alpha = 0
                    cell.imgRescheduleBtn.alpha = 0
                    cell.lblRescheduleBtn.alpha = 0
                    cell.viewCancelButton.alpha = 0
                    cell.imgCancelBtn.alpha = 0
                    cell.lblCancelBtn.alpha = 0
                }
                
                
                cell.selectionStyle = .none
                return cell
            }else if Singleton.sharedInstance.retailerData.category?.lowercased() == "cab service" && (product.productType == "" || product.productType == "Service" || product.productType == nil){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cabDetailCell", for: indexPath) as! cabDetailCell
                let product = orderInfo.productList![indexPath.row]
                cell.lblCAbName.text = product.ProductName?.capitalized
                cell.lblPRice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product.ProductOfferPrice ?? "")per km"
                cell.lblTime.text = "\(product.slotDate ?? "") (\(product.slotTime ?? ""))"
                cell.lblTime.font = UIFont(name: "Montserrat-Bold", size: 10)
                cell.lblDropLocation.text = product.to_address ?? ""
                cell.lblPickupLocation.text = product.from_address ?? ""
                cell.lblDistance.text = "Distance: \(product.ProductQuantity ?? "")km"
                return cell
            } else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableCell
                let product = orderInfo.productList![indexPath.row]
                cell.lblName.text = product.ProductName?.capitalized
                cell.lblOfferPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product.ProductOfferPrice ?? "")"
                // cell.lblCostPrice.attributedText = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "") \(product.ProductPrice!)".strikeThrough()
                //                cell.lblOfferPrice.text = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "") \(product.ProductOfferPrice!)"
                
                if orderInfo.storeType.lowercased() == "service"{
                    if !product.packageType!.isEmpty{
                        
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.packageType!.capitalized))")
                    }else{
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) ")
                        
                    }
                  /*  if product.productType != nil && product.productType != ""
                    {
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.productType!))")
                    }
                    */
                    
                }else if orderInfo.storeType.lowercased() == "product_service" && product.productType == "Service" {
                    if !product.packageType!.isEmpty{
                        
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.packageType!.capitalized))")
                    }else{
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) ")
                        
                    }
                    /*
                    if product.productType != nil && product.productType != ""
                    {
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.productType!))")
                    }
                    */
                    
                }else {
                    
                   /* if !product.packageType!.isEmpty{
                        
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.packageType!.capitalized))")
                    }else{
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) ")
                        
                    }*/
                    
                    if product.package_status ?? "" == "1"{
                       let calculation =    (product.package_quantity ?? "") + (product.product_unit ?? "")
                        let text  =  "Pack of:  " + calculation
                        cell.lblQuantity.attributedText = getAttrbText(simpleText:calculation, text:  text)
                      
                    }else{
                        cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) ")
                    }
                    
                    
                }
                
                cell.selectionStyle = .none
                return cell
            }
        case "Payment Details":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellBottom") as! OrderDetailTableCell
            
            let currencySymbol = orderInfo?.currencySymbol ?? ""
            //cell.lblStatus.text = orderInfo?.paymentStatus ?? ""
            cell.lblTotal.text = "\(currencySymbol) \(orderInfo.GrandTotal ?? "")"
            cell.lblTotal.text = "\(currencySymbol) \(orderInfo.GrandTotal ?? "")"
            if let tax = orderInfo.taxAmount{
                cell.labelTax.text = "\(currencySymbol) \(tax)"
            }
           
            cell.labelNetTotal.text = "\(currencySymbol) \(orderInfo.totalAmount ?? "")"
            
            var taxStatus = ""
            if let tax = Singleton.sharedInstance.retailerData{
                taxStatus = tax.taxStatus ?? ""
            }
             let taxAmount =  orderInfo?.taxAmount ?? ""
             var isTaxEnable:Bool  = false
             if let taxAmount = Int(taxAmount){
                 if taxAmount == 0{
                     isTaxEnable = false
                 }else{
                     isTaxEnable = true
                 }
               
             }
            if let taxAmount = Float(taxAmount){
                if taxAmount == 0{
                    isTaxEnable = false
                }else{
                    isTaxEnable = true
                }
              
            }
               
            
                
            if Singleton.sharedInstance.retailerData.category == "hospital"{
                if orderInfo?.paymentMethod ?? "" == "" {
                    cell.stackPaymentDetail.subviews[0].isHidden = true
                }else{
                    cell.lblPaymentMethod.text = orderInfo?.paymentMethod ?? ""
                    cell.stackPaymentDetail.subviews[0].isHidden = false
                }
                if orderInfo?.paymentId ?? "" == ""  {
                    cell.stackPaymentDetail.subviews[1].isHidden = true
                }else{
                    cell.lblPaymentID.text = orderInfo?.paymentId ?? ""
                    cell.stackPaymentDetail.subviews[1].isHidden = false
                }
//                cell.stackPaymentDetail.subviews[0].isHidden = false
//                cell.stackPaymentDetail.subviews[1].isHidden = false
                cell.stackPaymentDetail.subviews[2].isHidden = true
                cell.stackPaymentDetail.subviews[3].isHidden = true
                cell.stackPaymentDetail.subviews[4].isHidden = false
                //                cell.stackPaymentDetail.subviews[5].isHidden = false
            }else if taxStatus == "enable" && Singleton.sharedInstance.retailerData?.taxType?.lowercased() != "inclusive"  && isTaxEnable{
                if orderInfo?.paymentMethod ?? "" == "" {
                    cell.stackPaymentDetail.subviews[0].isHidden = true
                }else{
                    cell.lblPaymentMethod.text = orderInfo?.paymentMethod ?? ""
                    cell.stackPaymentDetail.subviews[0].isHidden = false
                }
                if orderInfo?.paymentId ?? "" == ""  {
                    cell.stackPaymentDetail.subviews[1].isHidden = true
                }else{
                    cell.lblPaymentID.text = orderInfo?.paymentId ?? ""
                    cell.stackPaymentDetail.subviews[1].isHidden = false
                }
//                 cell.stackPaymentDetail.subviews[0].isHidden = false
//                 cell.stackPaymentDetail.subviews[1].isHidden = false
                 cell.stackPaymentDetail.subviews[2].isHidden = false
                 cell.stackPaymentDetail.subviews[3].isHidden = false
                 cell.stackPaymentDetail.subviews[4].isHidden = false
                 //                cell.stackPaymentDetail.subviews[5].isHidden = false
             }else {
                 if orderInfo?.paymentMethod ?? "" == "" {
                     cell.stackPaymentDetail.subviews[0].isHidden = true
                 }else{
                     cell.lblPaymentMethod.text = orderInfo?.paymentMethod ?? ""
                     cell.stackPaymentDetail.subviews[0].isHidden = false
                 }
                 if orderInfo?.paymentId ?? "" == ""{
                     cell.stackPaymentDetail.subviews[1].isHidden = true
                 }else{
                     cell.lblPaymentID.text = orderInfo?.paymentId ?? ""
                     cell.stackPaymentDetail.subviews[1].isHidden = false
                 }
//                 cell.stackPaymentDetail.subviews[0].isHidden = false
//                 cell.stackPaymentDetail.subviews[1].isHidden = false
                 cell.stackPaymentDetail.subviews[2].isHidden = true
                 cell.stackPaymentDetail.subviews[3].isHidden = true
                 cell.stackPaymentDetail.subviews[4].isHidden = false
                 //                cell.stackPaymentDetail.subviews[5].isHidden = false
             }
            
            
           /* else if Singleton.sharedInstance.retailerData.category == "restaurant"{
                cell.stackPaymentDetail.subviews[0].isHidden = false
                cell.stackPaymentDetail.subviews[1].isHidden = false
                cell.stackPaymentDetail.subviews[2].isHidden = true
                cell.stackPaymentDetail.subviews[3].isHidden = true
                cell.stackPaymentDetail.subviews[4].isHidden = false
                //                cell.stackPaymentDetail.subviews[5].isHidden = false
            }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                cell.stackPaymentDetail.subviews[0].isHidden = false
                cell.stackPaymentDetail.subviews[1].isHidden = false
                cell.stackPaymentDetail.subviews[2].isHidden = true
                cell.stackPaymentDetail.subviews[3].isHidden = true
                cell.stackPaymentDetail.subviews[4].isHidden = false
            }else{
                cell.stackPaymentDetail.subviews[0].isHidden = false
                cell.stackPaymentDetail.subviews[1].isHidden = false
                cell.stackPaymentDetail.subviews[2].isHidden = true
                cell.stackPaymentDetail.subviews[3].isHidden = true
                cell.stackPaymentDetail.subviews[4].isHidden = false
                //                cell.stackPaymentDetail.subviews[5].isHidden = false
            }*/
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if sectionTitles[indexPath.section] == "Details"{
            let product = orderInfo.productList![indexPath.row]
            if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital" && (product.productType == "" || product.productType == "Service" || product.productType == nil){
                (cell as! AppointmentCell).imgvwService.kf.cancelDownloadTask()
            }else if Singleton.sharedInstance.retailerData.category?.lowercased() == "cab service" && (product.productType == "" || product.productType == "Service" || product.productType == nil){
                (cell as! cabDetailCell).imgIcon.kf.cancelDownloadTask()
            } else{
                (cell as! ProductTableCell).imgVwProduct.kf.cancelDownloadTask()
            }
        }
    }
    @objc func rescheduleAppointmentAction(sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmAppointmentVC") as! ConfirmAppointmentVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    @objc func cancelAppointmentAction(sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelBookingVC") as! CancelBookingVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLodinData == false else{
            cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
            return}
        
        if sectionTitles[indexPath.section] == "Details" {
            let product = orderInfo.productList![indexPath.row]
            if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital" && (product.productType == "" || product.productType == "Service" || product.productType == nil){
                if product.Product_Medium_Image == ""{
                    (cell as! AppointmentCell).imgvwService.image = #imageLiteral(resourceName: "imagePlaceholder")
                }else{
                    let url:URL = URL(string: product.Product_Medium_Image!)!
                    _ = (cell as! AppointmentCell).imgvwService.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
                }
            }else if Singleton.sharedInstance.retailerData.category?.lowercased() == "cab service" && (product.productType == "" || product.productType == "Service" || product.productType == nil){
                if product.Product_Medium_Image == ""{
                    (cell as! cabDetailCell).imgIcon.image = #imageLiteral(resourceName: "imagePlaceholder")
                }else{
                    let url:URL = URL(string: product.Product_Medium_Image!)!
                    _ = (cell as! cabDetailCell).imgIcon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
                }

            }else{
                if product.Product_Medium_Image == ""{
                    (cell as! ProductTableCell).imgVwProduct.image = #imageLiteral(resourceName: "imagePlaceholder")
                }else{
                    let url:URL = URL(string: product.Product_Medium_Image!)!
                    _ = (cell as! ProductTableCell).imgVwProduct.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
                }
            }
        }
    }
    
    //       func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
    //       return UITableView.automaticDimension
    //       }
}
extension OrderDetailController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard orderStatus != nil else{return 0}
        return orderStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StatusCellCollVw
        guard orderInfo != nil else{return cell}
        let status = orderStatus[indexPath.item]
        cell.lblStatus.layer.cornerRadius = 5
        if status.name.lowercased() == orderInfo.paymentStatus!.lowercased() || status.name.lowercased().contains("complete") && selectedStatuIndexath == nil{
            selectedStatuIndexath = indexPath
            cell.lblStatus.backgroundColor = hexStringToUIColor(hex: status.color ?? "#ffffff")
            cell.lblStatus.textColor = .white
            cell.lblStatus.layer.borderWidth = 0
        }else{
            cell.lblStatus.backgroundColor = .white
            cell.lblStatus.textColor = hexStringToUIColor(hex: status.color ?? "#ffffff")
            cell.lblStatus.layer.borderColor = hexStringToUIColor(hex: status.color ?? "#ffffff").cgColor
            cell.lblStatus.layer.borderWidth = 0.7
        }
        cell.lblStatus.text = status.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let status = orderStatus[indexPath.item]
        selectedStatuIndexath = nil
        updateOrderStatus(paymentMethod: orderInfo.paymentStatus ?? "", userID: orderInfo.userId , status: status.value!, oderID: orderInfo.orderId ?? "")
    }
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        if let cell =  cell as? StatusCellCollVw{
    //            //  let status = orderStatus[indexPath.item]
    //            // cell.lblStatus.layer.borderWidth = 0.7
    //            //  cell.lblStatus.layer.cornerRadius = 5
    //        }
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        guard orderStatus != nil else{return .zero}
        let castString = orderStatus[indexPath.row].name as NSString
        let size: CGSize = castString.size(withAttributes: [NSAttributedString.Key.font : UIFont.init(name: "Montserrat-SemiBold", size: 13)!])
        return CGSize.init(width: size.width+10, height:30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard orderStatus != nil else{return .zero}
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    }
}

class StatusCellCollVw:UICollectionViewCell{
    @IBOutlet weak var lblStatus: UILabel!
}
class OrderDetailTableCell:UITableViewCell,ShimmeringViewProtocol{
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblPaymentID: UILabel!
    //    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTableNo: UILabel!
    @IBOutlet weak var lblConsumerName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblOrderType: UILabel!
    @IBOutlet weak var stackPaymentDetail: UIStackView!
    @IBOutlet weak var labelNetTotal: UILabel!
    @IBOutlet weak var labelTax: UILabel!
    @IBOutlet weak var viewDeliveryAddress: UIView!
    @IBOutlet weak var viewUnderlineDeliveryAddress: UIView!
    @IBOutlet weak var heightVwDeliveryAddress: NSLayoutConstraint!
    @IBOutlet weak var viewUnderLine: UIView!
    @IBOutlet weak var heightViewUnderLine: NSLayoutConstraint!
    
    var shimmeringAnimatedItems: [UIView]{
        [
            lblConsumerName,
            lblMobile,
            lblOrderType,
            lblTableNo
        ].compactMap({$0})
    }
    
}
class AppointmentCell:UITableViewCell,ShimmeringViewProtocol{
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgvwService: UIImageView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblRoomNo: UILabel!
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnReschedule: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewAppointmentButton: UIView!{
        didSet{
            viewAppointmentButton.layer.cornerRadius = 8
            viewAppointmentButton.borderWidth = 1
            viewAppointmentButton.borderColor = UIColor(red: 222/255, green: 169/255, blue: 86/255, alpha: 1.0)
            viewAppointmentButton.backgroundColor = .white
        }
    }
    @IBOutlet weak var imgRescheduleBtn: UIImageView!
    @IBOutlet weak var lblRescheduleBtn: UILabel!{
        didSet{
            lblRescheduleBtn.font = UIFont(name: "Montserrat-Medium", size: 14)
            lblRescheduleBtn.textColor = UIColor(red: 222/255, green: 169/255, blue: 86/255, alpha: 1.0)
        }
    }
    
    @IBOutlet weak var viewCancelButton: UIView!{
        didSet{
            viewCancelButton.cornerRadius = 8
            viewCancelButton.borderWidth = 1
            viewCancelButton.borderColor = UIColor(named: "themeRed")
            viewCancelButton.backgroundColor = .white
        }
    }
    @IBOutlet weak var imgCancelBtn: UIImageView!
    @IBOutlet weak var lblCancelBtn: UILabel!{
        didSet{
            lblCancelBtn.font = UIFont(name: "Montserrat-Medium", size: 14)
            lblCancelBtn.textColor = UIColor(named: "themeRed")
        }
    }
    var shimmeringAnimatedItems: [UIView]{
        [
            
        ].compactMap({$0})
    }
    
}
class cabDetailCell: UITableViewCell{
    @IBOutlet var lblDistance : UILabel!
    @IBOutlet var lblPickupLocation : UILabel!
    @IBOutlet var lblDropLocation : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblPRice : UILabel!
    @IBOutlet var lblCAbName : UILabel!
    @IBOutlet var imgIcon : UIImageView!
}
