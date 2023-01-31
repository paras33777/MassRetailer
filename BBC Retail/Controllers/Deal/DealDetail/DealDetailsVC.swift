//
//  DealDetailsVC.swift
//  MASSAPPDEMO
//
//  Created by Sanjeet on 23/12/22.
//

import UIKit
import FTIndicator

class DealDetailsVC: BaseViewController {
    
    //MARK:- ==== OUTLETS ========
    @IBOutlet weak var btn_deal: UIButton!
    @IBOutlet weak var btn_store: UIButton!
    @IBOutlet weak var btn_user: UIButton!
    @IBOutlet weak var btn_workFlow: UIButton!
    @IBOutlet weak var btn_DealDoc: UIButton!
    
    
    @IBOutlet weak var btn_OrderDetail_Basic: UIButton!
    @IBOutlet weak var btn_OrderDetail_Order: UIButton!
    
    @IBOutlet weak var view_BGDeal: UIView!
    @IBOutlet weak var view_BGUser: UIView!
    
    @IBOutlet weak var tbl_workflowList: UITableView!
    @IBOutlet weak var tbl_StoreDetails: UITableView!
    
    @IBOutlet weak var tbl_workOrderDetail: UITableView!
    
    
    @IBOutlet var switch_active: UISwitch!
    
    // Sales Order Deal
    @IBOutlet weak var dealIdLabelContant: UILabel!
    @IBOutlet weak var dealIdLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var serviceLabelContant: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
   
    @IBOutlet weak var productNameLabelContant: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var quantityLabelContant: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var storeLabelContant: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    
    @IBOutlet weak var amountLabelContant: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    // Sales Order Deal
    
    
    //MARK:- ====== VARIABLES ======
    var workFlowListArr = [WorkFlow]()
    
    var dealList:DealList?
    
    var salesOrderDetail:SalesOrderDetail?
    var storeInfo:StoreInfo?
    
    var manfacturingOrderListInfo:[ManfacturingOrderListInfo]?
    var logArr:[LogsList]?
    
    var isSalesOrderDetail = true
    
    var orderPage = 1
    var orderTotalCount = Int()
    var orderTotalPage = Int()
    var orderPageLoading = false
    
    var isLogs = false
    var isWorkFlow = false
    
    var isWorkOrderDetail = false
    var isWorkOrderDetail_Basic = false
    var isWorkOrderDetail_OrderDetail = false
   
    
    var dealWorkOrderList: WorkOrderList?
    
    var manfacturingWorkOrderListInfo: ManfacturingWorkOrderListInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationSetup()
        if self.isSalesOrderDetail{
            self.initSalesOrderUI()
            self.deActivateWorkOrder()
        }else if self.isWorkOrderDetail{
            self.deactivateSalesOrder()
            self.initWorkOrderUI()
        }
        
       
       
    }
    
   
    //MARK:- ****** Navigation Setup  ********************
    fileprivate func navigationSetup() {
        let sideMenuButton =  self.getBackButton()
        sideMenuButton.0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: DetailDealListConstant.SalesOrderDetail,barTintcolor: self.themeRed , titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
        
    }
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
   
   // workOrderList : ManfacturingOrderListInfo?
    
/*
    func getManufacturingOrderList(_ page:Int,commonFilter:String = "") {
        showIndicator()
        WebServiceManager.sharedInstance.getManufacturingOrderList(page: String(page),commonFilter: commonFilter) { dealsArray, msg, status, totalCount, totalPage  in
            self.hideIndicator()
            if status == "1" {
                self.orderTotalCount = totalCount ?? 1
                self.orderPage = totalPage ?? 1
                self.manfacturingOrderListInfo = dealsArray
               // self.updateNoData(message: "")
                self.tbl_workflowList.reloadData()
            }
            else {
              
                
                FTIndicator.showToastMessage(msg)
               // self.updateNoData(message: msg)
            }
        }
    }
    */
    
    
    //MARK:- USER SELETED BUTTON HANDLE =====
    func handleSelectedDealButton(){
        staticDataCollection()
        
        view_BGDeal.isHidden = false
        view_BGUser.isHidden = true
        tbl_workflowList.isHidden = true
        tbl_StoreDetails.isHidden = true
        btn_DealDoc.setTitle("", for: .normal)
        multipleButtonCornerBgColorSet(btn1: btn_deal, btn2: btn_store, btn3: btn_user, btn4: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 2.0, btn1_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn2_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn3_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn4_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn1_text_Color: .white, btn2_text_Color: .black, btn3_text_Color: .black, btn4_text_Color: .black)
        
    }
}

//MARK:- BUTTON ACTION HANDLE ==============
extension DealDetailsVC{
    @IBAction func tapped_backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapped_DealBtn(_ sender: Any) {
        if self.isSalesOrderDetail{
        view_BGDeal.isHidden = false
        view_BGUser.isHidden = true
        tbl_workflowList.isHidden = true
        tbl_workOrderDetail.isHidden = true
        tbl_StoreDetails.isHidden = true
        
        //MARK:- BUTTON SELECTED AND DESELECTED OPTION ======
        multipleButtonCornerBgColorSet(btn1: btn_deal, btn2: btn_store, btn3: btn_user, btn4: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn1_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn2_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn3_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn4_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn1_text_Color: .white, btn2_text_Color: .black, btn3_text_Color: .black, btn4_text_Color: .black)
        }
    }
    @IBAction func tapped_StoreBtn(_ sender: Any) {
        
        if self.isSalesOrderDetail{
        view_BGDeal.isHidden = true
        view_BGUser.isHidden = true
        tbl_workflowList.isHidden = true
        tbl_workOrderDetail.isHidden = true
        tbl_StoreDetails.isHidden = false
        
        //MARK:- BUTTON SELECTED AND DESELECTED OPTION ======
        multipleButtonCornerBgColorSet(btn1: btn_deal, btn2: btn_store, btn3: btn_user, btn4: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn1_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn2_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn3_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn4_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn1_text_Color: .black, btn2_text_Color: .white, btn3_text_Color: .black, btn4_text_Color: .black)
            self.tbl_StoreDetails.reloadData()
            
        }
        else if self.isWorkOrderDetail{
            
            self.isLogs = true
            self.isWorkFlow = true
            view_BGDeal.isHidden = true
            view_BGUser.isHidden = true
           
            tbl_workOrderDetail.isHidden = true
            tbl_workflowList.isHidden = true
            tbl_StoreDetails.isHidden = false
            tbl_StoreDetails.reloadData()
            
          
            
            self.isWorkOrderDetail_Basic = false
            self.isWorkOrderDetail_OrderDetail = false
            self.tbl_workflowList.isHidden = true
            
            multipleButtonCornerBgColorSet_WorkOrder(btn_basic: self.btn_OrderDetail_Basic, btn_order: btn_OrderDetail_Order, btn_store: btn_store, btn4_logs: btn_user, btn4_workflow: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn_basic_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_order_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_store_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn_logs_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_workflow_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_basic_text_Color: .black, btn_order_text_Color: .black, btn_store_text_Color: .white, btn_logs_text_Color: .black, btn_workflow_text_Color: .black)
        }
    }
    @IBAction func tapped_UserBtn(_ sender: Any) {
        
        if self.isSalesOrderDetail{
        view_BGDeal.isHidden = true
      //  view_BGUser.isHidden = false
        self.isLogs = true
        self.isWorkFlow = false
        tbl_workflowList.isHidden = false
        tbl_workOrderDetail.isHidden = true
        tbl_StoreDetails.isHidden = true
        
        //MARK:- BUTTON SELECTED AND DESELECTED OPTION ======
        multipleButtonCornerBgColorSet(btn1: btn_deal, btn2: btn_store, btn3: btn_user, btn4: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn1_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn2_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn3_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn4_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn1_text_Color: .black, btn2_text_Color: .black, btn3_text_Color: .white, btn4_text_Color: .black)
            self.tbl_workflowList.reloadData()
    }
        else if self.isWorkOrderDetail{
            
            self.isLogs = true
            self.isWorkFlow = false
            tbl_workflowList.isHidden = false
            tbl_StoreDetails.isHidden = true
            
            self.isWorkOrderDetail_Basic = false
            self.isWorkOrderDetail_OrderDetail = false
            self.tbl_workOrderDetail.isHidden = true
            self.tbl_workflowList.reloadData()
            multipleButtonCornerBgColorSet_WorkOrder(btn_basic: self.btn_OrderDetail_Basic, btn_order: btn_OrderDetail_Order, btn_store: btn_store, btn4_logs: btn_user, btn4_workflow: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn_basic_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_order_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_store_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_logs_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn_workflow_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_basic_text_Color: .black, btn_order_text_Color: .black, btn_store_text_Color: .black, btn_logs_text_Color: .white, btn_workflow_text_Color: .black)
        }
    }
    
    @IBAction func tapped_workFlowBtn(_ sender: Any) {
        
        if self.isSalesOrderDetail{
            view_BGDeal.isHidden = true
            self.isLogs = false
            self.isWorkFlow = true
            tbl_workflowList.isHidden = false
            tbl_workOrderDetail.isHidden = true
            tbl_StoreDetails.isHidden = true
            
           
            //MARK:- BUTTON SELECTED AND DESELECTED OPTION ======
            multipleButtonCornerBgColorSet(btn1: btn_deal, btn2: btn_store, btn3: btn_user, btn4: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn1_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn2_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn3_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn4_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn1_text_Color: .black, btn2_text_Color: .black, btn3_text_Color: .black, btn4_text_Color: .white)
            self.tbl_workflowList.reloadData()
        }else if self.isWorkOrderDetail{
            
            self.isLogs = false
            self.isWorkFlow = true
            tbl_workflowList.isHidden = false
            tbl_StoreDetails.isHidden = true
            
            self.isWorkOrderDetail_Basic = false
            self.isWorkOrderDetail_OrderDetail = false
            self.tbl_workOrderDetail.isHidden = true
            multipleButtonCornerBgColorSet_WorkOrder(btn_basic: self.btn_OrderDetail_Basic, btn_order: btn_OrderDetail_Order, btn_store: btn_store, btn4_logs: btn_user, btn4_workflow: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn_basic_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_order_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_store_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_logs_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_workflow_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn_basic_text_Color: .black, btn_order_text_Color: .black, btn_store_text_Color: .black, btn_logs_text_Color: .black, btn_workflow_text_Color: .white)
            self.tbl_workflowList.reloadData()
        }
        
    }
    
    @IBAction func tappedOrderDetail_Basic(_ sender: Any) {
        if self.isWorkOrderDetail{
            tappedOrderDetail_Basicfunc()
        }
    }
    func tappedOrderDetail_Basicfunc(){
        
        self.isLogs = false
        self.isWorkFlow = false
        tbl_workflowList.isHidden = true
        tbl_StoreDetails.isHidden = true
       
        
        view_BGDeal.isHidden = true
        view_BGUser.isHidden = true
        
        
        self.isWorkOrderDetail_Basic = true
        self.isWorkOrderDetail_OrderDetail = false
        self.tbl_workOrderDetail.isHidden = false
        self.tbl_workOrderDetail.reloadData()
        
        multipleButtonCornerBgColorSet_WorkOrder(btn_basic: self.btn_OrderDetail_Basic, btn_order: btn_OrderDetail_Order, btn_store: btn_store, btn4_logs: btn_user, btn4_workflow: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn_basic_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn_order_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_store_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_logs_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_workflow_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_basic_text_Color: .white, btn_order_text_Color: .black, btn_store_text_Color: .black, btn_logs_text_Color: .black, btn_workflow_text_Color: .black)
    }
    
    @IBAction func tappedOrderDetail_Order(_ sender: Any) {
        if self.isWorkOrderDetail{
            
            self.isLogs = false
            self.isWorkFlow = false
            tbl_workflowList.isHidden = true
            tbl_StoreDetails.isHidden = true
           
            
            view_BGDeal.isHidden = true
            view_BGUser.isHidden = true
            
            
            self.isWorkOrderDetail_Basic = false
            self.isWorkOrderDetail_OrderDetail = true
            self.tbl_workOrderDetail.isHidden = false
            self.tbl_workOrderDetail.reloadData()
            
            
            multipleButtonCornerBgColorSet_WorkOrder(btn_basic: self.btn_OrderDetail_Basic, btn_order: btn_OrderDetail_Order, btn_store: btn_store, btn4_logs: btn_user, btn4_workflow: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn_basic_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_order_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn_store_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_logs_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_workflow_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn_basic_text_Color: .black, btn_order_text_Color: .white, btn_store_text_Color: .black, btn_logs_text_Color: .black, btn_workflow_text_Color: .black)
        }
    }
    
    
    
    //MARK:- SWITCH BUTTON HANDLE ======
    @IBAction func activeSwitchValueChanged (sender: UISwitch) {
        if sender.isOn{
            print("Switch ON")
        }else{
            print("Switch OFF")
        }
    }
    
    
}

//MARK:- ****** DATA COLLECTION  ********************
extension DealDetailsVC{
    
    func staticDataCollection(){
    }
}


