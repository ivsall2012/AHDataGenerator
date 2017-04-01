//
//  AHPhotoBrowserLayout.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/31/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

class AHPhotoBrowserLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    /// This function produce inconsistent slide photo experience
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let attributes = super.layoutAttributesForElements(in: collectionView!.bounds) {
            let half = collectionView!.bounds.width * 0.5
            let proposedOffsetCneterX = collectionView!.contentOffset.x + half
            
            let closests = attributes.sorted(by: { (attrA, attrB) -> Bool in
                return abs(attrA.center.x - proposedOffsetCneterX) < abs(attrB.center.x - proposedOffsetCneterX)
            })
            
            let targetAttr : UICollectionViewLayoutAttributes
            if closests.count > 1 && abs(velocity.x) > 0.1 {
                targetAttr = closests[1]
            }else{
                targetAttr = closests[0]
            }
            
            return CGPoint(x: targetAttr.center.x - half, y: proposedContentOffset.y)
            
        }
        
        return CGPoint.zero
    }
}
