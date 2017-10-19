//
//  ShowEmitterLayer.swift
//  EmitterLayer_and_UIView
//
//  Created by Lei zhang on 2017-10-18.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class SnowEmitterLayer: CAEmitterLayer {
    
    func setup(rect: CGRect) {
        emitterPosition = CGPoint(x: rect.size.width/2.0, y: 0)
        emitterSize = rect.size
        emitterShape = kCAEmitterLayerRectangle
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
