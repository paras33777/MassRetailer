//
//  BookedCabOrderDetail.swift
//  BBC Retail
//
//  Created by Himanshu on 21/11/22.
//

import UIKit

class BookedCabOrderDetail: UIViewController {
    @IBOutlet var tblCabOrderDetail : UITableView!
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    //MARK: BUTTON ACTI{ON
    @IBAction func btnBackAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }

    

}
//MARK: TABLEVIEW CELL
class bookedCabOrderListCell : UITableViewCell{
    @IBOutlet var lblCarName : UILabel!
    @IBOutlet var lblDriverName : UILabel!
    @IBOutlet var lblTaxiNumber : UILabel!
    @IBOutlet var lblDistance : UILabel!
    @IBOutlet var lblDropLocation : UILabel!
    @IBOutlet var lblPickupLocation : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblPrice : UILabel!
    @IBOutlet var imgProductImage : UIImageView!
}

extension BookedCabOrderDetail : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCabOrderDetail.dequeueReusableCell(withIdentifier: "bookedCabOrderListCell", for: indexPath)as! bookedCabOrderListCell
        return cell
    }
    
    
}
