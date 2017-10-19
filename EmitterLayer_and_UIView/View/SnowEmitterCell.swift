//
//  SnowEmitterCell.swift
//  EmitterLayer_and_UIView
//
//  Created by Lei zhang on 2017-10-18.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class SnowEmitterCell: CAEmitterCell {
    override init() {
        super.init()
        
        contents = UIImage(named: "flake.png")!.cgImage
        birthRate = 200
        lifetime = 3.5
        color = UIColor.white.cgColor
        redRange = 0.0
        blueRange = 0.1
        greenRange = 0.0
        velocity = 10
        velocityRange = 350
        emissionRange = CGFloat(Double.pi / 2)
        emissionLongitude = CGFloat(-(Double.pi / 2))
        yAcceleration = 70
        xAcceleration = 0
        scale = 0.33
        scaleRange = 1.25
        scaleSpeed = -0.25
        alphaRange = 0.5
        alphaSpeed = -0.15
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
