//
//  ProductDetailManfacturingViewController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 18/01/23.
//

import UIKit
import UIView_Shimmer
import FTIndicator
class ProductDetailManfacturingViewController: BaseViewController {
    // MARK: - IBOUTLET
   
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var editButtonMaterial: UIButton!
   
 
    
   
    @IBOutlet weak var lableVersionConstant: UILabel!
    @IBOutlet weak var lableVersionDes: UILabel!
  
    @IBOutlet weak var lableMaterialConstant: UILabel!
    
    
    @IBOutlet weak var productDesContant: UILabel!
    @IBOutlet weak var productDesValue: UILabel!
    @IBOutlet weak var subskillCollectionView: UICollectionView!
    
    @IBOutlet weak var subskillCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var switchStatus : UISwitch!
    @IBOutlet weak var statusLable : UILabel!
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    // MARK: - VARIABLE
    var fromMainScanner = false
    var openCart:(() -> Void)!
    var productList : Productlist!
  
    var productDetail : ManfacturingProductDetail?
    
    var updateProductList:((_ storeID:String) -> Void)!
    
    @IBAction func btnbackAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
    }
  
    var selectedSubSkillId = [String]()
    var selectedSubSkillName = [String]()
    var selectedQuantity = [String]()
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationSetup()
        lableMaterialConstant.text = ProductDetailManfacturingViewControllerConstant.Material
        productDesContant.text = ProductDetailManfacturingViewControllerConstant.ProductDescription
        self.editButtonMaterial.setTitle(ProductDetailManfacturingViewControllerConstant.EditMaterial, for: .normal)
        
        self.geProductDetailsByID(productId: self.productList.productId ?? "")
        
        Utility().roundCorner(view: self.editButtonMaterial, borderWith: 1.0, borderColor: self.themeRed, cornerRadius: 4)
        
      }
    
    func geProductDetailsByID(productId:String){
        let storeType =  Singleton.sharedInstance.retailerData.category?.lowercased() ?? ""
        if storeType.contains("manufacturing"){
            
            WebServiceManagerDeal.sharedInstance.getManufacturingProductsDetail(product_id: productId) {list1,msg, status in
                if status == "1"{
                  
                    self.productDetail = nil
                    self.subskillCollectionView.reloadData()
                    self.productDetail = list1
                    self.updateUI()
                    self.setProductImage()
                    
                     var count  = self.productDetail?.subSkillsList?.count ?? 0
                      count  = ((count/3) * 35) + 35
                    
                    let seconds = 0.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        // Put your code which should be executed with a delay here
                        
                        self.subskillCollectionViewHeight.constant = CGFloat(count)
                       
                        self.subskillCollectionView.reloadData()
                    }
                   
                    
                    
                    
                }else{
                    FTIndicator.showToastMessage(msg)
                }
            }
        }
        
    }
    
    //MARK: - SET Product image
    func setProductImage(){
       
        if let url:URL = URL(string:productDetail?.productMediumImage ?? ""){
            imgVwProduct.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
           }
        }
    
    //MARK: - UPDATE UI
    func updateUI(){
       
        self.statusLable.text = productDetail?.productStatus ?? ""
        if self.statusLable.text == "Active"{
            self.switchStatus.isOn = true
        }else{
            self.switchStatus.isOn = false

        }
        self.switchStatus.isUserInteractionEnabled = false
        
        
        lblTitle1.text = productDetail?.productName?.capitalized
        lblTitle2.text = productDetail?.categoryName?.capitalized
        lableVersionDes.text = productDetail?.childCategoryName?.capitalized
        productDesValue.text = productDetail?.productShortDescription ?? ""
        
        if let subskill = self.productDetail?.subSkillsList
        {
            for(index,object) in subskill.enumerated()
          {
            self.selectedSubSkillId = []
            self.selectedSubSkillName = []
            self.selectedQuantity = []
                self.selectedQuantity.append(object.quantity ?? "")
                self.selectedSubSkillId.append(object.id ?? "")
                self.selectedSubSkillId.append(object.quantity ?? "")
            
        }
    }
    }
    //MARK:- ****** Navigation Setup  ********************
    fileprivate func navigationSetup() {
        let sideMenuButton =  self.getBackButton()
        sideMenuButton.0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: ProductDetailManfacturingViewControllerConstant.ProductDetail,barTintcolor: self.themeRed , titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
        
    }
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editMaterialButtonPressed(_ sender: Any) {
        
    /*    let vc = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "SubSkillViewController") as! SubSkillViewController
        vc.come = "edit"
        vc.productId = self.productDetail?.productId ?? ""
        vc.selectedId = self.selectedSubSkillId
        vc.id = self.selectedSubSkillId
        vc.selectedName = self.selectedSubSkillName
        vc.selectedQuantity = self.selectedQuantity
        vc.delegate = self
       vc.show()
     */
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMaterialViewController") as! AddMaterialViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.productDetail = self.productDetail
        vc.delegate = self
        
        self.present(vc, animated: false,completion: nil)
        
    }
    @IBAction func editProductButtonPressed(_ sender: Any)
    {
        let vc = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "AddProductManfacturingViewController") as! AddProductManfacturingViewController
        var list : [Productlist]!
        vc.product = self.productList
        vc.isComingFrom = "EditProduct"
        vc.updateProductList = {
            self.geProductDetailsByID(productId: self.productList.productId ?? "")
        }
        vc.productImageFromEdit = productList.Product_Medium_Image ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    }
extension ProductDetailManfacturingViewController:  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDetail?.subSkillsList?.count ?? 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubSkillCollectionViewCell", for: indexPath as IndexPath) as! SubSkillCollectionViewCell
       
        
       
        if let object =    self.productDetail?.subSkillsList{
            let subskill = object[indexPath.row]
            cell.titlelabel.text = subskill.name
        }
        cell.viewBack.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        Utility().roundCorner(view: cell.viewBack, borderWith: 1.0, borderColor: UIColor.lightGray.withAlphaComponent(0.5), cornerRadius: 4)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let object =    self.productDetail?.subSkillsList{
            let subskill = object[indexPath.row]
            
            WebServiceManagerDeal.sharedInstance.deleteProductSubSkill(product_id: self.productDetail?.productId ?? "", subSkillId: subskill.id ?? ""){ msg, status in
                if status == "1"{
                    self.geProductDetailsByID(productId: self.productDetail?.productId ?? "")
                    
                }else{
                    FTIndicator.showToastMessage(msg)
                }
                
            }
        }
        
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var stringC = ""
        if let object =    self.productDetail?.subSkillsList{
            let subskill = object[indexPath.row]
                   stringC = subskill.name ?? ""
                let label = UILabel(frame: CGRect.zero)
                  label.text = subskill.name ?? ""
                  label.sizeToFit()
            return CGSize(width: label.frame.width + 80, height: 35)
        }
        return CGSize(width: 100, height: 35)
        }
    
    
        
        
        
}
/*extension ProductDetailManfacturingViewController:SendSubSkill{
      
    func tableviewReload(selectedId:[String],selectedName:[String],selectedQuantity:[String]){
          self.selectedSubSkillId = selectedId
          self.selectedSubSkillName = selectedName
          self.selectedQuantity = selectedQuantity
         self.geProductDetailsByID(productId: self.productList.ProductId ?? "")
     
    }

}*/
extension ProductDetailManfacturingViewController : AddMaterialViewControllerDelegate{
    func reloadView(){
        self.geProductDetailsByID(productId: self.productList.productId ?? "")
    }
}
