//
//  LayoutInfo.swift
//  TagCellLayout
//
//  Created by Ritesh Gupta on 06/01/18.
//  Copyright © 2018 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public extension TagCellLayout {
	
	struct LayoutInfo {
		
		var layoutAttribute: UICollectionViewLayoutAttributes
		var whiteSpace: CGFloat = 0.0
		var isFirstElementInARow = false
		
		init(layoutAttribute: UICollectionViewLayoutAttributes) {
			self.layoutAttribute = layoutAttribute
		}
	}
}

class CustomViewFlowLayout: UICollectionViewFlowLayout {

let cellSpacing:CGFloat = 4

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            self.minimumLineSpacing = 4.0
            self.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 6)
            let attributes = super.layoutAttributesForElements(in: rect)

            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0
            attributes?.forEach { layoutAttribute in
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + cellSpacing
                maxY = max(layoutAttribute.frame.maxY , maxY)
            }
            return attributes
    }
}
