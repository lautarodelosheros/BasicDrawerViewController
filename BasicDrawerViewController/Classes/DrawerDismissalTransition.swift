//
//  DrawerDismissalTransition.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

class DrawerDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        let fromView = transitionContext.view(forKey: .from)!

        containerView.addSubview(fromView)
        
        let shadowView = containerView.subviews.first(where: { $0.tag == 1 })

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            switch self.orientation {
            case .left:
                fromView.frame.origin = CGPoint(x: -fromView.frame.width, y: 0)
            case .right:
                fromView.frame.origin = CGPoint(x: fromView.frame.width, y: 0)
            case .top:
                fromView.frame.origin = CGPoint(x: 0, y: -fromView.frame.height)
            case .bottom:
                fromView.frame.origin = CGPoint(x: 0, y: fromView.frame.height)
            }
            shadowView?.alpha = 0
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
