//
//  SparkParticlesViewController.swift
//  Core Animation
//
//  Created by Евгений Бияк on 02.08.2022.
//

import UIKit

class SparkParticlesViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    
    let emitter = CAEmitterLayer()
    let cell = CAEmitterCell()
    
    // MARK: - Life cycle and override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup emitter layer
        emitter.renderMode = .additive
        emitter.frame = canvasView.bounds
        canvasView.layer.addSublayer(emitter)
        
        // setup canvasView
        canvasView.delegate = self
        canvasView.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    
    @objc private func didTouchUpInside() {
        emitter.emitterPosition = CGPoint(x: canvasView.bounds.width * 2, y: canvasView.bounds.height * 2)
    }
}

extension SparkParticlesViewController: CanvasViewDelegate {
    func canvasView(_ canvasView: CanvasView, touchMovedAtPoint point: CGPoint, from previousPoint: CGPoint) {
        emitter.emitterPosition = point
        
        //create a particle template
        cell.contents = UIImage(named: "spark1.png")!.cgImage
        cell.scale = 0.007
        cell.birthRate = 1000
        cell.lifetime = 3
        // alpha -= 0.5 (per second)
        cell.alphaSpeed = -0.5
        cell.velocity = 100
        cell.velocityRange = 200
        cell.emissionRange = .pi / 8
        cell.emissionLongitude = 2 * .pi * point.angle(to: previousPoint) / 360

        //add particle template to emitter
        emitter.emitterCells = [cell]
        
    }
}
