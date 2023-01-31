//
//  FilterByVC.swift
//  MASSAPPDEMO
//
//  Created by Sanjeet on 23/12/22.
//

import UIKit
import FTIndicator

// MARK:- Delegate through data pass to Homevc
protocol filterDataDelegate {
    func filterdataPass(FilterData:Any)
}

class FilterByVC: UIViewController {
    
    //MARK:- ==== OUTLETS ========
    @IBOutlet weak var coll_filterBy: UICollectionView!
    @IBOutlet weak var tbl_filterList: UITableView!
    @IBOutlet weak var btn_cross: UIButton!
    @IBOutlet weak var btn_apply: UIButton!
    @IBOutlet weak var view_line: UIView!
    
    //MARK:- ====== VARIABLES ======
    let filterByTypeArr = ["Sales Order","Sales Order2","Sales Order3"]
    var filterByListArr = [String]()
    var SelectedFilterproduct_String : [String] = []
    var SelectedFilterType_String : [String] = []
    var  collectionFilterData = [String:Any]()
    var delegate: filterDataDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- ========= BUTTON ACTION =========
    @IBAction func tapped_crossBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapped_cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapped_ApplyBtn(_ sender: Any) {
        
        if SelectedFilterproduct_String.count == 0{
            
            //Message will be show
            
            FTIndicator.showToastMessage("Please select at leaset one product")
        }else{
            self.delegate?.filterdataPass(FilterData:collectionFilterData)
            self.dismiss(animated: true, completion: nil)
        }
    }
}


// MARK:-  COLLECTION VIEW DELEGATE AND DATA SOURCE ======
extension FilterByVC:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return   1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterByTypeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterByCell", for: indexPath) as! filterByCell
        
        cell.lbl_FilterName.text =  filterByTypeArr[indexPath.item]
        
        //MARK:- SELECTED FILTER TYPE ====
        let  data = filterByTypeArr[indexPath.item]
        if SelectedFilterType_String.contains(data){
            cell.contentView.backgroundColor = .white
        }else{
            cell.contentView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        }
        
        return  cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: coll_filterBy.frame.size.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //MARK:-  SELETED AND DESELETED HANDLE =====
        if SelectedFilterType_String.count != 0{
            SelectedFilterType_String.removeAll()
            SelectedFilterType_String.append(filterByTypeArr[indexPath.item])
        }else{
            SelectedFilterType_String.append(filterByTypeArr[indexPath.item])
        }
        //MARK:-  Data Reload according to filter type selected
        if indexPath.item == 0{
            filterByListArr = ["Retailer Poduct Process"]
        }else if indexPath.item == 1{
            filterByListArr = ["Retailer Poduct Process 2","Retailer Poduct Process 3"]
        }else{
            filterByListArr = ["Retailer Poduct Process 4","Retailer Poduct Process 5"]
        }
        //MARK:- These are all show after filter type option will be select ===
        btn_cross.isHidden = false
        tbl_filterList.isHidden = false
        tbl_filterList.delegate = self
        btn_apply.isHidden = false
        view_line.isHidden = false
        tbl_filterList.dataSource = self
        self.tbl_filterList.reloadData()
        self.coll_filterBy.reloadData()
        
    }
}
//MARK :- ********** TABLE VIEW DELEGATE  ******
extension FilterByVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterByListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterByListCell", for: indexPath) as! filterByListCell
        cell.lbl_FilterName.text = filterByListArr[indexPath.row]
        
        //MARK:- Button Clickable ====
        cell.btn_SelectedProduct.tag = indexPath.row
        cell.btn_SelectedProduct.addTarget(self, action: #selector(tapped_filterProductBtn(sender:)), for: .touchUpInside)
        let  data = filterByListArr[indexPath.row]
        if SelectedFilterproduct_String.contains(data){
            
            cell.btn_SelectedProduct.setImage(UIImage(named: "select-radio-btn"), for: .normal)
        }else{
            cell.btn_SelectedProduct.setImage(UIImage(named: "Radio"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let initVC  = storyBoard.instantiateViewController(withIdentifier: "DealDetailsVC") as! DealDetailsVC
        self.navigationController?.pushViewController(initVC, animated: true)
    }
    
    //MARK:- CELL BUTTON ACTION ======
    @objc func tapped_filterProductBtn(sender:UIButton){
        let  data = filterByListArr[sender.tag]
        if SelectedFilterproduct_String.contains(data){
            SelectedFilterproduct_String.remove(at: SelectedFilterproduct_String.index(of: data)!)
            
        }else{
            SelectedFilterproduct_String.append(data)
            collectionFilterData["data"] = SelectedFilterproduct_String
        }
        
        self.tbl_filterList.reloadData()
    }
    
}
