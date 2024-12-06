//
//  SlidePresentationTransition.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation
import UIKit

public class SlidePresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private weak var fromViewController: UIViewController?
    private var shadowView: UIView?
    private let shadowAlpha: CGFloat
    
    private let orientation: BasicDrawerViewController.Orientation
    private let transitionAnimation: BasicDrawerViewController.TransitionAnimation
    private let duration: TimeInterval
    
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
        duration: TimeInterval,
        shadowAlpha: CGFloat = 0.6
    ) {
        self.orientation = orientation
        self.transitionAnimation = transitionAnimation
        self.duration = duration
        self.shadowAlpha = shadowAlpha
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else {
            return
        }
        self.fromViewController = fromViewController
        let containerView = transitionContext.containerView
        
        toView.frame = containerView.frame
        
        let shadowView = UIView(frame: containerView.bounds)
        containerView.addSubview(shadowView)
        shadowView.tag = 1
        shadowView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        shadowView.backgroundColor = .black
        shadowView.alpha = 0
        self.shadowView = shadowView
        
        containerView.addSubview(toView)
        toView.frame.origin = calculateOrigin(for: toView)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            toView.frame.origin = .zero
            shadowView.alpha = self.shadowAlpha
            switch self.transitionAnimation {
            case .zoom(let scale, let cornerRadius):
                fromViewController.view.layer.cornerRadius = cornerRadius
                fromViewController.view.transform = CGAffineTransform(
                    scaleX: scale,
                    y: scale
                )
            case .push:
                fromViewController.view.frame.origin = self.calculatePushOrigin(for: fromViewController.view)
            case .none:
                break
            }
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    private func calculateOrigin(for view: UIView) -> CGPoint {
        switch orientation {
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
    
    private func calculatePushOrigin(for view: UIView, percentage: CGFloat = 1) -> CGPoint {
        switch orientation {
        case .left:
            CGPoint(x: pushOffset * percentage, y: view.frame.origin.y)
        case .right:
            CGPoint(x: -pushOffset * percentage, y: view.frame.origin.y)
        case .top:
            CGPoint(x: view.frame.origin.x, y: pushOffset * percentage)
        case .bottom:
            CGPoint(x: view.frame.origin.x, y: -pushOffset * percentage)
        }
    }
    
    public func resetAnimation() {
        shadowView?.alpha = shadowAlpha
        switch transitionAnimation {
        case .zoom(let scale, _):
            fromViewController?.view.transform = CGAffineTransform(scaleX: scale, y: scale)
        case .push:
            if let fromViewController {
                fromViewController.view.frame.origin = self.calculatePushOrigin(for: fromViewController.view)
            }
        case .none:
            break
        }
    }
    
    public func animateAlongChange(in value: CGFloat) {
        shadowView?.alpha = shadowAlpha * value
        switch transitionAnimation {
        case .zoom(let scale, _):
            let newScale = 1 - value + scale * value
            fromViewController?.view.transform = CGAffineTransform(scaleX: newScale, y: newScale)
        case .push:
            if let fromViewController {
                fromViewController.view.frame.origin = self.calculatePushOrigin(for: fromViewController.view, percentage: value)
            }
        case .none:
            break
        }
    }
}
