//
//  CounterViewController.swift
//  Core Animation
//
//  Created by Евгений Бияк on 30.07.2022.
//

import UIKit
@IBDesignable
class CounterViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    var backgroundLayer: CAShapeLayer?
    var progressLayer: CAShapeLayer?
    
    var startTime: CFTimeInterval?
    var endTime: CFTimeInterval?
    var duration: CGFloat = 0.66
    
    var displayLink: CADisplayLink?
    
    var currentRandomValue: CGFloat!
    
    var getRandomValue: () -> CGFloat = {
        CGFloat(Double.random(in: 0...1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundLayer = configureBackgroundLayer()
        progressView.layer.addSublayer(backgroundLayer!)
        
        progressLayer = configureProgressLayer()
        progressView.layer.insertSublayer(progressLayer!, above: backgroundLayer!)
    }
    
    override func viewDidLayoutSubviews() {
        backgroundLayer?.path = configureBackgroundLayerPath()
        progressLayer?.path = configureProgressLayerPath()
    }
    
    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    private func configureBackgroundLayer() -> CAShapeLayer {
        let backgroundLayer = CAShapeLayer()
        
        backgroundLayer.path = configureBackgroundLayerPath()
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 10
        backgroundLayer.lineCap = .round
        
        return backgroundLayer
    }
    
    private func configureBackgroundLayerPath() -> CGPath {
        return UIBezierPath(
            arcCenter: CGPoint(x: progressView.bounds.height / 2, y: progressView.bounds.height / 2),
            radius: progressView.bounds.height / 2,
            startAngle: 3 * .pi / 4,
            endAngle: .pi / 4,
            clockwise: true
        ).cgPath
    }
    
    private func configureProgressLayer() -> CAShapeLayer {
        let progressLayer = CAShapeLayer()
        
        progressLayer.path = configureProgressLayerPath()
        progressLayer.strokeColor = nil
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 10
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        
        return progressLayer
    }
    
    private func configureProgressLayerPath() -> CGPath {
        return UIBezierPath(
            arcCenter: CGPoint(x: progressView.bounds.height / 2, y: progressView.bounds.height / 2),
            radius: progressView.bounds.height / 2,
            startAngle: 3 * .pi / 4,
            endAngle: .pi / 4,
            clockwise: true
        ).cgPath
    }
    
    @IBAction func showRandom(_ sender: UIButton) {
        currentRandomValue = getRandomValue()
        
        let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = currentRandomValue
        strokeEndAnimation.duration = duration
        
        progressLayer?.strokeEnd = currentRandomValue
        progressLayer?.add(strokeEndAnimation, forKey: nil)
        
        let fromColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        let toColor = UIColor(red: (1 - currentRandomValue) * 1, green: currentRandomValue * 1, blue: 0, alpha: 1).cgColor
        
        let strokeColorAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeColor))
        strokeColorAnimation.fromValue = fromColor
        strokeColorAnimation.toValue = toColor
        strokeColorAnimation.duration = duration
        
        progressLayer?.strokeColor = toColor
        progressLayer?.add(strokeColorAnimation, forKey: nil)
        
        startTime = CACurrentMediaTime()
        endTime = duration + startTime!
        
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(updateHandler))
            // set mode to .common don't stops timer when user drags scrollView
            displayLink?.add(to: .main, forMode: .common)
        } else {
            displayLink?.isPaused = false
        }
    }
    
    @objc private func updateHandler() {
        guard let startTime = startTime,
              let endTime = endTime
        else { return }
        
        if CACurrentMediaTime() >= endTime {
            displayLink?.isPaused = true
            progressLabel.text = String(format: "%.0f", currentRandomValue * 100)
        } else {
            let duration = endTime - startTime
            let elapsedTime = CACurrentMediaTime() - startTime
            let percentage = elapsedTime / duration
            progressLabel.text = String(format: "%.0f", percentage * currentRandomValue * 100)
        }
    }
}
