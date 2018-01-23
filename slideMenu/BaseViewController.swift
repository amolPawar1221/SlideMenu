//
//  BaseViewController.swift
//  slideMenu
//
//  Created by Amol Pawar Software on 06/01/18.
//  Copyright © 2018 Amol Pawar Software. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {
    private var slideMenuVC:SlideMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(BaseViewController.pan(recognizer:)));
        pan.edges = [.left]
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
         addSlideMenuView()
    }
    
    @objc private func pan(recognizer:UIScreenEdgePanGestureRecognizer) {
        switch (recognizer.state) {
        case .began:
            break
        case .changed:
            if(slideMenuVC.view.frame.origin.x >= 0){
                setSlideViewFrame(originX:0)
                slideMenuVC.view.alpha = 1
                return
            }
            let translation = recognizer.translation(in: self.view)
            
           let xValue = slideMenuVC.view.frame.origin.x + translation.x
           DispatchQueue.main.async {
             self.slideMenuVC.view.alpha = 1
             self.slideMenuVC.backGroundView.alpha = min(0.6, 1 - (-xValue/280))
            }
            setSlideViewFrame(originX: xValue)
            recognizer.setTranslation(.zero, in: self.view)
            break
        case .cancelled,.ended:
            if slideMenuVC.view.frame.origin.x == 0 {
                return
            }
            let checkWidth = ((UIScreen.main.bounds.width * 0.75) + slideMenuVC.view.frame.origin.x);
            
            if checkWidth > (UIScreen.main.bounds.width * 0.65) / 2 {
                setSlideViewFrame(originX: 0)
                slideMenuVC.view.alpha = 1
            }else {
                setSlideViewFrame(originX: -UIScreen.main.bounds.width * 0.75)
                slideMenuVC.view.alpha = 0
            }
            break;
        default: break
        }
    }
    private func setSlideViewFrame(originX:CGFloat){
        let newFrame = CGRect(x: originX, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        slideMenuVC.view.frame = newFrame
    }
   private func addSlideMenuView(){
        if let vc = self.addSlideMenu(){
            slideMenuVC = vc as! SlideMenuView
        }
    }
    public func menuAction(_ sender: Any) {
        addSlideMenuView()
    }
    
}

