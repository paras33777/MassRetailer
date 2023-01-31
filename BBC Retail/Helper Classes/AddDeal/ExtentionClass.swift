//
//  ExtentionClass.swift
//  MASSAPPDEMO
//
//  Created by Sanjeet on 23/12/22.
//

import Foundation
import UIKit


//MARK:- 4Button SELECTED FUNCTION CREATE
func   multipleButtonCornerBgColorSet(btn1:UIButton,btn2:UIButton,btn3:UIButton,btn4:UIButton,boarderWidth:CGFloat?,boarderColor:UIColor?,cornerRadius:CGFloat?,btn1_bgColor:UIColor?,btn2_bgColor:UIColor?,btn3_bgColor:UIColor?,btn4_bgColor:UIColor?,btn1_text_Color:UIColor?,btn2_text_Color:UIColor?,btn3_text_Color:UIColor?,btn4_text_Color:UIColor?){
    
    btn1.layer.borderWidth = boarderWidth ?? 0.0
    btn1.layer.cornerRadius = cornerRadius ?? 0.0
    btn1.layer.borderColor = boarderColor?.cgColor
    btn1.backgroundColor = btn1_bgColor
    btn1.setTitleColor(btn1_text_Color, for: .normal)
    
    btn2.layer.borderWidth = boarderWidth ?? 0.0
    btn2.layer.cornerRadius = cornerRadius ?? 0.0
    btn2.layer.borderColor = boarderColor?.cgColor
    btn2.backgroundColor = btn2_bgColor
    btn2.setTitleColor(btn2_text_Color, for: .normal)
    
    btn3.layer.borderWidth = boarderWidth ?? 0.0
    btn3.layer.cornerRadius = cornerRadius ?? 0.0
    btn3.layer.borderColor = boarderColor?.cgColor
    btn3.backgroundColor = btn3_bgColor
    btn3.setTitleColor(btn3_text_Color, for: .normal)
    
    btn4.layer.borderWidth = boarderWidth ?? 0.0
    btn4.layer.cornerRadius = cornerRadius ?? 0.0
    btn4.layer.borderColor = boarderColor?.cgColor
    btn4.backgroundColor = btn4_bgColor
    btn4.setTitleColor(btn4_text_Color, for: .normal)
    
}
func   multipleButtonCornerBgColorSet_WorkOrder(btn_basic:UIButton,btn_order:UIButton,btn_store:UIButton,btn4_logs:UIButton,btn4_workflow:UIButton,boarderWidth:CGFloat?,boarderColor:UIColor?,cornerRadius:CGFloat?,btn_basic_bgColor:UIColor?,btn_order_bgColor:UIColor?,btn_store_bgColor:UIColor?,btn_logs_bgColor:UIColor?,btn_workflow_bgColor:UIColor,btn_basic_text_Color:UIColor?,btn_order_text_Color:UIColor?,btn_store_text_Color:UIColor?,btn_logs_text_Color:UIColor?,btn_workflow_text_Color:UIColor?){
    
    btn_basic.layer.borderWidth = boarderWidth ?? 0.0
    btn_basic.layer.cornerRadius = cornerRadius ?? 0.0
    btn_basic.layer.borderColor = boarderColor?.cgColor
    btn_basic.backgroundColor = btn_basic_bgColor
    btn_basic.setTitleColor(btn_basic_text_Color, for: .normal)
    
    btn_order.layer.borderWidth = boarderWidth ?? 0.0
    btn_order.layer.cornerRadius = cornerRadius ?? 0.0
    btn_order.layer.borderColor = boarderColor?.cgColor
    btn_order.backgroundColor = btn_order_bgColor
    btn_order.setTitleColor(btn_order_text_Color, for: .normal)
    
    btn_store.layer.borderWidth = boarderWidth ?? 0.0
    btn_store.layer.cornerRadius = cornerRadius ?? 0.0
    btn_store.layer.borderColor = boarderColor?.cgColor
    btn_store.backgroundColor = btn_store_bgColor
    btn_store.setTitleColor(btn_store_text_Color, for: .normal)
    
    btn4_logs.layer.borderWidth = boarderWidth ?? 0.0
    btn4_logs.layer.cornerRadius = cornerRadius ?? 0.0
    btn4_logs.layer.borderColor = boarderColor?.cgColor
    btn4_logs.backgroundColor = btn_logs_bgColor
    btn4_logs.setTitleColor(btn_logs_text_Color, for: .normal)
    
    
    btn4_workflow.layer.borderWidth = boarderWidth ?? 0.0
    btn4_workflow.layer.cornerRadius = cornerRadius ?? 0.0
    btn4_workflow.layer.borderColor = boarderColor?.cgColor
    btn4_workflow.backgroundColor = btn_workflow_bgColor
    btn4_workflow.setTitleColor(btn_workflow_text_Color, for: .normal)
    
}

//MARK:- ============  UIVIEW =============================================
@IBDesignable
class CustomView:UIView{
    
    @IBInspectable var bottomLeftCorner: CGFloat = 0 {
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds =  cornerRadius > 0
            layer.maskedCorners = [.layerMinXMaxYCorner]
        }
    }
    @IBInspectable var bottomRightCorner: CGFloat = 0 {
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds =  cornerRadius > 0
            layer.maskedCorners = [.layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var topLRCorner: CGFloat = 0 {
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds =  cornerRadius > 0
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    @IBInspectable var bottomLRCorner: CGFloat = 0 {
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds =  cornerRadius > 0
            layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var topLbottomRCorner: CGFloat = 0 {
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds =  cornerRadius > 0
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBInspectable var topRbottomLCorner: CGFloat = 0 {
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds =  cornerRadius > 0
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable var topLbottomLCorner: CGFloat = 0 {
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds =  cornerRadius > 0
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBInspectable var topRbottomRCorner: CGFloat = 0 {
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds =  cornerRadius > 0
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var isViewRound: Bool = false {
        didSet {
            if(isViewRound){
                layer.cornerRadius = self.frame.height/2
                layer.masksToBounds = true
            }
        }
    }
    @IBInspectable
    var backGroundColorView: UIColor? {
        get {
            guard let color = layer.backgroundColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.backgroundColor = newValue?.cgColor
        }
    }
  
    //MARK:- ****** DOTTED DASH Line ViEW USE ************
    
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
        
    }
    
}
