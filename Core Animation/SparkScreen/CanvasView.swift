//
//  CanvasView.swift
//  Core Animation
//
//  Created by Евгений Бияк on 02.08.2022.
//

import UIKit

protocol CanvasViewDelegate: AnyObject {
    func canvasView(_ canvasView: CanvasView, touchMovedAtPoint point: CGPoint, from previousPoint: CGPoint)
}

class CanvasView: UIControl {
    
    weak var delegate: CanvasViewDelegate?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self),
              let previousPoint = touches.first?.previousLocation(in: self)
        else { return }
        
        delegate?.canvasView(self, touchMovedAtPoint: point, from: previousPoint)
    }
    
}
