//
//  SnowView.swift
//  EmitterLayer_and_UIView
//
//  Created by Lei zhang on 2017-10-18.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class SnowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let snowLayer = layer as! SnowEmitterLayer
        snowLayer.setup(rect: bounds)
        snowLayer.emitterCells = [SnowEmitterCell()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return SnowEmitterLayer.self
    }
}
