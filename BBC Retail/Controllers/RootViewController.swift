//
//  RootViewController.swift
//  
//  Copyright © 2019 Newforce Ltd. All rights reserved.
//
import UIKit
import AKSideMenu

class RootViewController: AKSideMenu {
    //MARK: ******************* IBOUTLET
    //MARK: ******************* VARIABLE
    //MARK: ******************* IBACTIONS
    //MARK: ******************* VIEW LIFE CYCLE
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = hexStringToUIColor(hex: Color.logoRed.rawValue)
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.4
        self.contentViewShadowRadius = 5
        self.contentViewShadowEnabled = true
        self.contentViewScaleValue = 0.5
       // self.contentViewInPortraitOffsetCenterX = 0
        
        
        //self.backgroundImage = UIImage(named: "appBG.png")
        self.delegate = self
        if let storyboard = self.storyboard {
            self.contentViewController = storyboard.instantiateViewController(withIdentifier: "contentAdmin")
            self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController")
            self.rightMenuViewController = nil
         }
       }
    }


extension RootViewController : AKSideMenuDelegate {
    
    // MARK: - <AKSideMenuDelegate>
    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        //   print("willShowMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        //    print("didShowMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        //   print("willHideMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        //  print("didHideMenuViewController")
    }
}
