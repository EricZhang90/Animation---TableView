//
//  ViewController.swift
//  EmitterLayer_and_UIView
//
//  Created by Lei zhang on 2017-10-18.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var bgImageView: UIImageView!
    
    @IBOutlet var summaryIcon: UIImageView!
    @IBOutlet var summary: UILabel!
    
    @IBOutlet var flightNr: UILabel!
    @IBOutlet var gateNr: UILabel!
    @IBOutlet var departingFrom: UILabel!
    @IBOutlet var arrivingTo: UILabel!
    @IBOutlet var planeImage: UIImageView!
    
    @IBOutlet var flightStatus: UILabel!
    @IBOutlet var statusBanner: UIImageView!
    
    var snowView: SnowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add snow view
        // a quarter of snowing
        snowView = SnowView(frame: CGRect(x: -10, y: -100, width: 300, height: 50))
        
        // this view is used to avoid snow view to cover the header(summary bar)
        let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snowView)
        view.addSubview(snowClipView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

