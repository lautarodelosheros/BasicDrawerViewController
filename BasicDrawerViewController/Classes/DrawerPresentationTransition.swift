//
//  DrawerPresentationTransition.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

class DrawerPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let orientation: BasicDrawerViewController.Orientation
    let duration: TimeInterval = 0.25
    
    init(orientation: BasicDrawerViewController.Orientation) {
        self.orientation = orientation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        toView.frame = containerView.frame
        
        let shadowView = UIView(frame: containerView.bounds)
        containerView.addSubview(shadowView)
        shadowView.tag = 1
        shadowView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        shadowView.backgroundColor = .black
        shadowView.alpha = 0
        
        containerView.addSubview(toView)
        switch orientation {
        case .left:
            toView.frame.origin = CGPoint(x: -toView.frame.width, y: 0)
        case .right:
            toView.frame.origin = CGPoint(x: toView.frame.width, y: 0)
        case .top:
            toView.frame.origin = CGPoint(x: 0, y: -toView.frame.height)
        case .bottom:
            toView.frame.origin = CGPoint(x: 0, y: toView.frame.height)
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            toView.frame.origin = .zero
            shadowView.alpha = 0.5
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
