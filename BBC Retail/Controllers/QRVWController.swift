//
//  QRVWController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 19/04/22.
//

import UIKit
import Kingfisher

class QRVWController: UIViewController {
    //MARK: - IBOUTLET
    @IBOutlet weak var vwMainBg: UIView!
    @IBOutlet weak var vwTopNavBar: UIView!
    @IBOutlet weak var lblName: UILabel!
  //  @IBOutlet weak var lblLocation: UILabel!
  //  @IBOutlet weak var lblGst: UILabel!
    @IBOutlet weak var imgVwQRCode: UIImageView!
    //MARK: - VARIABLES
        //MARK: - IBACTIONS
    @IBAction func btnShareStoreQrAction(_ sender: UIButton) {
        print(vwTopNavBar.frame.height)
        let imag = UIImage.init(view: self.vwMainBg)
        
        let activityViewController = UIActivityViewController(activityItems: [imag], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController,animated: true, completion: nil)
    }
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
       {
        var rect = CGRect()
        rect = CGRect(x:cropRect.origin.x*inputImage.scale,
                        y:cropRect.origin.y*inputImage.scale,
                          width:cropRect.size.width*inputImage.scale,
                      height: cropRect.size.height*inputImage.scale)
        

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:rect)
        else {
            return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
        //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
     updateUI()
       
    }
    

   
    // MARK: - UPDATE UI
    func updateUI(){
        lblName.text = Singleton.sharedInstance.retailerData.StoreName!.capitalized//"\(Singleton.sharedInstance.retailerData.ADMINFIRSTNAME!.capitalized) \(Singleton.sharedInstance.retailerData.ADMINLASTNAME!.capitalized)"
       // lblLocation.text = Singleton.sharedInstance.retailerData.ADMINADDRESS?.capitalized
        if Singleton.sharedInstance.retailerData.GSTNUMBER! == ""{
           // lblGst.alpha = 0
        }else{
      //  lblGst.attributedText = getAttrbText(simpleText: Singleton.sharedInstance.retailerData.GSTNUMBER!.capitalized, text: "GST Number: \(Singleton.sharedInstance.retailerData.GSTNUMBER!.capitalized)")
        //    lblGst.alpha = 1
        }
        guard let url = URL(string: Singleton.sharedInstance.retailerData.RETAILERQRCODE!) else{return}
        imgVwQRCode.kf.setImage(with: url)
       }
   
       }
extension UIImage{
    convenience init(view: UIView) {

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, UIScreen.main.scale)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (image?.cgImage)!)

  }
}
