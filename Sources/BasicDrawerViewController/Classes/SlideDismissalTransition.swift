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
    private let transitionViewTags: [Int]
    private var snapshotViews: [UIView] = []
    private let duration: TimeInterval
    public var interactionController: SlideDismissInteractionController? = nil
    
    private var pushOffset: CGFloat {
        if case let .push(offset) = transitionAnimation {
            return offset
        } else {
            return 0
        }
    }
    
    public init(
        orientation: BasicDrawerViewController.Orientation,
        transitionAnimation: BasicDrawerViewController.TransitionAnimation,
        transitionViewTags: [Int] = [],
        duration: TimeInterval
    ) {
        self.duration = duration
        self.orientation = orientation
        self.transitionAnimation = transitionAnimation
        self.transitionViewTags = transitionViewTags
        super.init()
    }

    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromView = transitionContext.view(forKey: .from)
        else {
            return
        }
        let containerView = transitionContext.containerView

        if transitionContext.presentationStyle == .none {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame.origin = calculatePushOrigin(for: toViewController.view)
        }
        containerView.addSubview(fromView)
        
        snapshotViews = createSnapshotViews(tags: transitionViewTags, transitionContext: transitionContext)
        
        let shadowView = containerView.subviews.first(where: { $0.tag == 1 })
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            fromView.frame.origin = self.calculateOrigin(for: fromView)
            shadowView?.alpha = 0
            switch self.transitionAnimation {
            case .zoom:
                toViewController.view.layer.cornerRadius = 0
                toViewController.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                toViewController.view.frame = toViewController.view.window?.frame ?? UIScreen.main.bounds
            case .push:
                toViewController.view.frame.origin = self.calculateDestinationOrigin(for: toViewController.view)
            case .none:
                break
            }
        }, completion: { [self] _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            removeSnapshotViews(tags: transitionViewTags, snapshotViews: snapshotViews, transitionContext: transitionContext)
        })
    }
    
    private func calculateOrigin(for view: UIView) -> CGPoint {
        switch self.orientation {
        case .left:
            CGPoint(x: -view.frame.width, y: view.frame.origin.y)
        case .right:
            CGPoint(x: view.frame.width, y: view.frame.origin.y)
        case .top:
            CGPoint(x: view.frame.origin.x, y: -view.frame.height)
        case .bottom:
            CGPoint(x: view.frame.origin.x, y: view.frame.height)
        }
    }
    
    private func calculatePushOrigin(for view: UIView) -> CGPoint {
        switch self.orientation {
        case .left:
            CGPoint(x: pushOffset, y: view.frame.origin.y)
        case .right:
            CGPoint(x: -pushOffset, y: view.frame.origin.y)
        case .top:
            CGPoint(x: view.frame.origin.x, y: pushOffset)
        case .bottom:
            CGPoint(x: view.frame.origin.x, y: -pushOffset)
        }
    }
    
    private func calculateDestinationOrigin(for view: UIView) -> CGPoint {
        switch self.orientation {
        case .left:
            CGPoint(x: 0, y: view.frame.origin.y)
        case .right:
            CGPoint(x: 0, y: view.frame.origin.y)
        case .top:
            CGPoint(x: view.frame.origin.x, y: 0)
        case .bottom:
            CGPoint(x: view.frame.origin.x, y: 0)
        }
    }
}
