//
//  ReportDetailVC.swift
//  BBC Retail
//
//  Created by Himanshu on 13/10/22.
//

import UIKit
import FTIndicator
import UIView_Shimmer

class ReportDetailVC: UIViewController {
    //MARK: - IBOUTLET
    @IBOutlet weak var tableViewReport: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewButton: UIView!
    //MARK: - VARIABLES
    var arrSales : SalesReport?
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewReport.delegate = self
        tableViewReport.dataSource = self
        getSalesReportAPI()
    }
    //MARK: - IBACTIONS
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonExport(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExportSalesVC") as! ExportSalesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - GET SALES REPORT LIST API
    func getSalesReportAPI(){
        WebServiceManager.sharedInstance.retailerSalesReport { salesReport,msg, status in
            if status == "1"{
                self.arrSales = salesReport
                if self.arrSales?.payments?.count ?? 0 == 0{
                    self.tableViewReport.setEmptyMessage1("No report found")
                    self.viewButton.alpha = 0
                }else{
                    self.viewButton.alpha = 1
                }
                self.tableViewReport.reloadData()
            }else{
                self.arrSales = salesReport
                if self.arrSales?.payments?.count ?? 0 == 0{
                    self.tableViewReport.setEmptyMessage1("No report found")
                    self.viewButton.alpha = 0
                }else{
                    self.viewButton.alpha = 1
                }
                self.tableViewReport.reloadData()
            }
        }
    }
}
// MARK: - UITableViewCell Class
class ReportDetailCell: UITableViewCell,ShimmeringViewProtocol{
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    var shimmeringAnimatedItems: [UIView] {
        [
            lblOrderId,
            lblAmount,
            lblDate,
            lblPaymentMode
            
        ].compactMap({$0})
    }
}
// MARK: - UITableViewDataSource,UITableViewDelegate
extension ReportDetailVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSales?.payments?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ReportDetailCell", for: indexPath)as! ReportDetailCell
        cell.lblOrderId.text = "Order ID: \(arrSales?.payments?[indexPath.row].orderId ?? "")"
        cell.lblAmount.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "")\(arrSales?.payments?[indexPath.row].price ?? "")"
        cell.lblPaymentMode.text = arrSales?.payments?[indexPath.row].paymentType ?? ""
        cell.lblDate.text = arrSales?.payments?[indexPath.row].date ?? ""
        return cell
    }
}
