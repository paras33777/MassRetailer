//
//  BaseViewController.swift
//  BBC Retail
//
//  Created by rupinder singh on 09/01/23.
//

import UIKit

class BaseViewController: UIViewController {
    var themeRed =  UIColor.init(named: "themeRed") ?? UIColor.red
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension BaseViewController {
    
    func hideBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func navigationBarSetUp(navigation:UINavigationController?,controller:UIViewController?,titleText: String = "", barTintcolor: UIColor = .green, titleTextColor: UIColor = .white, leftBarItem: [UIBarButtonItem]?, rightBarItem: [UIBarButtonItem]?, leftBarItem1: UIBarButtonItem?)   {
        
        self.title = titleText
        navigation?.navigationBar.barTintColor = barTintcolor
        navigation?.navigationBar.titleTextAttributes = [.foregroundColor: titleTextColor]
        controller?.navigationItem.leftBarButtonItems = leftBarItem
        controller?.navigationItem.rightBarButtonItems = rightBarItem
        
        if #available(iOS 15, *) {
                // Navigation Bar background color
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
               appearance.backgroundColor = barTintcolor
                
                // setup title font color
               
                appearance.titleTextAttributes = [.foregroundColor: titleTextColor]
                
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            }
    
    }
    func getBackButton(_ imageName: String = "leftarrow")-> (UIButton, UIBarButtonItem){
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: imageName), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let item1 = UIBarButtonItem(customView: btn1)
        return(btn1,item1)
    }
    func getMenuButton(_ imageName: String = "menu-icon")-> (UIButton, UIBarButtonItem){
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: imageName), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let item1 = UIBarButtonItem(customView: btn1)
        return(btn1,item1)
    }
    func getPlusButton(title: String = "",imageName: String = "")-> (UIButton, UIBarButtonItem){
        let btn1 = UIButton(type: .custom)
        if title != ""{
            btn1.setTitle(title, for: .normal)
            btn1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35.0)
        }
        if imageName != "" {
            btn1.setImage(UIImage(named: imageName), for: .normal)
        }
       
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let item1 = UIBarButtonItem(customView: btn1)
        return(btn1,item1)
    }
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


