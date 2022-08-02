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
        return self * CGFloat(180) / .pi
    }
}

extension CGPoint {
    func angle(to comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - x
        let originY = comparisonPoint.y - y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians).degrees

        while bearingDegrees < 0 {
            bearingDegrees += 360
        }

        return bearingDegrees
    }
}
