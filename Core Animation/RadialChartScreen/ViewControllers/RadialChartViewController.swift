//
//  RadialChartViewController.swift
//  Core Animation
//
//  Created by Евгений Бияк on 31.07.2022.
//

import UIKit

class RadialChartViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var pacLabel: UILabel!
    @IBOutlet weak var shoLabel: UILabel!
    @IBOutlet weak var driLabel: UILabel!
    @IBOutlet weak var pasLabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var phyLabel: UILabel!
    
    @IBOutlet weak var chartContainerView: UIView!
    
    @IBOutlet var controlButtons: [UIButton]!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    // MARK: - Properties
    
    let containerPadding: CGFloat = 33
    
    var animationTimer = Timer()
    
    var axesLayer: CAReplicatorLayer!
    var chartLayer: CAShapeLayer!
    
    var players = Player.getTestPlayers()
    var currentPlayer: Player? { players.first }
    
    // MARK: - Life cycle and override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartLayer = configureChartLayer()
        chartContainerView.layer.addSublayer(chartLayer)
        
        axesLayer = configureAxesLayer()
        chartContainerView.layer.addSublayer(axesLayer)
        
    }
    
    override func viewDidLayoutSubviews() {
        guard let axisLayer = axesLayer.sublayers?.first as? CAShapeLayer else { return }
        axisLayer.path = configureAxisPath()
        
        axesLayer.frame = chartContainerView.bounds
        
        if controlButtons.allSatisfy({ !$0.isHighlighted }) {
            showCharacteristics(forPlayer: currentPlayer)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        guard players.count > 1 else { return }
        players.insert(players.removeLast(), at: 0)
        showCharacteristics(forPlayer: currentPlayer)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard players.count > 1 else { return }
        players.append(players.removeFirst())
        showCharacteristics(forPlayer: currentPlayer)
    }
    
    // MARK: - Helper methods
    
    private func configureChartLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.systemCyan.withAlphaComponent(0.3).cgColor
        layer.strokeColor = UIColor.systemCyan.cgColor
        layer.lineWidth = 1
        layer.lineCap = .round
        return layer
    }
    
    private func configureAxesLayer() -> CAReplicatorLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.systemGray4.cgColor
        layer.lineWidth = 0.3
        layer.path = configureAxisPath()
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = chartContainerView.bounds
        replicatorLayer.instanceCount = 6
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(.pi / 3, 0, 0, 1)
        replicatorLayer.addSublayer(layer)
        return replicatorLayer
    }
    
    private func configureAxisPath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: chartContainerView.bounds.center)
        path.addLine(to: CGPoint(x: chartContainerView.bounds.width - containerPadding,
                                 y: chartContainerView.bounds.center.x))
        return path.cgPath
    }
    
    private func showCharacteristics(forPlayer player: Player?) {
        guard let player = player else { return }
        
        nameLabel.text = player.name
        pacLabel.text = "\(player.pace)"
        shoLabel.text = "\(player.shooting)"
        driLabel.text = "\(player.dribbling)"
        pasLabel.text = "\(player.passing)"
        defLabel.text = "\(player.defending)"
        phyLabel.text = "\(player.physical)"
        
        let path = calculatePath(forPlayer: player)
        
        animateChart(path)
    }
    
    private func animateChart(_ path: CGPath) {
        animationTimer.invalidate()
        
        if `switch`.isOn {
            // growing animation
            let duration = 0.33
            let durationHide: TimeInterval = chartLayer.path == nil ? 0.0 : duration / 2.0
            let animationHide = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            animationHide.duration = durationHide
            animationHide.fromValue = 1
            animationHide.toValue = 0
            
            let durationShow: TimeInterval = duration / 2.0
            let animationShow = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            animationShow.duration = durationShow
            animationShow.fromValue = 0
            animationShow.toValue = 1
            
            // clear fill collor
            chartLayer.fillColor = UIColor.clear.cgColor
            // set strokeEnd to start position
            chartLayer.strokeEnd = 0
            // add hide animation
            chartLayer.add(animationHide, forKey: nil)
            
            animationTimer = Timer.scheduledTimer(withTimeInterval: durationHide, repeats: false) { _ in
                // update path
                self.chartLayer.path = path
                // add show animation
                self.chartLayer.add(animationShow, forKey: nil)
                
                Timer.scheduledTimer(withTimeInterval: durationShow, repeats: false) { _ in
                    // set strokeEnd to end position
                    self.chartLayer.strokeEnd = 1
                    // set fill collor
                    self.chartLayer.fillColor = UIColor.systemCyan.withAlphaComponent(0.3).cgColor
                }
            }
        } else {
            // rising animation
            let pathFrom = UIBezierPath()
            pathFrom.move(to: chartContainerView.bounds.center)
            pathFrom.addLine(to: chartContainerView.bounds.center)
            
            let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
            animation.fromValue = pathFrom.cgPath
            animation.toValue = path
            animation.duration = 0.33
            
            chartLayer.path = path
            chartLayer.add(animation, forKey: "keyForThisAnimation")
        }
    }
    
    private func calculatePath(forPlayer player: Player) -> CGPath {
        let zero = chartContainerView.bounds.center
        let alpha: CGFloat = 360.0 / 6.0
        let sinAlpha = sin(alpha.radians)
        let cosAlpha = cos(alpha.radians)
        let scaleCoeff = (zero.x - containerPadding) / 100
        
        let characteristics = [player.pace,
                            player.shooting,
                            player.dribbling,
                            player.passing,
                            player.defending,
                            player.physical]
        
        let scaled = characteristics.map { CGFloat($0) * scaleCoeff }
        
        let point1 = CGPoint(x: zero.x + scaled[0], y: zero.y)
        let point2 = CGPoint(x: zero.x + cosAlpha * scaled[1], y: zero.y + sinAlpha * scaled[1])
        let point3 = CGPoint(x: zero.x - cosAlpha * scaled[2], y: zero.y + sinAlpha * scaled[2])
        let point4 = CGPoint(x: zero.x - scaled[3], y: zero.y)
        let point5 = CGPoint(x: zero.x - cosAlpha * scaled[4], y: zero.y - sinAlpha * scaled[4])
        let point6 = CGPoint(x: zero.x + cosAlpha * scaled[5], y: zero.y - sinAlpha * scaled[5])
        
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addLine(to: point6)
        path.close()
        return path.cgPath
    }
}
