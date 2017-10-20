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
        
        addSnowView()
        
        changeFlight(to: londonToParis)
    }
    
    fileprivate func addSnowView() {
        // a quarter of snowing
        snowView = SnowView(frame: CGRect(x: -10, y: -150, width: 300, height: 50))
        
        // this view is used to avoid snow view to cover the header(summary bar)
        let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snowView)
        view.addSubview(snowClipView)
    }
}

// MARK: Helper
fileprivate extension ViewController {
    func delay(seconds: Double, completion: @escaping ()-> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    
    func duplicateLabel(label: UILabel) -> UILabel {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = label.backgroundColor
        return auxLabel
    }
}

// MARK: Animation
extension ViewController {
    func fade(toImage: UIImage, showEffects: Bool) {
        let overlayView = UIImageView(frame: bgImageView.frame)
        overlayView.image = toImage
        overlayView.alpha = 0.0
        overlayView.center.y += 20
        overlayView.bounds.size.width = overlayView.bounds.size.width * 1.3
        // insert overlayView between background and sumary bar
        bgImageView.superview?.insertSubview(overlayView, aboveSubview: bgImageView)
        
        // fade in
        UIView.animate(
            withDuration: 0.5, animations: {
                overlayView.alpha = 1.0
                overlayView.center.y -= 20
                overlayView.bounds.size.width = overlayView.bounds.size.width / 1.3
        }) { (_) in
            self.bgImageView.image = toImage
            overlayView.removeFromSuperview()
        }
        
        // show/hide show view
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: {
                self.snowView.alpha = showEffects ? 1.0 : 0.0
        })
    }
    
    func moveLabel(label: UILabel, text: String, offset: CGPoint) {
        // create a helper label, set up transform and make it invisible
        let auxLabel = duplicateLabel(label: label)
        auxLabel.text = text
        auxLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
        auxLabel.alpha = 0.0
        view.addSubview(auxLabel)
        
        // fade real label out and translate it
        UIView.animate(
            withDuration: 0.7,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                label.alpha = 0.0
                label.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
        })
        
        // fade the hleper label in and translate it
        UIView.animate(
            withDuration: 0.25,
            delay: 0.825,
            options: .curveEaseIn,
            animations: {
                auxLabel.transform = .identity
                auxLabel.alpha = 1.0
        }) { (_) in
            // update real label
            label.text = text
            label.alpha = 1.0
            label.transform = .identity
            
            // remove the helper label
            auxLabel.removeFromSuperview()
        }
    }
    
    func cubeTransition(label: UILabel, text: String) {
        let auxLabel = duplicateLabel(label: label)
        auxLabel.text = text
        
        let auxLabelOffset = label.frame.size.height/2.0
        
        let scale = CGAffineTransform(scaleX: 1.0, y: 0.1)
        
        let translate = CGAffineTransform(translationX: 0.0, y: auxLabelOffset)
        
        auxLabel.transform = scale.concatenating(translate)
        
        label.superview?.addSubview(auxLabel)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                auxLabel.transform = .identity
                label.transform = scale.concatenating(translate.inverted())
        }) {_ in
            label.text = text
            label.transform = .identity
            
            auxLabel.removeFromSuperview()
        }
    }
    
    func planeDepart() {
        let originalCenter = planeImage.center
        
        UIView.animateKeyframes(
            withDuration: 1.5,
            delay: 0.0,
            animations: {
                // take off the plan
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.25,
                    animations: {
                        self.planeImage.center.x += 80.0
                        self.planeImage.center.y -= 10.0
                })
                
                // roate the plane
                UIView.addKeyframe(
                    // percentage of overrall animation start time (10%)
                    withRelativeStartTime: 0.1,
                    // percentage of over the animation time
                    relativeDuration: 0.4,
                    animations: {
                        self.planeImage.transform = CGAffineTransform(rotationAngle: -.pi/8)
                })
                
                // move the plane to right up off screen
                UIView.addKeyframe(
                    withRelativeStartTime: 0.25,
                    relativeDuration: 0.25,
                    animations: {
                        self.planeImage.center.x += 100.0
                        self.planeImage.center.y -= 50.0
                        self.planeImage.alpha = 0
                })
                
                // move the plane to left side of screen in order to make the landing animation below
                UIView.addKeyframe(
                    withRelativeStartTime: 0.51,
                    relativeDuration: 0.01,
                    animations: {
                        self.planeImage.transform = .identity
                        self.planeImage.center = CGPoint(x: 0.0, y: originalCenter.y)
                })
                
                // landing. move the plane back to original postion
                UIView.addKeyframe(
                    withRelativeStartTime: 0.55,
                    relativeDuration: 0.45,
                    animations: {
                        self.planeImage.alpha = 1.0
                        self.planeImage.center = originalCenter
                })
        })
    }
    
    
    func summarySwitch(to summaryText: String) {
        
        // change to new summary status in the middle of below animation
        delay(seconds: 0.5) {
            self.summary.text = summaryText
        }
        
        UIView.animateKeyframes(
            withDuration: 1.0,
            delay: 0.0,
            animations: {
                
                // move summary text out of screen
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.45,
                animations: {
                    self.summary.center.y -= 100.0
                })
                
                
                
                // move the next summary status back
                UIView.addKeyframe(
                    withRelativeStartTime: 0.5,
                    relativeDuration: 0.45,
                    animations: {
                        self.summary.center.y += 100.0
                })
        })
    }
}


// MARK: flight operation
extension ViewController {
    func changeFlight(to data: FlightData, animated: Bool = false) {
        
        
        flightNr.text = data.flightNr
        gateNr.text = data.gateNr
        departingFrom.text = data.departingFrom
        
        
        if animated {
            fade(toImage: UIImage(named: data.weatherImageName)!, showEffects: data.showWeatherEffects)
            
            let offsetDeparting = CGPoint(x: -80.0, y: 0.0)
            
            let offsetArriving = CGPoint(x: 80.0, y: 0.0)
            
            moveLabel(label: departingFrom, text: data.departingFrom, offset: offsetDeparting)
            
            moveLabel(label: arrivingTo, text: data.arrivingTo, offset: offsetArriving)
            
            cubeTransition(label: flightStatus, text: data.flightStatus)
            
            planeDepart()
            
            summarySwitch(to: data.summary)
        }
        else {
            bgImageView.image = UIImage(named: data.weatherImageName)
            snowView.isHidden = !data.showWeatherEffects
            
            arrivingTo.text = data.arrivingTo
            flightStatus.text = data.flightStatus
            
            flightStatus.text = data.flightStatus
            
            summary.text = data.summary
        }
        
        // schedule next flight
        delay(seconds: 3.0) {
            self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis, animated: true)
        }
    }
}








