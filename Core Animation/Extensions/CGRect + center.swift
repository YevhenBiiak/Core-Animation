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
 
