//
//  PaymentSuccessfulVC.swift
//  BBC Retail
//
//  Created by PARAS on 08/11/22.
//

import UIKit
//MARK: PROTOCOLS
protocol setBackFromPayment{
    func backReturnFromPayment()
}
protocol goToDetail{
    func pushToDetail(orderId:Int)
}

class PaymentSuccessfulVC: UIViewController {
    //MARK: IBOUTLET AND VARIABLES
    @IBOutlet weak var lblAmountPaid: UILabel!
    var amountPaid = ""
    var orderId = 0
    var delegateCall : setBackFromPayment?
    var delegateForPush : goToDetail?
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblAmountPaid.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "")\(self.amountPaid)"
    }
    //MARK: BUTTON ACTION
    @IBAction func buttonCross(_ sender: UIButton) {
        if let del = self.delegateCall{
            self.dismiss(animated: false)
            del.backReturnFromPayment()
        }
    }
    @IBAction func buttonOrderDetail(_ sender: UIButton) {
        if let del1 = self.delegateForPush{
            self.dismiss(animated: false)
            del1.pushToDetail(orderId: self.orderId)
        }
        
    }
    
}
