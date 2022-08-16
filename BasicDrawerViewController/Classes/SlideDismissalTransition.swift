//
//  SlideDismissalTransition.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

public class SlideDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let orientation: BasicDrawerViewController.Orientation
    private let duration: TimeInterval
    private let restoresZoom: Bool
    
    public init(orientation: BasicDrawerViewController.Orientation, duration: TimeInterval, restoresZoom: Bool = false) {
        self.duration = duration
        self.orientation = orientation
        self.restoresZoom = restoresZoom
        super.init()
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to)
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
            if self.restoresZoom {
                let view = toViewController?.view
                view?.layer.cornerRadius = 0
                view?.transform = CGAffineTransform(scaleX: 1, y: 1)
                view?.frame = view?.window?.frame ?? UIScreen.main.bounds
            }
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
