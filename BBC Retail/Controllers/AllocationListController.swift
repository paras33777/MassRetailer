//
//  AllocationListController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 27/07/22.
//
    import UIKit
    import FTIndicator
    import UIView_Shimmer
import Kingfisher
    class AllocationListController: UIViewController {
        //MARK: - IBOUTLET
        @IBOutlet weak var lblTitle: UILabel!
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var tblVw: UITableView!
      //  @IBOutlet weak var lbltotalCount: UILabel!
      //  @IBOutlet weak var lblFilterCount: UILabel!
       // @IBOutlet weak var vwBgSearchBar: UIView!
        
        //MARK: - VARIABLES
        private var isLodinData = true
        private var searchActive = false
        var trcList = [TRCList]()
        var filteredTRC = [TRCList]()
        let refreshControl = UIRefreshControl()
//        var refreshControl: UIRefreshControl!
        var totalCount = Int()
        var totalPage = Int()
        var page = 1
        var pageLoading = false
        var commonFilter = [CommonFilter]()
        
        //MARK: - IBACTIONS
        @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
        }
        
        @IBAction func btnAddAllocation(_ sender: UIButton){
            if Singleton.sharedInstance.retailerData.category == "cab service"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaxiVC") as! AddTaxiVC
                vc.updateCabList = {
                    self.getCabAllocationListAPI(page: 1)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomController") as! AddRoomController
                vc.updateProductList = {
                    self.gettrcAllocationListAPI(page: 1)
                }

                self.navigationController?.pushViewController(vc, animated: true)
            }
         
        
        }
//        @IBAction func btnOpenFilter(_ sender: UIButton) {
//         let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonFilterController") as! CommonFilterController
//            vc.storeID = Singleton.sharedInstance.retailerData.storeId ?? ""
//            vc.type = "ProductList"
//            vc.filters = commonFilter
//            vc.applyFilter = { filter in
//                self.commonFilter = filter
//                let jsonEncoder = JSONEncoder()
//                do {
//                    let jsonData = try jsonEncoder.encode(self.commonFilter)
//                    let jsonString = String(data: jsonData, encoding: .utf8)
//                  //  self.getProductListAPI(page: 1, commonFilter: jsonString!)
//                    print("JSON String : " + jsonString!)
//                }
//                catch {
//                }
//                var count = 0
//                for item in self.commonFilter {
//                    if item.returnValue != ""{
//                        count += 1
//                     }
//                 }
//                if count > 0{
//                    self.lblFilterCount.alpha = 1
//                    self.lblFilterCount.text = String(count)
//                }else{
//                    self.lblFilterCount.alpha = 0
//                }
//            }
//            self.navigationController!.present(vc, animated: true)
//        }
            //MARK: - VIEW LIFE CYCLE
        override func viewDidLoad() {
            super.viewDidLoad()
            print("Category ------> ",Singleton.sharedInstance.retailerData.category ?? "")
          }
        
        override func viewWillAppear(_ animated: Bool) {
            if Singleton.sharedInstance.retailerData.category == "cab service"{
                showIndicator()
                addToolbarToSearchKeyboard()
                getCabAllocationListAPI(page: 1)
//                gettrcAllocationListAPI(page: 1)
                updateUI()
                refreshControl.attributedTitle = NSAttributedString(string: "")
               refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
                      tblVw.addSubview(refreshControl)
            }else{
                showIndicator()
                addToolbarToSearchKeyboard()
                gettrcAllocationListAPI(page: 1)
                updateUI()
                refreshControl.attributedTitle = NSAttributedString(string: "")
               refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
                      tblVw.addSubview(refreshControl)
            }
            
        }
        @objc func refresh(_ sender: AnyObject) {
            if Singleton.sharedInstance.retailerData.category == "cab service"{
                refreshControl.beginRefreshing()
            page = 1
                getCabAllocationListAPI(page: page)
//            gettrcAllocationListAPI(page: 1)
                refreshControl.endRefreshing()
            }else{
                refreshControl.beginRefreshing()
            page = 1
            gettrcAllocationListAPI(page: 1)
                refreshControl.endRefreshing()
            }
            
                
            }
        //MARK: - UPDATE UI
        func updateUI(){
          //  refreshDataControl()
           // lblFilterCount.layer.borderColor = hexStringToUIColor(hex: Color.red.rawValue).cgColor
           // lblFilterCount.layer.borderWidth = 1
          //  lblFilterCount.alpha = 0
            self.tblVw.tableFooterView = UIView()
            if #available(iOS 13.0, *) {
                
                searchBar[keyPath: \.searchTextField].font = UIFont.init(name: "Montserrat-Medium",size: 14)!
            }else {
               // vwBgSearchBar.backgroundColor = hexStringToUIColor(hex:Color.searchBarBG.rawValue)
                
                let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
                let placeholderLabel    = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
                placeholderLabel?.font  = UIFont.init(name: "Montserrat-Medium", size: 14)!
              }
            }

        //MARK: ************UPDATE NO DATA FOUND
        func updateNoData(message:String){
            if self.trcList.count > 0 {
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
        //MARK: - GET CAB ALLOCATION LIST API
        func getCabAllocationListAPI(page:Int){
            WebServiceManager.sharedInstance.getCabAllocationList(page: String(page)) { trcList, totalPage, totalCount, msg, status in
                self.isLodinData = false
                if page == 1{
                    self.page = 1
                }
               // self.refreshControl?.endRefreshing()
                self.tblVw.tableFooterView = nil
                if status == "1"{
                   // self.refreshControl?.endRefreshing()
                    self.hideIndicator()
                    self.totalCount = totalCount!
                    self.totalPage = totalPage!
                   // self.lbltotalCount.text = "Results Found \(String(self.totalCount))"
                    if self.pageLoading == true && page > 1{
                        self.pageLoading = false
                        self.trcList += trcList!
                    }else{
                        self.trcList = trcList!
                    }
                    self.updateNoData(message: "")
                    self.tblVw.reloadData()
                 }else{
                     self.hideIndicator()
                    // self.refreshControl?.endRefreshing()
                   //  self.lbltotalCount.text = ""
                     self.trcList = [TRCList]()
                    self.updateNoData(message: msg!)
                     self.tblVw.reloadData()
                }
            }
        }
        //MARK: - GET TRC ALLOCATION LIST API
        func gettrcAllocationListAPI(page:Int){
            WebServiceManager.sharedInstance.getTRCAllocationList(page: String(page)) { trcList, totalPage, totalCount, msg, status in
                self.isLodinData = false
                if page == 1{
                    self.page = 1
                }
               // self.refreshControl?.endRefreshing()
                self.tblVw.tableFooterView = nil
                if status == "1"{
                   // self.refreshControl?.endRefreshing()
                    self.hideIndicator()
                    self.totalCount = totalCount!
                    self.totalPage = totalPage!
                   // self.lbltotalCount.text = "Results Found \(String(self.totalCount))"
                    if self.pageLoading == true && page > 1{
                        self.pageLoading = false
                        self.trcList += trcList!
                    }else{
                        self.trcList = trcList!
                    }
                    self.updateNoData(message: "")
                    self.tblVw.reloadData()
                 }else{
                     self.hideIndicator()
                    // self.refreshControl?.endRefreshing()
                   //  self.lbltotalCount.text = ""
                     self.trcList = [TRCList]()
                    self.updateNoData(message: msg!)
                     self.tblVw.reloadData()
                }
            }
        }
        
        //MARK: ***********Refresh Data
//        func refreshDataControl(){
//            tblVw.alwaysBounceVertical = true
//            tblVw.bounces  = true
//            refreshControl = UIRefreshControl()
//            refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
//            self.tblVw.addSubview(refreshControl)
//        }
        //MARK: ***********Refresh Data
//        @objc func reloadData(){
//
//            refreshControl.endRefreshing()
//        }
        
       }

    extension AllocationListController:UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard isLodinData == false else{return 5}
            if searchActive{
                return filteredTRC.count
            }else{
            return trcList.count
            }
            }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if Singleton.sharedInstance.retailerData.category ?? "" == "restaurant"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "allocationREstaurentCell", for: indexPath) as! allocationREstaurentCell
                guard isLodinData == false else{return cell}
                cell.setTemplateWithSubviews(isLodinData)
                var list : [TRCList]!
                if searchActive{
                    guard filteredTRC.count > 0 else{ return cell}
                    list = filteredTRC
                }else{
                    guard trcList.count > 0 else{ return cell}
                    list = trcList
                }
                cell.selectionStyle = .none
                let allocation = list[indexPath.row]
                cell.lblTableNumber.attributedText =  getAttrbText(simpleText: allocation.number!, text:  "Table Number: \(allocation.number!)")
                cell.lblFloor.attributedText =  getAttrbText(simpleText: allocation.floor!, text:  "Floor: \(allocation.floor!)")
                cell.lbLocation.attributedText =  getAttrbText(simpleText: allocation.location!.capitalized, text:  "Location: \(allocation.location!.capitalized)")
                cell.lblWaiter.attributedText =  getAttrbText(simpleText: allocation.workerName!.capitalized, text:  "Worker: \(allocation.workerName!.capitalized)")
                cell.lblActive.text = allocation.trcStatus ?? ""
                if allocation.trcStatus ?? "" == "Active" {
                    cell.lblActive.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                }else{
                    cell.lblActive.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                }
                let url = URL(string: allocation.barcode ?? "")
                cell.imgScanner.kf.setImage(with: url)
                cell.btnEditActionHandler = {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomController") as! AddRoomController
                    vc.trcData = allocation
                    vc.isFromEditTable = "edit"
                    vc.updateProductList = {
                        self.gettrcAllocationListAPI(page: 1)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.btnAssignHandler = {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomController") as! AddRoomController
                    vc.trcData = allocation
                    vc.isFromEditTable = "assign"
                    vc.updateProductList = {
                        self.gettrcAllocationListAPI(page: 1)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                self.loadMore(indexPath: indexPath)
                return cell
            }else if Singleton.sharedInstance.retailerData.category == "hospital"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllocationTableCell
                
                guard isLodinData == false else{return cell}
                cell.setTemplateWithSubviews(isLodinData)
                var list : [TRCList]!
                if searchActive{
                    guard filteredTRC.count > 0 else{ return cell}
                    list = filteredTRC
                }else{
                    guard trcList.count > 0 else{ return cell}
                    list = trcList
                }
                cell.selectionStyle = .none
                let allocation = list[indexPath.row]
                cell.lblRoomNo.attributedText =  getAttrbText(simpleText: allocation.number!, text:  "Room Number: \(allocation.number!)")
                cell.lblFloor.attributedText =  getAttrbText(simpleText: allocation.floor!, text:  "Floor: \(allocation.floor!)")
                cell.lblLocation.attributedText =  getAttrbText(simpleText: allocation.location!.capitalized, text:  "Location: \(allocation.location!.capitalized)")
                if allocation.allocationType == "Nurse"{
                    cell.lblDoctor.attributedText =  getAttrbText(simpleText: allocation.workerName!.capitalized, text:  "Nurse: \(allocation.workerName!.capitalized)")
                }else{
                    cell.lblDoctor.attributedText =  getAttrbText(simpleText: allocation.workerName!.capitalized, text:  "Doctor: \(allocation.workerName!.capitalized)")
                }
//                cell.lblDoctor.attributedText =  getAttrbText(simpleText: allocation.workerName!.capitalized, text:  "Doctor: \(allocation.workerName!.capitalized)")
                cell.lblActiveStatus.text = allocation.trcStatus ?? ""
                if allocation.trcStatus ?? "" == "Active" {
                    cell.lblActiveStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                }else{
                    cell.lblActiveStatus.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                }
                cell.lblService.attributedText =  getAttrbText(simpleText: allocation.productName!.capitalized, text:  "Service: \(allocation.productName!.capitalized)")
                cell.btnEdit.addTarget(self, action: #selector(editAction(sender:)), for: .touchUpInside)
                cell.btnAssign.addTarget(self, action: #selector(asignAction(sender:)), for: .touchUpInside)
               self.loadMore(indexPath: indexPath)
                return cell
            }else if Singleton.sharedInstance.retailerData.category == "cab service" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllocationTableCell
                
                guard isLodinData == false else{return cell}
                cell.setTemplateWithSubviews(isLodinData)
                var list : [TRCList]!
                if searchActive{
                    guard filteredTRC.count > 0 else{ return cell}
                    list = filteredTRC
                }else{
                    guard trcList.count > 0 else{ return cell}
                    list = trcList
                }
                cell.selectionStyle = .none
                let allocation = list[indexPath.row]
                cell.lblRoomNo.text = allocation.productName ?? ""
              
                cell.lblFloor.text = ""
                cell.lblFloor.isHidden = true
                cell.lblLocation.text = ""
                cell.lblLocation.isHidden = true
                    cell.lblDoctor.attributedText =  getAttrbText(simpleText: allocation.workerName!.capitalized, text:  "Driver: \(allocation.workerName!.capitalized)")
               
//                cell.lblDoctor.attributedText =  getAttrbText(simpleText: allocation.workerName!.capitalized, text:  "Doctor: \(allocation.workerName!.capitalized)")
                cell.lblActiveStatus.text = allocation.trcStatus ?? ""
                if allocation.trcStatus ?? "" == "Active" {
                    cell.lblActiveStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                }else{
                    cell.lblActiveStatus.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                }
                cell.lblService.text = ""
                cell.lblService.isHidden = true
                cell.btnEdit.addTarget(self, action: #selector(editAction(sender:)), for: .touchUpInside)
                cell.btnAssign.addTarget(self, action: #selector(asignAction(sender:)), for: .touchUpInside)
               self.loadMore(indexPath: indexPath)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllocationTableCell
                guard isLodinData == false else{return cell}
                cell.setTemplateWithSubviews(isLodinData)
                var list : [TRCList]!
                if searchActive{
                    guard filteredTRC.count > 0 else{ return cell}
                    list = filteredTRC
                }else{
                    guard trcList.count > 0 else{ return cell}
                    list = trcList
                }
                cell.selectionStyle = .none
                let allocation = list[indexPath.row]
                cell.lblRoomNo.attributedText =  getAttrbText(simpleText: allocation.number!, text:  "Rack Number: \(allocation.number!)")
                cell.lblFloor.attributedText =  getAttrbText(simpleText: allocation.floor!, text:  "Floor: \(allocation.floor!)")
                cell.lblLocation.attributedText =  getAttrbText(simpleText: allocation.location!.capitalized, text:  "Location: \(allocation.location!.capitalized)")
                cell.lblDoctor.isHidden = true
                cell.lblActiveStatus.text = allocation.trcStatus ?? ""
                if allocation.trcStatus ?? "" == "Active" {
                    cell.lblActiveStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                }else{
                    cell.lblActiveStatus.textColor = #colorLiteral(red: 0.6988685727, green: 0.152430594, blue: 0.1421948671, alpha: 1)
                }
                cell.lblService.attributedText =  getAttrbText(simpleText: allocation.productName!.capitalized, text:  "Category: \(allocation.mainCategoryName ?? "".capitalized)")
                cell.btnEdit.addTarget(self, action: #selector(editAction(sender:)), for: .touchUpInside)
                cell.btnAssign.addTarget(self, action: #selector(asignAction(sender:)), for: .touchUpInside)
               self.loadMore(indexPath: indexPath)
                return cell
            }
            
        }
       
        @objc func editAction(sender:UIButton){
            if Singleton.sharedInstance.retailerData.category == "hospital"{
                let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
                guard let indexPath = self.tblVw.indexPathForRow(at:buttonPosition) else{return}
                var list : [TRCList]!
                if searchActive{
                    guard filteredTRC.count > 0 else{ return}
                    list = filteredTRC
                }else{
                    guard trcList.count > 0 else{ return}
                    list = trcList
                }
                let trcData = list[indexPath.row]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomController") as! AddRoomController
                vc.trcData = trcData
                vc.updateProductList = {
                    self.gettrcAllocationListAPI(page: 1)
                }
                vc.isFromHospitalEdit = "edit"
                self.navigationController?.pushViewController(vc, animated: true)
            }else  if Singleton.sharedInstance.retailerData.category == "cab service"{
                let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
                guard let indexPath = self.tblVw.indexPathForRow(at:buttonPosition) else{return}
                var list : [TRCList]!
                if searchActive{
                    guard filteredTRC.count > 0 else{ return}
                    list = filteredTRC
                }else{
                    guard trcList.count > 0 else{ return}
                    list = trcList
                }
                let trcData = list[indexPath.row]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAssignCabVC") as! EditAssignCabVC
                vc.trcData = trcData
                vc.isFromEditCab = "edit"
                vc.updateProductList = {
                    self.getCabAllocationListAPI(page: 1)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
                guard let indexPath = self.tblVw.indexPathForRow(at:buttonPosition) else{return}
                var list : [TRCList]!
                if searchActive{
                    guard filteredTRC.count > 0 else{ return}
                    list = filteredTRC
                }else{
                    guard trcList.count > 0 else{ return}
                    list = trcList
                }
                let trcData = list[indexPath.row]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomController") as! AddRoomController
                vc.trcData = trcData
                vc.isFromEditRack = "edit"
                vc.updateProductList = {
                    self.gettrcAllocationListAPI(page: 1)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }
        @objc func asignAction(sender:UIButton){
            if Singleton.sharedInstance.retailerData.category == "hospital"{
                let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
                 let indexPath = self.tblVw.indexPathForRow(at:buttonPosition)!
              
               var list : [TRCList]!
                if searchActive{
                    list = filteredTRC
                }else{
                    list = trcList
                }
                let trcData = list[indexPath.row]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomController") as! AddRoomController
                vc.trcData = trcData
                
                vc.fromAssignAction = true
                vc.updateProductList = {
                    self.gettrcAllocationListAPI(page: 1)
                }
                vc.isFromHospitalEdit = "assign"
                self.navigationController?.pushViewController(vc, animated: true)
            }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
                 let indexPath = self.tblVw.indexPathForRow(at:buttonPosition)!
              
               var list : [TRCList]!
                if searchActive{
                    list = filteredTRC
                }else{
                    list = trcList
                }
                let trcData = list[indexPath.row]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAssignCabVC") as! EditAssignCabVC
                vc.trcData = trcData
                
//                vc.fromAssignAction = true
                vc.updateProductList = {
                    self.gettrcAllocationListAPI(page: 1)
                }
                vc.isFromEditCab = "assign"
                self.navigationController?.pushViewController(vc, animated: true)
            } else{
                let buttonPosition = sender.convert(CGPoint.zero, to: self.tblVw)
                 let indexPath = self.tblVw.indexPathForRow(at:buttonPosition)!
              
               var list : [TRCList]!
                if searchActive{
                    list = filteredTRC
                }else{
                    list = trcList
                }
                let trcData = list[indexPath.row]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRoomController") as! AddRoomController
                vc.trcData = trcData
                vc.isFromEditRack = "assign"
                vc.updateProductList = {
                    self.gettrcAllocationListAPI(page: 1)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            
        }
       
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var list : [TRCList]!
            if searchActive{
                guard filteredTRC.count > 0 else{ return }
                list = filteredTRC
            }else{
                guard trcList.count > 0 else{ return }
                list = trcList
            }

        }
       
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            guard isLodinData == false else{
            cell.setTemplateWithSubviews(isLodinData,viewBackgroundColor: .lightGray)
                return}
            
            var list : [TRCList]!
            if searchActive{
                guard filteredTRC.count > 0 else{ return}
                list = filteredTRC
            }else{
                guard trcList.count > 0 else{ return}
                list = trcList
                }
//                let product = list[indexPath.row]
//                if product.ProductMediumImage == ""{
//                  //  let cell =  (cell as! CellAssignedAsset)
//                    (cell as! ProductTableCell).imgVwProduct.image = #imageLiteral(resourceName: "imagePlaceholder")
//                }else{
//                    let url:URL = URL(string: product.ProductMediumImage!)!
//                _ = (cell as! ProductTableCell).imgVwProduct.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
//                }
              }
        //MARK: LOAD MORE IN TABLE
        func loadMore(indexPath : IndexPath){
            if indexPath.row == trcList.count - 1 && !pageLoading{ // last cell
                if self.totalCount > trcList.count && self.page <= self.totalPage { // more items to fetch
                    self.pageLoading = true
                    let vW = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  44))
                    self.showSpinner(onView :vW)
                    // showActivityIndicatory(vw: vW)
                    self.tblVw.tableFooterView = vW
                    self.tblVw.tableFooterView?.isHidden = false
                    self.page += 1
                    gettrcAllocationListAPI(page: page)
                }
             }
          }
            }
    extension AllocationListController:UISearchBarDelegate{
        func addToolbarToSearchKeyboard()
        {
            let numberPadToolbar: UIToolbar = UIToolbar()
            numberPadToolbar.isTranslucent = true
            numberPadToolbar.items=[
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.cancelAction)),
            ]
            numberPadToolbar.sizeToFit()
            searchBar.inputAccessoryView = numberPadToolbar
            }
        
        @objc func cancelAction()
        {
        searchBar.resignFirstResponder()
        }
        //MARK: *****************Filter  Data
        func filterArrayData(text:String){
            filteredTRC = trcList.filter( {
            $0.number!.range(of: text, options: .caseInsensitive) != nil || $0.workerName!.range(of: text, options: .caseInsensitive) != nil
            })
           }
        func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
            searchActive = true
            searchBar.setShowsCancelButton(true, animated: true)
            if searchText.count > 0{
                    filterArrayData(text: searchText)
                    tblVw.reloadData()
                   
            }
            
        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchActive = false
            tblVw.reloadData()
            filteredTRC.removeAll()
            searchBar.text = ""
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
            
        }
    }
    class AllocationTableCell:UITableViewCell,ShimmeringViewProtocol{
      
        @IBOutlet weak var lblRoomNo: UILabel!
        @IBOutlet weak var lblFloor: UILabel!
        @IBOutlet weak var lblLocation: UILabel!
        @IBOutlet weak var lblDoctor: UILabel!
        @IBOutlet weak var lblService: UILabel!
        @IBOutlet weak var btnEdit: UIButton!
        @IBOutlet weak var btnAssign: UIButton!
        @IBOutlet weak var lblActiveStatus: UILabel!
        
        
        var shimmeringAnimatedItems: [UIView] {
            
               [
                lblRoomNo,
                lblFloor,
                lblLocation,
                lblDoctor,
                lblService,
                btnEdit,
                btnAssign,
                lblActiveStatus
                ].compactMap{ $0}
               }
           }
        

class allocationREstaurentCell : UITableViewCell,ShimmeringViewProtocol{
    @IBOutlet var lblTableNumber : UILabel!
    @IBOutlet var lblFloor : UILabel!
    
    @IBOutlet var lbLocation :UILabel!
    @IBOutlet var lblWaiter : UILabel!
    @IBOutlet var lblActive : UILabel!
    @IBOutlet var imgScanner : UIImageView!
    @IBOutlet var btnEditRes : UIButton!
    @IBOutlet var btnAssign : UIButton!
    var btnEditActionHandler:(()->())?
    @IBAction func btnEditAction(_ sender : Any){
        btnEditActionHandler?()
    }
    var btnAssignHandler:(()->())?
    @IBAction func btnAssignAction(_ sender : Any){
        btnAssignHandler?()
    }
    var shimmeringAnimatedItems: [UIView] {
        
           [
            lblTableNumber,
            lblFloor,
            lbLocation,
            lblWaiter,
            lblActive,
            imgScanner,
            btnAssign,
            btnEditRes
            ].compactMap{ $0}
           }
       
}
