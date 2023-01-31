//
//  SettelmentController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 01/07/22.
//

        import UIKit
        import FTIndicator
        import UIView_Shimmer
      
        class SettelmentController: UIViewController {
            //MARK: - IBOUTLET
            @IBOutlet weak var btnSidemenu: UIButton!
            @IBOutlet weak var searchBar: UISearchBar!
            @IBOutlet weak var tblVw: UITableView!
            //MARK: - VARIABLES
            private var isLodinData = true
            private var searchActive = false
            var payments = [Payments]()
                //MARK: - IBACTIONS
            @IBAction func btnSideMenuAction(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
              
            }
                //MARK: - VIEW LIFE CYCLE
            override func viewDidLoad() {
                super.viewDidLoad()
               // addToolbarToSearchKeyboard()
                getSettelmentReportAPI()
                self.tblVw.estimatedRowHeight = 61
                self.tblVw.rowHeight = UITableView.automaticDimension
               
               // updateUI()

            }
            //MARK: - UPDATE UI
            func updateUI(){
                self.tblVw.tableFooterView = UIView()
                if #available(iOS 13.0, *) {
                    searchBar[keyPath: \.searchTextField].font = UIFont.init(name: "Montserrat-Medium",size: 14)!
                } else {
                    let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
                        let placeholderLabel       = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
                        placeholderLabel?.font     = UIFont.init(name: "Montserrat-Medium", size: 14)!
                }
            }
            //MARK: ************UPDATE NO DATA FOUND
            func updateNoData(message:String){
                if self.payments.count > 0 {
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
            
            //MARK: - GET PRODUCT LIST API
            func getSettelmentReportAPI(){
                WebServiceManager.sharedInstance.settelmentDashboardReport { settelmentReport,msg, status in
                        self.isLodinData = false
                     //   self.refreshControl?.endRefreshing()
                        self.tblVw.tableFooterView = nil
                        if status == "1"{
                            self.payments = (settelmentReport?.payments!)!
                            self.updateNoData(message: "")
                            self.tblVw.reloadData()
                         }else{
                           //  self.lbltotalCount.text = ""
                             self.payments = [Payments]()
                            self.updateNoData(message: msg!)
                             self.tblVw.reloadData()
                        }
                    }
            }
            @objc func settleMentButtonPressed(sender:UIButton){
                let vc = UIStoryboard.init(name: "PaymentUI", bundle: nil).instantiateViewController(withIdentifier: "PaymentSettlementPopUpViewController") as! PaymentSettlementPopUpViewController
                self.present(vc, animated: true)
            }
            
            
           }
        extension SettelmentController:UITableViewDelegate,UITableViewDataSource{
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                guard isLodinData == false else{return 5}
               
                return payments.count
                
                }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettelmentTableCell
                cell.selectionStyle = .none
                guard isLodinData == false else{return cell}
                cell.setTemplateWithSubviews(isLodinData)
                guard payments.count > 0 else{ return cell}
                
                let payment = payments[indexPath.row]
                cell.lblDate.text = payment.date
                cell.lblDescr.text = "Settled to Account of \(payment.to?.capitalized ?? "")"
                cell.lblAmmount.text =  "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "")\(payment.amount ?? "")"
                return cell
            }
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              
            }
            func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettlementPaymentFooterTableViewCell") as? SettlementPaymentFooterTableViewCell else { return UITableViewCell.init() }
                cell.headerButton.addTarget(self, action: #selector(settleMentButtonPressed(sender: )), for: .touchUpInside)
                cell.headerButton.isHidden = true
                return cell
            }
            func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
                return 60.0
            }
            func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                guard isLodinData == false else{
                cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                    return}
                
            }
            
        }
//        extension StoreListController:UISearchBarDelegate{
//            func addToolbarToSearchKeyboard()
//            {
//                let numberPadToolbar: UIToolbar = UIToolbar()
//                numberPadToolbar.isTranslucent = true
//                numberPadToolbar.items=[
//                    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
//                    UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.cancelAction)),
//                ]
//                numberPadToolbar.sizeToFit()
//                searchBar.inputAccessoryView = numberPadToolbar
//            }
//
//            @objc func cancelAction()
//            {
//                searchBar.resignFirstResponder()
//            }
            //MARK: *****************Filter  Data
    //        func filterArrayData(text:String){
    //            filteredProducts = productList.filter( {
    //            $0.ProductName!.range(of: text, options: .caseInsensitive) != nil
    //            })
    //           }
    //        func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
    //            searchActive = true
    //            searchBar.setShowsCancelButton(true, animated: true)
    //            if searchText.count > 0{
    //                    filterArrayData(text: searchText)
    //                    tblVw.reloadData()
    //
    //            }
    //
    //        }
    //        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //            searchActive = false
    //            tblVw.reloadData()
    //            filteredProducts.removeAll()
    //            searchBar.text = ""
    //            searchBar.setShowsCancelButton(false, animated: true)
    //            searchBar.resignFirstResponder()
    //
    //        }
     //   }
        class SettelmentTableCell:UITableViewCell,ShimmeringViewProtocol{
            
            @IBOutlet weak var lblDate: UILabel!
            @IBOutlet weak var lblDescr: UILabel!
            @IBOutlet weak var lblAmmount : UILabel!
            @IBOutlet weak var vwAccountTo : UIView!
            
            var shimmeringAnimatedItems: [UIView] {
                [
                    lblDate,
                    lblDescr,
                    lblAmmount,
                    vwAccountTo
                   
                ].compactMap({$0})
               }
            
        }
