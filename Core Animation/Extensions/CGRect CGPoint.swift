//
//  CGRect + center.swift
//  Core Animation
//
//  Created by Евгений Бияк on 31.07.2022.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        CGPoint(x: width / 2, y: height / 2)
    }
}
 
extension CGFloat {
    var degrees: CGFloat {
        self * 180 / .pi
    }
    var radians: CGFloat {
        self * .pi / 180
    }
}

extension CGPoint {
    func angleDegrees(to comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - x
        let originY = comparisonPoint.y - y
        
        let bearingDegrees = atan2(originY, originX).degrees
        
        return bearingDegrees < 0 ? bearingDegrees + 360 : bearingDegrees
    }
    
    func rotate(around origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
        let dx = x - origin.x
        let dy = y - origin.y
        
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) + byDegrees.radians
        
        let x = origin.x + radius * cos(azimuth)
        let y = origin.y + radius * sin(azimuth)
        
        return CGPoint(x: x, y: y)
    }
}
