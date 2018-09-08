//
//  ViewControllerExtensions.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

extension UIViewController {
    func transition(to child: UIViewController, duration: Double = 0.3, completion: ((Bool) -> Void)? = nil) {
        let current = childViewControllers.last
        addChildViewController(child)
        
        let newView = child.view!
        newView.translatesAutoresizingMaskIntoConstraints = true
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newView.frame = view.bounds
        let animation = UIViewAnimationOptions.transitionCrossDissolve
        if let existing = current {
            existing.willMove(toParentViewController: nil)
            
            transition(from: existing, to: child, duration: duration, options: [animation], animations: { }, completion: { done in
                existing.removeFromParentViewController()
                child.didMove(toParentViewController: self)
                completion?(done)
            })
            
        } else {
            view.addSubview(newView)
            
            UIView.animate(withDuration: duration, delay: 0, options: [animation], animations: { }, completion: { done in
                child.didMove(toParentViewController: self)
                completion?(done)
            })
        }
    }
    
    func display(_ child: UIViewController) {
        transition(to: child, duration: 0)
    }
}
