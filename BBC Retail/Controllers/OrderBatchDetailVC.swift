//
//  OrderBatchDetailVC.swift
//  BBC Retail
//  Created by Himanshu on 19/10/22.
//

import UIKit
import FTIndicator
import Kingfisher
import UIView_Shimmer

class OrderBatchDetailVC: UIViewController, GetStatus ,cancelBooking ,confirmReschedule{
    func cancelConfirm() {
        let indexPath1 = IndexPath(row: 0, section: 0)
        let cell = tblVw.cellForRow(at: indexPath1) as! AppointmentCell
        
        updateSlotStatus(store_id: self.orderBatchInfo?.storeId ?? "", room_id: self.orderBatchInfo?.productList?[indexPath1.row].roomId ?? "", previous_date: "\(self.orderBatchInfo?.productList?[indexPath1.row].appointmentDate ?? "") (\(orderBatchInfo?.productList?[indexPath1.row].appointmentTime ?? ""))", user_id: self.orderBatchInfo?.userId ?? "", slot_id: self.orderBatchInfo?.productList?[indexPath1.row].slotId ?? "", service_id: self.orderBatchInfo?.productList?[indexPath1.row].ProductId ?? "", vertical: Singleton.sharedInstance.retailerData.category ?? "", doctor_name: self.orderBatchInfo?.productList?[indexPath1.row].doctorName ?? "", order_id: self.orderBatchInfo?.orderId ?? "", payment_method: self.orderBatchInfo?.storePaymentType ?? "", status: "cancel")
    }
    
    func appointmentResponse() {
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        let cell = tblVw.cellForRow(at: indexPath1) as! AppointmentCell
//        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
//        guard let indexPath = self.tblVw.indexPathForRow(at:buttonPosition) else{return}
        let serviceInfo = orderBatchInfo?.orderData?[indexPath1.section].orderInfo?.productList![indexPath1.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentController") as! AppointmentController
        vc.serviceInfo = serviceInfo
        vc.isComingFrom = "Batch"
        vc.orderBatchInfo = orderBatchInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeStatus() {
        getOrderDetailByOrderBatchID()
    }
    
    //MARK: - IBOUTLET
    @IBOutlet weak var tblVw: UITableView!{
        didSet{
            tblVw.alpha = 0
        }
    }
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var labelOrderStatus: UILabel!
    @IBOutlet weak var btnOpenDropdown: UIButton!
    @IBOutlet weak var labelDineIn: UILabel!
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var btnDownloadInvoiceHeight: NSLayoutConstraint!
    @IBOutlet weak var lblBatchPaymentMethod: UILabel!
    @IBOutlet weak var lblBatchPaymentID: UILabel!
    //    @IBOutlet weak var lblBatchStatus: UILabel!
    @IBOutlet weak var lblBatchTotal: UILabel!
    @IBOutlet weak var lblBatchConsumerName: UILabel!
    @IBOutlet weak var lblBatchMobile: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var labelSubStatus: UILabel!
    @IBOutlet weak var lblDeliveryMobile: UILabel!
    @IBOutlet weak var lblAddressDelivery: UILabel!
    @IBOutlet weak var lbldeliveryAddName: UILabel!
    @IBOutlet weak var viewDeliveryAddress: UIView!{
        didSet{
            viewDeliveryAddress.alpha = 0
        }
    }
    @IBOutlet weak var imgArrowDownloadInvoice: UIImageView!
    @IBOutlet weak var lblNetTotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var stackViewPaymentDetails: UIStackView!
    @IBOutlet weak var viewDeliverAddressHeight: NSLayoutConstraint!{
        didSet{
            viewDeliverAddressHeight.constant = 0
        }
    }
    @IBOutlet weak var viewAcceptReject: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var viewAceeptAndOrdrStatusHeight: NSLayoutConstraint!
    
    let sectionTitles = ["Customer Name","Details","Payment Details"]
    private var isLodinData = true
    var ordedrDetail : OrderList!
    var orderInfo : OrderInfo!
    var orderBatchInfo : OrderBatchInfo?
    var storeInfo : StoreInfo!
    var orderType = ""
    var orderBatchId = ""
    var count = 0
    var updateOrderList:(() -> Void)!
    var paymentStatus = ""
    var paymentMode = ""
    var subStatus = ""
    var product_type = ""
    
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderDetailByOrderBatchID()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    //MARK: ******* UPDATE TABLE HEADER
    func updateTableHeader(){
        guard orderBatchInfo != nil else{return}
        lblOrderID.text = orderBatchInfo?.orderId ?? ""
        lblTotal.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(orderBatchInfo?.totalAmount ?? "")"
        lblDate.text = orderBatchInfo?.orderdate ?? ""
        if orderBatchInfo?.paymentStatus?.lowercased() == "completed" || orderBatchInfo?.paymentStatus?.lowercased() == "complete"{
            btnDownload.alpha = 1
            btnDownloadInvoiceHeight.constant = 20
            imgArrowDownloadInvoice.alpha = 1
            //            btnDownload.addTarget(self, action: #selector(btnDownloadInvoice(sender:)), for: .touchUpInside)
        }else{
            btnDownload.alpha = 0
            btnDownloadInvoiceHeight.constant = 0
            imgArrowDownloadInvoice.alpha = 0
        }
        if orderBatchInfo != nil{
            // cell.lblOrderType.text = orderInfo.orderType
            lblBatchConsumerName.text = orderBatchInfo?.userName?.capitalized
            lblBatchMobile.text = "\(orderBatchInfo?.userMobile  ?? "")"
            

        }else{
            lblBatchConsumerName.text = ordedrDetail.userName?.capitalized ?? ""
            lblBatchMobile.text = "\(orderBatchInfo?.userMobile ?? "")"
        }
        
//        self.lblBatchPaymentMethod.text = orderBatchInfo?.paymentMethod ?? ""
        //        self.lblBatchStatus.text = orderBatchInfo?.paymentStatus ?? ""
     
        
        self.lblBatchTotal.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(orderBatchInfo?.totalAmount ?? "")"
        self.lblTax.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(0)"
        self.lblNetTotal.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(0)"
        self.labelSubStatus.text = self.orderBatchInfo?.subStatus ?? ""
        self.labelPayment.text = orderBatchInfo?.paymentMethod ?? ""
        
    }
    @IBAction func buttonRejectAction(_ sender: UIButton) {
        orderStatusChange(store_id: self.orderBatchInfo?.storeId ?? "", slot_start_time: self.orderBatchInfo?.productList?[0].appointmentTime ?? "", slot_date: self.orderBatchInfo?.productList?[0].appointmentDate ?? "", sub_status: self.orderBatchInfo?.subStatus ?? "", service_name:  self.orderBatchInfo?.productList?[0].ProductName ?? "", retailer_id: Singleton.sharedInstance.retailerData.RetailerId ?? "" , user_id: self.orderBatchInfo?.userId ?? "", service_id: self.orderBatchInfo?.productList?[0].ProductId ?? "", doctor_name: self.orderBatchInfo?.productList?[0].doctorName ?? "", order_id: self.orderBatchInfo?.orderId ?? "", payment_method: self.orderBatchInfo?.storePaymentType ?? "", status: "cancelled")
        
    }
    @IBAction func buttonAcceptAction(_ sender: UIButton) {
        orderStatusChange(store_id: self.orderBatchInfo?.storeId ?? "", slot_start_time: self.orderBatchInfo?.productList?[0].appointmentTime ?? "", slot_date: self.orderBatchInfo?.productList?[0].appointmentDate ?? "", sub_status: self.orderBatchInfo?.subStatus ?? "", service_name:  self.orderBatchInfo?.productList?[0].ProductName ?? "", retailer_id: Singleton.sharedInstance.retailerData.RetailerId ?? "" , user_id: self.orderBatchInfo?.userId ?? "", service_id: self.orderBatchInfo?.productList?[0].ProductId ?? "", doctor_name: self.orderBatchInfo?.productList?[0].doctorName ?? "", order_id: self.orderBatchInfo?.orderId ?? "", payment_method: self.orderBatchInfo?.storePaymentType ?? "", status: "Accepted")
    }
    @IBAction func btnOpenStatusDropdown(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateStatusVC") as! UpdateStatusVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.paymentMethod = orderBatchInfo?.paymentStatus ?? ""
        vc.userID = orderBatchInfo?.userId ?? ""
        vc.oderID = orderBatchInfo?.orderId ?? ""
        vc.comingStatus = self.labelOrderStatus.text ?? ""
        vc.statusDelegate = self
        vc.isFromStaus = "Yes"
        self.present(vc, animated: false,completion: nil)
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonDownloadInvoice(_ sender: UIButton) {
        guard let url = orderBatchInfo?.invoiceLink else{return}
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
    
    //MARK: UPDATE SLOT STATUS
    func updateSlotStatus(store_id:String, room_id:String, previous_date:String,user_id:String,slot_id:String, service_id:String, vertical:String, doctor_name:String, order_id:String, payment_method:String, status:String){
        WebServiceManager.sharedInstance.updateSlotStatus(store_id: store_id, room_id: room_id, status: status, slot_id: slot_id, service_id: service_id, user_id: user_id, order_id: order_id, doctor_name: doctor_name, previous_date: previous_date, payment_method: payment_method) { msg, status in
            if status == "1"{
                self.getOrderDetailByOrderBatchID()
                FTIndicator.showToastMessage("Appointment cancelled")
            }else {
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
    //MARK: ************GET ORDER DETAIL
    func getOrderDetailByOrderBatchID(){
        let vertical : String?
        if ordedrDetail.category == "" {
            vertical = Singleton.sharedInstance.retailerData.category
        }else{
            vertical = ordedrDetail.category
        }
        WebServiceManager.sharedInstance.getCustomerOrderByBatchId(orderID: ordedrDetail.orderId!, vertical: vertical!, order_batch_id: orderBatchId, payment_method: paymentStatus,product_type:"") { [self] orderBatchInfo, msg, status in
            self.isLodinData = false
            if status == "1"{
                self.orderBatchInfo = orderBatchInfo
                guard orderBatchInfo != nil else{
                    self.btnDownload.alpha = 0
                    self.btnDownloadInvoiceHeight.constant = 0
                    self.imgArrowDownloadInvoice.alpha = 0
                    //  self.tblVw.tableHeaderView!.frame.size.height = 0
                    return}
                if let status = orderBatchInfo?.paymentStatus?.lowercased(), status == "completed" || status == "complete"{
                    self.btnDownload.alpha = 1
                    self.btnDownloadInvoiceHeight.constant = 20
                    self.imgArrowDownloadInvoice.alpha = 1
                }else{
                    self.btnDownload.alpha = 0
                    self.btnDownloadInvoiceHeight.constant = 0
                    self.imgArrowDownloadInvoice.alpha = 0
                }
                guard let headerView = self.tblVw.tableHeaderView else {return}
                let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                if headerView.frame.size.height != size.height {
                    headerView.frame.size.height = size.height
                    self.tblVw.tableHeaderView = headerView
                    self.tblVw.layoutIfNeeded()
                }
                
                self.labelDineIn.text = self.orderType
                if orderBatchInfo?.paymentStatus?.lowercased() == "complete" || orderBatchInfo?.paymentStatus?.lowercased() == "completed" {
                    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
                }else if orderBatchInfo?.paymentStatus?.lowercased() == "prepared" || orderBatchInfo?.paymentStatus?.lowercased() == "Prepared" {
                    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                }else if orderBatchInfo?.paymentStatus?.lowercased() == "cancelled" || orderBatchInfo?.paymentStatus?.lowercased() == "Cancelled"{
                    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
                }else if orderBatchInfo?.paymentStatus?.lowercased() == "Accepted" || orderBatchInfo?.paymentStatus?.lowercased() == "preparing"{
                    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                }else if orderBatchInfo?.paymentStatus?.lowercased() == "Pending" || orderBatchInfo?.paymentStatus?.lowercased() == "pending"{
                    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                }else{
                    
                }
                if self.orderBatchInfo?.subStatus ?? ""  == "" && Singleton.sharedInstance.retailerData.category != "hospital" {
                    self.viewAceeptAndOrdrStatusHeight.constant = 0
                }else {
                    self.viewAceeptAndOrdrStatusHeight.constant = 22
                }
                
                if Singleton.sharedInstance.retailerData.category != "hospital"{
                    self.viewAcceptReject.alpha = 0
                    self.viewStatus.backgroundColor = #colorLiteral(red: 0.9146992564, green: 0.9146992564, blue: 0.9146992564, alpha: 1)
                    self.viewStatus.cornerRadius = 5
                    self.btnOpenDropdown.isUserInteractionEnabled = true
                    self.btnOpenDropdown.alpha = 1
//                    if self.orderType == "Delivery"{
//                        self.viewDeliverAddressHeight.constant = 0
//                        self.viewDeliveryAddress.alpha = 1
//                    }else{
//                        self.viewDeliverAddressHeight.constant = 0
//                        self.viewDeliveryAddress.alpha = 0
//                    }
                    
                    //MARK: Footer View Stack
         
                    
    
                }else{
                    self.viewStatus.backgroundColor = .clear
                    self.btnOpenDropdown.isUserInteractionEnabled = false
                    self.btnOpenDropdown.alpha = 0
                   
                    //MARK: Header Delivery View
                    self.viewDeliverAddressHeight.constant = 0
                    self.viewDeliveryAddress.alpha = 0
                    if self.orderBatchInfo?.paymentStatus?.lowercased() == "Pending" || self.orderBatchInfo?.paymentStatus?.lowercased() == "pending"{
                        //    self.labelOrderStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
                        self.viewAcceptReject.alpha = 1
                    }else{
                        self.viewAcceptReject.alpha = 0
                    }
                }
                
                if self.orderBatchInfo?.paymentMethod ?? "" == ""{
                    self.stackViewPaymentDetails.subviews[0].isHidden = true
                }else{
                    self.lblBatchPaymentMethod.text = self.orderBatchInfo?.paymentMethod ?? ""
                    self.stackViewPaymentDetails.subviews[0].isHidden = false
                }
                if orderBatchInfo?.paymentId ?? "" == ""{
                    self.stackViewPaymentDetails.subviews[1].isHidden = true
                }else{
                    self.lblBatchPaymentID.text = orderBatchInfo?.paymentId ?? ""
                    self.stackViewPaymentDetails.subviews[1].isHidden = false
                }
//                    self.stackViewPaymentDetails.subviews[0].isHidden = false
//                    self.stackViewPaymentDetails.subviews[1].isHidden = false
                self.stackViewPaymentDetails.subviews[2].isHidden = true
                self.stackViewPaymentDetails.subviews[3].isHidden = true
                self.stackViewPaymentDetails.subviews[4].isHidden = false
                
             
               
                self.labelOrderStatus.text = self.orderBatchInfo?.paymentStatus ?? ""
                self.lblNetTotal.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(self.orderBatchInfo?.totalAmount ?? "")"
                self.updateTableHeader()
                tblVw.alpha = 1
                self.tblVw.reloadData()
            }else{
                
            }
        }
    }
}

extension OrderBatchDetailVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard isLodinData == false else{return 1}
        return orderBatchInfo?.orderData?.count ?? 0
    }
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        guard self.orderInfo != nil else{return nil}
    //        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
    //        headerView.backgroundColor = .white
    //        let label = UILabel()
    //        label.frame = CGRect.init(x: 10, y: 10, width: headerView.frame.width-20, height: 30)
    //        label.font = UIFont(name: "Montserrat-Bold",size: 14.0)!
    //        label.textColor = UIColor.black // my custom colour
    //        let seprator = UIView.init(frame: CGRect.init(x: 5, y: headerView.bounds.height, width: tableView.frame.width-10, height: 1))
    //        seprator.backgroundColor = .lightGray
    //        headerView.addSubview(seprator)
    //        headerView.addSubview(label)
    //        guard isLodinData == false else{return UIView()}
    //        switch sectionTitles[section]{
    //        case "":
    //            return UIView()
    //        case "Customer Name":
    //            return UIView()
    //        case "Details":
    //            label.text = "Details"
    //            return headerView
    //        case "Payment Details":
    //            label.text = "Payment Details"
    //            return headerView
    //        default :
    //            return UIView()
    //        }
    //    }
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        guard isLodinData == false else{return 0}
    //        if sectionTitles[section] == "" || sectionTitles[section] == "Customer Name"{
    //            return 0
    //        }else{
    //            return 40
    //        }
    //    }
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        guard isLodinData == false else{return 0}
    //        return 0
    //    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isLodinData == false else{return 5}
        
        return orderBatchInfo?.orderData?[section].orderInfo?.productList?.count ?? 0
        //        switch sectionTitles[section]{
        //        case "Details":
        //            return products.count
        //        default:
        //            return 0
        //        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //           let cell =  OrderDetailTableCell()
        //           guard orderInfo != nil else{return cell}
        //           guard let products = orderInfo.productList  else{return cell}
        
        let product = orderBatchInfo?.orderData?[indexPath.section].orderInfo?.productList?[indexPath.row]
        if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital" && (product?.productType == "" || product?.productType == "Service" || product?.productType == nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellApointment", for: indexPath) as! AppointmentCell
         
            cell.lblUserName.text = product?.doctorName
            // cell.imgvwService
            cell.lblServiceName.text =  product?.ProductName?.capitalized
            cell.lblRoomNo.attributedText = getAttrbText(simpleText: product?.roomNumber ?? "", text:"Room Number: \(product?.roomNumber ?? "")")
            cell.lblFees.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product?.ProductOfferPrice ?? "")"
            cell.lblDateTime.text = "\(product?.appointmentDate ?? "") (\(product?.appointmentTime ?? ""))"
            cell.btnReschedule.alpha = 0
            cell.btnCancel.alpha = 0
            if product?.Product_Medium_Image == ""{
                cell.imgvwService.image = #imageLiteral(resourceName: "imagePlaceholder")
            }else{
                let url = URL(string: product?.Product_Medium_Image ?? "")
                cell.imgvwService.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
            }
            cell.btnCancel.addTarget(self, action: #selector(cancelAppointmentAction(sender:)), for: .touchUpInside)
            cell.btnReschedule.addTarget(self, action: #selector(rescheduleAppointmentAction(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableCell
            let product = orderBatchInfo?.orderData?[indexPath.section].orderInfo?.productList?[indexPath.row]
            cell.lblName.text = product?.ProductName?.capitalized
            
            cell.lblQuantity.attributedText = getAttrbText(simpleText: product?.ProductQuantity ?? "", text:  "Qty: \(product?.ProductQuantity ?? "")")
            // cell.lblCostPrice.attributedText = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "") \(product.ProductPrice!)".strikeThrough()
            cell.lblOfferPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(product?.ProductOfferPrice ?? "")"
            // cell.lblOfferPrice.text = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "") \(product?.ProductOfferPrice!) (\(product?.packageType!.capitalized))"
            cell.selectionStyle = .none
            
            if let product = orderBatchInfo?.orderData?[indexPath.section].orderInfo?.productList?[indexPath.row]{
                if let orderInfo = orderBatchInfo?.orderData?[indexPath.section].orderInfo{
                    
                    if orderInfo.storeType?.lowercased() == "service"{
                        if !product.packageType!.isEmpty{
                            
                            cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.packageType!.capitalized))")
                        }else{
                            cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) ")
                            
                        }
                        if product.productType != nil && product.productType != ""
                        {
                            cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.productType!))")
                        }
                        
                    }else if orderInfo.storeType?.lowercased() == "Product_service" && product.productType == "Service" {
                        if !product.packageType!.isEmpty{
                            
                            cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.packageType!.capitalized))")
                        }else{
                            cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) ")
                            
                        }
                        
                        if product.productType != nil && product.productType != ""
                        {
                            cell.lblQuantity.attributedText = getAttrbText(simpleText: product.ProductQuantity!, text:  "Qty: \(product.ProductQuantity!) (\(product.productType!))")
                        }
                        
                    }
                }
                
            }
            if product?.Product_Medium_Image == ""{
                cell.imgVwProduct.image = #imageLiteral(resourceName: "imagePlaceholder")
            }else{
                let url = URL(string: product?.Product_Medium_Image ?? "")
                cell.imgVwProduct.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
            }
            return cell
        }
        return UITableViewCell()
    }
    //    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if sectionTitles[indexPath.section] == "Details"{
    //            if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital"{
    //                (cell as! AppointmentCell).imgvwService.kf.cancelDownloadTask()
    //            }else{
    //                (cell as! ProductTableCell).imgVwProduct.kf.cancelDownloadTask()
    //            }
    //        }
    //    }
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
    //       func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
    //       return UITableView.automaticDimension
    //       }
}



