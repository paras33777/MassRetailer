//
//  DynamicCollectionVW.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 21/07/22.
//

import Foundation
import UIKit

class DynamicCollectionVW: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !(__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize)){
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
