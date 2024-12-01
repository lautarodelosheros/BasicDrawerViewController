//
//  SlideDismissalTransition.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation
import UIKit

public class SlideDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let orientation: BasicDrawerViewController.Orientation
    private let transitionAnimation: BasicDrawerViewController.TransitionAnimation
    private let duration: TimeInterval
    public var interactionController: SlideDismissInteractionController? = nil
    
    public init(
        orientation: BasicDrawerViewController.Orientation,
        transitionAnimation: BasicDrawerViewController.TransitionAnimation,
        duration: TimeInterval
    ) {
        self.duration = duration
        self.orientation = orientation
        self.transitionAnimation = transitionAnimation
        super.init()
    }

    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)!

        containerView.addSubview(fromView)
        
        let shadowView = containerView.subviews.first(where: { $0.tag == 1 })
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            fromView.frame.origin = self.calculateOrigin(for: fromView)
            shadowView?.alpha = 0
            switch self.transitionAnimation {
            case .zoom:
                toViewController?.view.layer.cornerRadius = 0
                toViewController?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                toViewController?.view.frame = toViewController?.view.window?.frame ?? UIScreen.main.bounds
            case .push:
                toViewController?.view.frame.origin = .zero
            case .none:
                break
            }
        }, completion: { completed in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func calculateOrigin(for view: UIView) -> CGPoint {
        switch self.orientation {
        case .left:
            CGPoint(x: -view.frame.width, y: 0)
        case .right:
            CGPoint(x: view.frame.width, y: 0)
        case .top:
            CGPoint(x: 0, y: -view.frame.height)
        case .bottom:
            CGPoint(x: 0, y: view.frame.height)
        }
    }
}
