//
//  StretchBallViewController.swift
//  Core Animation
//
//  Created by Евгений Бияк on 02.08.2022.
//

import UIKit

class StretchBallViewController: UIViewController {
        
    var ballLayer: CAShapeLayer!
    
    var center: CGPoint { view.bounds.center }
    var radius: CGFloat { min(view.bounds.width, view.bounds.height) * 0.5 / 2 }
    
    // MARK: - Life cycle and override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        view.addGestureRecognizer(panGesture)
        
        ballLayer = configureBallLayer()
        view.layer.addSublayer(ballLayer)
    }
    
    override func viewDidLayoutSubviews() {
        ballLayer.path = configureBallLayerPath()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // remove sublayers
        ballLayer.sublayers = nil
        // reset transform
        ballLayer.setAffineTransform(CGAffineTransform.identity)
        // change frame
        ballLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    // MARK: - Actions
    
    @objc private func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        struct Touch {
            static var isBeganInArea: Bool = false
            static var isCrossedBorder: Bool = false
        }
        
        let point = sender.location(in: view)
        
        if sender.state == .ended {
            animateToStartPosition()
            Touch.isBeganInArea = false
            Touch.isCrossedBorder = false
            return
        }
        
        if ballLayer.path!.contains(point) {
            Touch.isBeganInArea = true
        }
        if !ballLayer.path!.contains(point) {
            Touch.isCrossedBorder = true
        }
        
        if Touch.isBeganInArea, Touch.isCrossedBorder {
            ballLayer.removeAllAnimations()
            ballLayer.path = configureBallLayerPath(touchPoint: point)
        }
    }
    
    // MARK: - Helper methods
    
    private func configureBallLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.fillColor = UIColor.systemPink.cgColor
        return layer
    }
    
    private func configureBallLayerPath(touchPoint: CGPoint? = nil) -> CGPath {
        var point0 = CGPoint(x: center.x + radius, y: center.y)
        let point1 = CGPoint(x: center.x, y: center.y + radius)
        let point2 = CGPoint(x: center.x - radius, y: center.y)
        let point3 = CGPoint(x: center.x, y: center.y - radius)
        
        if let touchPoint = touchPoint {
            let angle = center.angleDegrees(to: touchPoint)
            point0 = touchPoint.rotate(around: center, byDegrees: 360 - angle)
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            ballLayer.transform = CATransform3DMakeRotation(angle.radians, 0, 0, 1)
            CATransaction.commit()
        }
        
        let coeff = radius * 0.55
        
        let cp01 = CGPoint(x: point0.x, y: point0.y + coeff)
        let cp02 = CGPoint(x: point1.x + coeff, y: point1.y)
        
        let cp11 = CGPoint(x: point1.x - coeff, y: point1.y)
        let cp12 = CGPoint(x: point2.x, y: point2.y + coeff)
        
        let cp21 = CGPoint(x: point2.x, y: point2.y - coeff)
        let cp22 = CGPoint(x: point3.x - coeff, y: point3.y)
        
        let cp31 = CGPoint(x: point3.x + coeff, y: point3.y)
        let cp32 = CGPoint(x: point0.x, y: point0.y - coeff)
        
        let path = UIBezierPath()
        path.move(to: point0)
        path.addCurve(to: point1, controlPoint1: cp01, controlPoint2: cp02)
        path.addCurve(to: point2, controlPoint1: cp11, controlPoint2: cp12)
        path.addCurve(to: point3, controlPoint1: cp21, controlPoint2: cp22)
        path.addCurve(to: point0, controlPoint1: cp31, controlPoint2: cp32)
        path.close()
        
        return path.cgPath
    }
    
    func animateToStartPosition() {
        let animation = CASpringAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.fromValue = ballLayer.path
        animation.toValue = configureBallLayerPath()
        animation.damping = 20
        animation.initialVelocity = 40
        animation.mass = 1
        animation.stiffness = 2000
        
        animation.duration = animation.settlingDuration
        
        ballLayer.add(animation, forKey: nil)
        ballLayer.path = configureBallLayerPath()
    }
}
