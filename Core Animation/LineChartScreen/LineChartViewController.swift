//
//  LineChartViewController.swift
//  Core Animation
//
//  Created by Евгений Бияк on 30.07.2022.
//

import UIKit

class LineChartViewController: UIViewController {

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var chartViewContainer: UIView!
    @IBOutlet weak var randomChartButton: UIButton!
    
    // MARK: - Properties
    
    let chartPadding: CGFloat = 20
    let gridStep: CGFloat = 30
    var availableWidth: CGFloat {
        chartViewContainer.bounds.width - 2 * chartPadding
    }
    var availableHeight: CGFloat {
        chartViewContainer.bounds.height - 2 * chartPadding
    }
    
    var chartLayer: CAShapeLayer!
    var axesLayer: CAShapeLayer!
    var horizontalGridLayer: CAReplicatorLayer!
    var verticalGridLayer: CAReplicatorLayer!
    
    var currentChart: [Int]?
    
    // MARK: - Life cycle and override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartLayer = configureChartLayer()
        chartViewContainer.layer.addSublayer(chartLayer)
        
        axesLayer = configureAxesLayer()
        chartViewContainer.layer.addSublayer(axesLayer)
        
        horizontalGridLayer = configureHorizontalGridLayer()
        chartViewContainer.layer.insertSublayer(horizontalGridLayer, below: chartLayer)
        
        verticalGridLayer = configureVerticalGridLayer()
        chartViewContainer.layer.insertSublayer(verticalGridLayer, below: chartLayer)
        
        currentChart = getRandomChart(count: 200)
    }
    
    override func viewDidLayoutSubviews() {
        axesLayer.path = configureAxesLayerPath()
        
        guard let gridItemH = horizontalGridLayer.sublayers?.first as? CAShapeLayer,
              let gridItemV = verticalGridLayer.sublayers?.first as? CAShapeLayer
        else { return }
        
        gridItemH.path = configureHorizontalGridItem()
        gridItemV.path = configureVerticalGridItem()
        
        buildGrid()
        
        if !randomChartButton.isHighlighted {
            updateChartView(with: currentChart)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    
    @IBAction func showRandomChart(_ sender: UIButton) {
        currentChart = getRandomChart(count: 200)
        updateChartView(with: currentChart)
    }
    
    // MARK: - Private helper methods
    
    private func configureChartLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.systemCyan.cgColor
        layer.lineWidth = 1
        layer.lineCap = .round
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 0
        return layer
    }
    
    private func configureAxesLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.systemGray2.cgColor
        layer.lineWidth = 1
        layer.path = configureAxesLayerPath()
        return layer
    }
    
    private func configureAxesLayerPath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: chartPadding, y: chartPadding))
        path.addLine(to: CGPoint(x: chartPadding, y: chartPadding + availableHeight))
        path.addLine(to: CGPoint(x: chartPadding + availableWidth, y: chartPadding + availableHeight))
        return path.cgPath
    }
    
    private func configureHorizontalGridLayer() -> CAReplicatorLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.systemGray4.cgColor
        layer.lineWidth = 0.2
        layer.path = configureHorizontalGridItem()
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.addSublayer(layer)
        return replicatorLayer
    }
    
    private func configureHorizontalGridItem() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: chartPadding, y: chartPadding + availableHeight - gridStep))
        path.addLine(to: CGPoint(x: chartPadding + availableWidth, y: chartPadding + availableHeight - gridStep))
        return path.cgPath
    }
    
    private func configureVerticalGridLayer() -> CAReplicatorLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.systemGray4.cgColor
        layer.lineWidth = 0.2
        layer.path = configureVerticalGridItem()
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.addSublayer(layer)
        return replicatorLayer
    }
    
    private func configureVerticalGridItem() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: chartPadding + gridStep, y: chartPadding))
        path.addLine(to: CGPoint(x: chartPadding + gridStep, y: chartPadding + availableHeight))
        return path.cgPath
    }
    
    private func buildGrid() {
        // ajust horizontal grid
        let instanceCountH = Int(availableHeight / gridStep)
        horizontalGridLayer.instanceCount = instanceCountH
        horizontalGridLayer.instanceTransform = CATransform3DMakeTranslation(0, -gridStep, 0)
        
        // ajust vertical grid
        let instanceCountV = Int(availableWidth / gridStep)
        verticalGridLayer.instanceCount = instanceCountV
        verticalGridLayer.instanceTransform = CATransform3DMakeTranslation(gridStep, 0, 0)
    }
    
    private func updateChartView(with chart: [Int]?) {
        guard let chart = chart, !chart.isEmpty else { return }
        
        let maxValue = chart.max()!
        let minValue = chart.min()!
        let valueRange = maxValue - minValue
        
        let xAxisStep = availableWidth / CGFloat(chart.count - 1)
        let yAxisStep = availableHeight / CGFloat(valueRange)
        
        // configure chart path
        let mappedChart = chart.enumerated().map { item -> CGPoint in
            let value = item.element
            let index = item.offset
            
            let x = chartPadding + xAxisStep * CGFloat(index)
            let y = chartPadding + yAxisStep * CGFloat(maxValue - value)
            
            return CGPoint(x: x, y: y)
        }
        
        let path = UIBezierPath()
        for (index, point) in mappedChart.enumerated() {
            index == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        
        chartLayer.path = path.cgPath
        animateChart(chart)
    }
    
    private func animateChart(_ chart: [Int]) {
        var pathAnimation = CABasicAnimation()
        
        if `switch`.isOn {
            pathAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            pathAnimation.duration = 0.5
            pathAnimation.fromValue = 0
            pathAnimation.toValue = 1
        } else {
            let xAxisStep = availableWidth / CGFloat(chart.count - 1)
            let pathFrom = UIBezierPath()
            for index in chart.indices {
                index == 0 ? pathFrom.move(to: CGPoint(x: chartPadding, y: chartPadding + availableHeight)) :
                pathFrom.addLine(to: CGPoint(x: chartPadding + xAxisStep * CGFloat(index), y: chartPadding + availableHeight))
            }
            
            pathAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
            pathAnimation.duration = 0.5
            pathAnimation.fromValue = pathFrom.cgPath
            pathAnimation.toValue = chartLayer.path
        }
        
        chartLayer.add(pathAnimation, forKey: nil)
    }
    
    private func getRandomChart(count: Int) -> [Int] {
        var chart = Array(repeating: 0, count: count)
        let percentage = 0.5
        for i in 0..<count {
            let randomValue = Double.random(in: percentage - 1 ... percentage) > 0 ? 1 : -1
            chart[i] = i == 0 ? randomValue : chart[i - 1] + randomValue
        }
        return chart
    }
}
