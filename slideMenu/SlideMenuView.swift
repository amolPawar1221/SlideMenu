//
//  SlideMenuView.swift
//  slideMenu
//
//  Created by Amol Pawar Software on 06/01/18.
//  Copyright © 2018 Amol Pawar Software. All rights reserved.
//

import UIKit

protocol SlideMenu{}
extension SlideMenu where Self : UIViewController {
    func addSlideMenu()->UIViewController?{
        
        if let view = self.view.viewWithTag(101){
            let backGroundView = self.view.viewWithTag(103)
            if view.frame.origin.x == 0{
                 UIView.animate(withDuration: 0.3, animations: {
                    backGroundView?.alpha = 0.6
                    view.alpha = 1
                 })
                return nil
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
               backGroundView?.alpha = 0.6
               view.alpha = 1
            })
            return nil
        }
        
        let slideMenuVC = storyboard?.instantiateViewController(withIdentifier: "SlideMenuView") as! SlideMenuView
        _ = slideMenuVC.view
        slideMenuVC.view.alpha = 0
        slideMenuVC.view.tag = 101
        slideMenuVC.backGroundView.tag = 102
        self.addChildViewController(slideMenuVC)
        self.view.addSubview(slideMenuVC.view)
        slideMenuVC.didMove(toParentViewController: self)
        slideMenuVC.view.frame = CGRect(x: -UIScreen.main.bounds.width * 0.75, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return slideMenuVC
    }
}

extension UIViewController:SlideMenu{}

class SlideMenuView:UIViewController{
    
    @IBOutlet var backGroundView:UIView!
    @IBOutlet var menuView:UIView!
    
    var preSelectedIndexPath:IndexPath?
    
    var vcList = ["Home","Profile","Setting","Contact","About Us","LogOut"]
    let arrayOfVC: [UIViewController.Type] = [
        HomeViewController.self,ProfileViewController.self, SettingViewController.self,ContactViewController.self,AboutUsViewController.self
    ]
    
    override func viewDidLoad() {
        dropShadow()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeVC()
    }
    fileprivate func removeVC(){
        UIView.animate(withDuration: 0.3, animations: {
            //self.backGroundView.alpha = 0
            self.view.alpha = 0
            self.view.backgroundColor = .clear
            self.view.frame = CGRect(x: -UIScreen.main.bounds.width * 0.75, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        })
    }
    func dropShadow() {
        
        menuView.layer.masksToBounds = false
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.8
        menuView.layer.shadowOffset = CGSize(width: -1, height: 1)
        menuView.layer.shadowRadius = 20
        
        menuView.layer.shadowPath = UIBezierPath(rect: menuView.bounds).cgPath
        menuView.layer.shouldRasterize = true
        menuView.layer.rasterizationScale = UIScreen.main.scale
        
    }
}

extension SlideMenuView:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = vcList[indexPath.row]
        cell.textLabel?.highlightedTextColor = .red
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func getControllerFromString(row:Int)->UIViewController? {
        if row < arrayOfVC.count{
             return storyboard?.instantiateViewController(withIdentifier: String(describing: arrayOfVC[row]))
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        removeVC()
        
            if let controller = self.navigationController?.visibleViewController{
                guard let viewcontroller = getControllerFromString(row: indexPath.row) else {
                    return
                }
                if !controller.isKind(of: arrayOfVC[indexPath.row].self){
                    let vc = self.navigationController?.getControllerFromStack(arrayOfVC[indexPath.row].self)
                    if let control = vc {
                        // move it
                        _ = self.navigationController?.popViewControllerLikePushAnimation(control)
                    } else {
                        _ = viewcontroller.view
                        self.navigationController?.pushViewController(viewcontroller, animated: true)
                    }
                }
            }
    }
}

extension UINavigationController{
    ///needs to set animation property to false to make animation like push for pop method
    func popViewControllerLikePushAnimation(_ controller:UIViewController)->[UIViewController]?{
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.add(transition, forKey: nil)
       return self.popToViewController(controller, animated: false)
    }
    /// get the controller from stack by controller type(i.e ViewController.self) if present its return viewcontroller object its optional
    func getControllerFromStack(_ controllerType:UIViewController.Type)-> UIViewController?{
        let arrayOfController = self.viewControllers
        for controller in arrayOfController {
            if controller.isKind(of: controllerType){
                return controller
            }
        }
        return nil;
    }
}
