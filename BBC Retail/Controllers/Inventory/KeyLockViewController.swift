//
//  KeyLockViewController.swift
//  BBC Retail
//
//  Created by Newforce MAC on 28/11/22.
//

import UIKit
import UIView_Shimmer
import IBAnimatable

class keyLockTableviewCell:UITableViewCell,ShimmeringViewProtocol{
   
//  MARK: - OUTLETS
    
    @IBOutlet weak var labelUnitOfMeasurement: UILabel!
    @IBOutlet weak var labelOfferPrice: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var labelDates: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelStandardPrice: UILabel!
    @IBOutlet weak var labelCostPrice: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelSerialNo: UILabel!
    
  
   
    
    @IBOutlet weak var mainView: UIView! {
        didSet{
            self.mainView.layer.cornerRadius = 15
            self.mainView.layer.borderWidth = 0
            self.mainView.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var viewOfferPrice: UIView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var viewDates: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewCostPrice: UIView!
    @IBOutlet weak var viewStandardPrice: UIView!
    @IBOutlet weak var viewQty: UIView!
    @IBOutlet weak var viewSerialNo: UIView!
    @IBOutlet weak var viewMeasurement: UIView!
    var shimmeringAnimatedItems: [UIView] {
          [
          viewOfferPrice,
          viewComment,
          viewDates,
          viewStatus,
          viewCostPrice,
          viewStandardPrice,
          viewQty,
          viewSerialNo,
          viewMeasurement
          ].compactMap{ $0}
      }
    
}

class KeyLockViewController: UIViewController {
    
//  MARK: - OUTLETS
    @IBOutlet weak var tableviewKeyLock: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    
    //    MARK: - VARIABLES
    var inventoryList :[Inventorylist]?
    var productList = [Productlist]()
    var course_id = ""
    var offerPrice = ""
    var StandardPrice = ""
    var costPrice = ""
    var mainCat = ""
    var subCat = ""
    var productName = ""

    
    var productDetail : ProductDetail?
    
    private var isLoading = true {
         didSet {
             tableviewKeyLock.isUserInteractionEnabled = !isLoading
             tableviewKeyLock.reloadData()
         }
     }

//    MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableviewKeyLock.delegate = self
        self.tableviewKeyLock.dataSource = self
        self.labelTitle.text = self.productName
        isLoading = true
        self.getInventoryList(course_Id: self.course_id)
    }
//    MARK: - FUNCTION CALLING API FOR LIST
    func getInventoryList(course_Id:String){
        WebServiceManager.sharedInstance.getProductInventtoryList(course_id: course_Id){ inventoryList, msg, status in
            self.isLoading = false
                if status == "1"{
                  self.inventoryList = inventoryList!
                    self.updateNoData(message: "")
                    self.tableviewKeyLock.reloadData()
                 }else{
                     self.inventoryList = [Inventorylist]()
                    self.updateNoData(message: msg!)
                     self.tableviewKeyLock.reloadData()
                }
            }
    }

    //MARK: ************UPDATE NO DATA FOUND
    func updateNoData(message:String){
        if self.inventoryList?.count > 0 {
            self.tableviewKeyLock.backgroundView = UIView()
        }else{
            let vwNoData = ViewNoData()
            self.tableviewKeyLock.backgroundView = vwNoData
            vwNoData.imgVw.image = UIImage(named: "noDataFound")
            vwNoData.center.x = self.view.center.x
            vwNoData.center.y =  self.view.center.y
            vwNoData.label.text = message
        }
    }
    
//    MARK: - BUTTON ACTIONS
    @IBAction func createButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard().returnProductUI().instantiateViewController(withIdentifier: "InventoryViewController") as! InventoryViewController
        vc.offerPrice = self.offerPrice
        vc.StandardPrice = self.StandardPrice
        vc.costPrice = self.costPrice
        vc.courseId = self.course_id
        vc.mainCat = self.mainCat
        vc.subCat = self.subCat
        vc.productName = self.productName
        vc.productDetail = self.productDetail
        self.navigationController?.pushViewController(vc, animated: true)
   
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
//    MARK: - TIME CONVERTER
    func createDateTime(timestamp: String) -> String {
        var strDate = "undefined"
            
        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMM d, yyy HH:mm a" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }
            
        return strDate
    }
    
}

//  MARK:- TABLEVIEW EXTENSION
extension KeyLockViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading == false{
            return self.inventoryList?.count ?? 0
        }else{
            
            return 5
        }
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewKeyLock.dequeueReusableCell(withIdentifier: "keyLockTableviewCell", for: indexPath) as! keyLockTableviewCell
        if self.isLoading == false{
        cell.mainView.layer.cornerRadius = 15
        cell.mainView.layer.borderWidth = 1
        cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
        cell.labelSerialNo.text = "\(indexPath.row + 1)"
        cell.labelQty.text = self.inventoryList?[indexPath.row].quantity ?? ""
        cell.labelStandardPrice.text = self.inventoryList?[indexPath.row].price ?? ""
        cell.labelCostPrice.text = self.inventoryList?[indexPath.row].cost_price ?? ""
        cell.labelOfferPrice.text = self.inventoryList?[indexPath.row].standard_price ?? ""
        cell.labelStatus.text = self.inventoryList?[indexPath.row].status ?? ""
        cell.labelDates.text = self.createDateTime(timestamp: self.inventoryList?[indexPath.row].create_time ?? "")
        cell.labelComment.text = self.inventoryList?[indexPath.row].status_comment ?? ""
            
            
            cell.labelUnitOfMeasurement.text = self.inventoryList?[indexPath.row].unit ?? ""
            
            
            
    }else{
        cell.mainView.layer.cornerRadius = 15
        cell.mainView.layer.borderWidth = 0
        cell.mainView.layer.borderColor = UIColor.white.cgColor
    }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
  func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
      cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .lightGray)
    }
    
}
