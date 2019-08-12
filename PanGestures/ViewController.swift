//
//  ViewController.swift
//  PanGestures
//
//  Created by ted diepenbrock on 8/11/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var trashImageView: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    
    
    var fileViewOrigin: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPanGesture(view: fileImageView)
        // origin is upper left hand corner
        fileViewOrigin = fileImageView.frame.origin
        view.bringSubviewToFront(fileImageView)
    }
    
    
    // reset view and images to original state
    @IBAction func retryPressed(_ sender: Any) {
        
        returnViewToOrigin(view: fileImageView)
        
        UIView.animate(withDuration: 0.3) {
            self.fileImageView.alpha = 1.0
        }
        
        trashImageView.image = UIImage(named: "trashbin")
    }
    


    func addPanGesture(view: UIView) {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector (ViewController.handlePan(sender:)))
        
        view.addGestureRecognizer(pan)
    }
    
    // Refactor
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        // sender is UIPan gesture recognizer
        // is attached to fileImageView
        // view is main view of the screen
        let fileView = sender.view!

        
        // 3 main states gesture can be in
        // begin state: start of gesture
        // change statue: tracks every movement throughout the gesture
        // ended state: user lifts up finger
        
        switch sender.state {
            
        // move center of file view along with gesture recognizer
        case .began, .changed:
            moveViewWithPan(view: fileView, sender: sender)
        // check if fileImageView is intersecting trashcan view
        case .ended:
            if fileView.frame.intersects(trashImageView.frame) {
                deleteView(view: fileView)
            } else {
                returnViewToOrigin(view: fileView)
            }

        default:
            break
        }
    }
    
    
    //
    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    // return view to origin if user lets go of fileViewImage and if not over trashcan image
    func returnViewToOrigin(view: UIView) {
            
        view.frame.origin = self.fileViewOrigin
    }
    
    // if fileImageView intersects trashImageView, delete fileImageView from view
    func deleteView(view: UIView) {
        
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0.0
        }
        
        trashImageView.image = UIImage(named: "trashbinfull")
        
    }
    
}

