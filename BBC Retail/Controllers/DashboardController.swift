//
//  DashboardController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 19/04/22.
//

import UIKit
import FTIndicator
import UIView_Shimmer

class DashboardController: UIViewController {
//MARK: - IBOUTLET
    @IBOutlet weak var lblDefaultStore: UILabel!
    @IBOutlet weak var btnStorelist: UIButton!
    @IBOutlet weak var stackStoreName: UIStackView!
    @IBOutlet weak var tblVw: UITableView!
    //MARK: - VARIABLES
    var dashboardData : DashboardData!
    var isLodinData = true
    //MARK: - IBACTIONS
    @IBAction func btnOpenStoreList(_ sender: UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreListController") as! StoreListController
//        vc.fromSelectStore = true
//        vc.updateDashboardData = {
//            self.getDashboardDataAPI()
//            self.lblDefaultStore.text = Singleton.sharedInstance.retailerData.StoreName
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    @IBAction func btnQRCodeAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRVWController") as! QRVWController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnAddProductAction(_ sender: UIButton) {
        let vc = UIStoryboard().returnProductUI().instantiateViewController(withIdentifier: "AddProductController") as! AddProductController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        getDashboardDataAPI()
        self.tblVw.sectionHeaderHeight =  UITableView.automaticDimension
            self.tblVw.estimatedSectionHeaderHeight = 40
        self.tblVw.register(UINib.init(nibName: "DashboardTableHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        lblDefaultStore.text = Singleton.sharedInstance.retailerData.StoreName
        
        switch Singleton.sharedInstance.retailerData.access?.lowercased() {
            case "manager","retailer","owner":
            btnStorelist.alpha = 0
            stackStoreName.alpha = 1
          default:
            btnStorelist.alpha = 0
            stackStoreName.alpha = 0
        }
        
        self.storeCurrency()
    }
    
    
    // MARK: - Dashboard Data API
    func getDashboardDataAPI(){
        WebServiceManager.sharedInstance.retailerDashboardReport { dashboardData, msg, status in
            self.isLodinData = false
            if status == "1"{
            self.dashboardData = dashboardData
            self.tblVw.reloadData()
            }else{
            FTIndicator.showToastMessage(msg!)
            }
        }
    }
    
    func getSymbolForCurrencyCode(code: String) -> String?{
         let locale = NSLocale(localeIdentifier: code)
         return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
     }
    
    func storeCurrency(){
        let currency = Singleton.sharedInstance.retailerData?.StoreName ?? ""
        let s = currency.split(separator: " ")
                    print(s)
        let s1 = s.last ?? ""
        let currSym = self.getSymbolForCurrencyCode(code: String(s1))
        print("currSymbol =======>>>>>",currSym)
        Singleton.sharedInstance.retailerData?.selectedStoreCurrency = currSym
    }
    
}
// MARK: - UITableViewDataSource,UITableViewDelegate
extension DashboardController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard isLodinData == false else{return 2}
        switch Singleton.sharedInstance.retailerData?.access?.lowercased() {
            case "manager","retailer","owner":
            return 3
          default:
            return 1
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard dashboardData != nil else{return 1}
           return 1
        case 1:
            guard dashboardData != nil else{return 4}
            return dashboardData.settlementReport!.payments!.count
        case 2:
            guard dashboardData != nil else{return 0}
            return dashboardData.salesReportData!.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = DashboardTableCell()
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DashboardTableCell
            guard isLodinData == false else{return cell}
            cell.setTemplateWithSubviews(isLodinData)
            let report = dashboardData.reportData
            cell.lblTotalOrder.text = report?.totalOrder
            cell.lblTotalSale.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "")\(report?.totalSales ?? "")"
//            cell.lblInStock.text = report?.inventoryInStock
//            cell.lblOutOfStock.text = report?.inventoryOutStock
//            cell.lblFootfall.text = report?.footfall
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "settelmentReport") as! DashboardTableCell
            guard isLodinData == false else{return cell}
            cell.setTemplateWithSubviews(isLodinData)
            let payment = dashboardData.settlementReport!.payments![indexPath.row]
            cell.lblProducts.text = payment.productName
            cell.lblTime.text = payment.time
            cell.lblAmount.text = "\(payment.amount ?? "")"
            cell.lblAccount.text = payment.to
            switch payment.paymentMethod?.lowercased(){
            case "online" :
                cell.imgVwPaymentIcon.image = UIImage(named: "credit-card")
            case "cash" :
                cell.imgVwPaymentIcon.image = UIImage(named: "money")
            case "paytm" :
                cell.imgVwPaymentIcon.image = UIImage(named: "paytm")
            case "phonepe" :
                cell.imgVwPaymentIcon.image = UIImage(named: "phonPe")
            case "Gpay" :
                cell.imgVwPaymentIcon.image = UIImage(named: "gPAY")
            default: break
            }
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "salesReport") as! DashboardTableCell
            guard isLodinData == false else{return cell}
            cell.setTemplateWithSubviews(isLodinData)
            let salesReport = dashboardData.salesReportData![indexPath.row]
            cell.lblOrderID.text =  "Order ID \(salesReport.orderid ?? "")"
            cell.lblDatetime.text = salesReport.time
            cell.lblMethodAmount.text = "\(salesReport.paymentMethod ?? "")  \(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "")\(salesReport.amount ?? "")"
            cell.lblStatus.text = salesReport.status?.capitalized
            if salesReport.status?.lowercased() == "complete"{
            cell.lblStatus.textColor = hexStringToUIColor(hex: Color.greenApproved.rawValue)
            }else if salesReport.status?.lowercased() == "pending" {
            cell.lblStatus.textColor = hexStringToUIColor(hex: Color.pending.rawValue)
            }else{
            cell.lblStatus.textColor = hexStringToUIColor(hex: Color.red_error.rawValue)
           }
           
      
        default: return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLodinData == false else{
        cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
            return}
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TableHeader
        headerView.backgroundView?.backgroundColor = .white
       // guard isLodinData == false else{return UIView()}
        headerView.btnOpenReportDetail.tag = section
        switch section{
        case 0:
            headerView.lblTitle.text = "Today"
            for (indx , vw) in headerView.stackMain.subviews.enumerated() {
                if indx == 0{
                    vw.subviews[0].isHidden = false
                }else{
                    vw.isHidden = true
                }
            }
            headerView.imgVWArrow.alpha = 0
            headerView.vwSeprator.alpha = 0
            headerView.btnOpenReportDetail.alpha = 0
            let newSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            headerView.frame.size.height = newSize.height
            headerView.frame.size.width = UIScreen.main.bounds.width
            guard isLodinData == false else{  headerView.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                return  headerView
            }
            headerView.setTemplateWithSubviews(isLodinData)
            return headerView
        case 1:
            headerView.lblTitle.text = "Settlement Report"
            for (indx , vw) in headerView.stackMain.subviews.enumerated() {
                if indx == 0{
                    vw.subviews[0].isHidden = false
                }else{
                    vw.isHidden = true
                }
            }
            headerView.imgVWArrow.alpha = 0
            headerView.vwSeprator.alpha = 0
            headerView.btnOpenReportDetail.alpha = 0
            let newSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            headerView.frame.size.height = newSize.height
            headerView.frame.size.width = UIScreen.main.bounds.width
            guard isLodinData == false else{  headerView.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                return  headerView
            }
            headerView.setTemplateWithSubviews(isLodinData)
            //************************
            let settelmentReport = dashboardData.settlementReport
            for (indx , vw) in headerView.stackMain.subviews.enumerated() {
                if indx == 0{
                    vw.subviews[0].isHidden = true
                }else{
                    vw.isHidden = false
                }
                    if indx == headerView.stackMain.subviews.count-1{
                        if settelmentReport!.payments!.count > 0{
                        vw.isHidden = true
                        headerView.vwSeprator.alpha = 0
                          //  headerView.btnOpenReportDetail.alpha = 0
                    }else{
                        vw.isHidden = false
                        headerView.lblNoData.text = "No settlement found for today"
                        headerView.vwSeprator.alpha = 1
                    }
                 }
            }
            headerView.imgVWArrow.alpha = 1
            headerView.lblTotalPayments.text = settelmentReport?.todayNoPayment
            headerView.lblTotalAmount.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "")\(settelmentReport?.todayAmount ?? "")"
            headerView.btnOpenReportDetail.alpha = 1
          //  headerView.bringSubviewToFront(headerView.btnOpenReportDetail)
            headerView.btnOpenReportDetail.addTarget(self, action: #selector(openReportDetail(sender:)), for: .touchUpInside)
           
            return headerView
        case 2:
//            if Singleton.sharedInstance.notifData.vertical ?? "" == Retailer {
//                headerView.lblTitle.text = "Sales Report"
//            }else{
//                headerView.lblTitle.text = "Appointment Report"
//            }
            headerView.lblTitle.text = "Sales Report"
            let salesReport = dashboardData.salesReportData
            for (indx , vw) in headerView.stackMain.subviews.enumerated() {
                if indx == 0{
                    vw.subviews[0].isHidden = true
                }else{
                    vw.isHidden = true
                }
                
                    if indx == headerView.stackMain.subviews.count-1{
                        if salesReport!.count > 0{
                        vw.isHidden = false
                        headerView.vwSeprator.alpha = 1
                        headerView.btnOpenReportDetail.alpha = 1
                    }else{
                        vw.isHidden = false
                        headerView.vwSeprator.alpha = 1
                        headerView.lblNoData.text = "No data found"
                        headerView.btnOpenReportDetail.alpha = 1
                     }
                   }
                 }
            headerView.imgVWArrow.alpha = 1
            headerView.btnOpenReportDetail.addTarget(self, action: #selector(openReportDetail(sender:)), for: .touchUpInside)
            guard isLodinData == false else{  headerView.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                return  headerView
            }
            headerView.setTemplateWithSubviews(isLodinData)
            return headerView
        default :
        return UIView()
        }
       
    }
    @objc func openReportDetail(sender:UIButton){
      print("ZClicked")
       if sender.tag == 1{
//           let main = UIViewController(nibName: "WebviewController", bundle: nil)
//           self.navigationController?.pushViewController(main, animated: true)
           if Singleton.sharedInstance.retailerData?.selectedStoreCurrency == "€"{
               let vc = UIStoryboard.init(name: "PaymentUI", bundle: nil).instantiateViewController(withIdentifier: "PaymentSettlementPopUpViewController") as! PaymentSettlementPopUpViewController
               vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
           }else{
              
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettelmentController") as! SettelmentController
                self.navigationController?.pushViewController(vc, animated: true)
           }
           
         
        
           
           
       }else if sender.tag == 2{
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportDetailVC") as! ReportDetailVC
           self.navigationController?.pushViewController(vc, animated: true)
       }
    }

   
}
// MARK: - UITableViewCELL
class DashboardTableCell:UITableViewCell,ShimmeringViewProtocol{
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var lblTotalOrder: UILabel!
    @IBOutlet weak var lblTotalSale: UILabel!
    @IBOutlet weak var lblInStock: UILabel!
    @IBOutlet weak var lblOutOfStock: UILabel!
    @IBOutlet weak var lblFootfall: UILabel!
    
    @IBOutlet weak var lblProducts: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var imgVwPaymentIcon: UIImageView!
    
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblDatetime: UILabel!
    @IBOutlet weak var lblMethodAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            vw1,vw2,vw3,vw4,lblTotalOrder,
            lblTotalSale,
            lblInStock,
            lblOutOfStock,
            lblFootfall,
            lblProducts,
            lblTime,
            lblAmount,
            lblAccount,
            imgVwPaymentIcon,
            lblOrderID,
            lblDatetime,
            lblMethodAmount,
            lblStatus
           
        ].compactMap({$0})
       }
    
     }
class TableHeader:UITableViewHeaderFooterView,ShimmeringViewProtocol{
    @IBOutlet weak var stackTitle: UIStackView!
    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var lblTotalPayments: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var vwSeprator: UIView!
    @IBOutlet weak var imgVWArrow: UIImageView!
    @IBOutlet weak var btnOpenReportDetail: UIButton!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            stackTitle,
            lblTitle,
            lblToday,
            lblTotalPayments,
            lblTotalAmount,
            lblNoData,
            vwSeprator,
            imgVWArrow,
            btnOpenReportDetail
           
        ].compactMap({$0})
       }
}
