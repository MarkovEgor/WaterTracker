//
//  CircularView.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//

import Foundation
import UIKit

class CircularProgressView: UIView {
    
    //MARK: - IBInspectable
    @IBInspectable public var backgroundLayerColor: UIColor = UIColor.lightGray
    @IBInspectable public var startGradientColor: UIColor = UIColor.blue
    @IBInspectable public var endGradientColor: UIColor = UIColor.red
    @IBInspectable public var textColor: UIColor = UIColor.white
    
    //MARK: - Propirties
    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer: CAShapeLayer!
    private var textLayerNumber: CATextLayer!
    private var textLayerMl: CATextLayer!
    private var gradientLayer: CAGradientLayer!
    
    
    var progress: CGFloat = 0 {
        didSet {
            didProgressLayer()
        }
    }
    
    
    //MARK: - Func
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let lineWidth = 0.1 * min(width, height)
        
        guard layer.sublayers == nil else {
            return
        }
        
        backgroundLayer = createCircularLayer(rect: rect, strokeColor: backgroundLayerColor.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        foregroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.blue.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.colors = [startGradientColor.cgColor, UIColor.orange.cgColor, endGradientColor.cgColor]
        gradientLayer.frame = rect
        gradientLayer.mask = foregroundLayer
        
        textLayerNumber = createTextLayer(rect: rect, textColor: textColor.cgColor)
        textLayerMl = createTextLayerMl(rect: rect, textColor: textColor.cgColor)
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
        layer.addSublayer(textLayerNumber)
        layer.addSublayer(textLayerMl)
    }
    
    private func createCircularLayer(rect: CGRect , strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat ) -> CAShapeLayer {
        let width = rect.width
        let height = rect.height
        
        let lineWidth = 0.03 * min(width, height)
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2.5
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = 3 * CGFloat.pi / 2
        
        let circulaPach = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circulaPach.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        return shapeLayer
    }
    
    
    
    private func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        
        let width = rect.width
        let height = rect.height
        
        let fontSize = min(width, height) / 4
        let offset = min(width, height) * 0.1
        
        let textLayer = CATextLayer()
        textLayer.string = "\(Int(progress * 100))"
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = textColor
        textLayer.fontSize = fontSize
        textLayer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2, width: width, height: fontSize + offset)
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        
        return textLayer
    }
    
    private func createTextLayerMl(rect: CGRect, textColor: CGColor) -> CATextLayer {
        
        let width = rect.width
        let height = rect.height
        
        let fontSize = min(width, height) / 8
        let offset = min(width, height) * 0.3
        
        let textLayer = CATextLayer()
        textLayer.string = "\(Int(progress * 100))"
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = textColor
        textLayer.fontSize = fontSize
        textLayer.frame = CGRect(x: 0, y: (height - fontSize - offset), width: width, height: fontSize + offset)
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        
        return textLayer
    }
    
    private func didProgressLayer() {
        textLayerNumber?.string = "\(Int(progress * 100))"
        textLayerMl.string = "ml"
        foregroundLayer?.strokeEnd = progress / 100
    }
    
    
}
