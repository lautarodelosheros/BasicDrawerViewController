//
//  LeftPushPresentationTransition.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

class LeftPushPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.25

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        let shadowView = UIView(frame: containerView.bounds)
        containerView.addSubview(shadowView)
        shadowView.tag = 1
        shadowView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        shadowView.backgroundColor = .black
        shadowView.alpha = 0
        
        containerView.addSubview(toView)
        toView.frame.origin = CGPoint(x: -toView.frame.width, y: 0)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            toView.frame.origin = .zero
            shadowView.alpha = 0.5
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
