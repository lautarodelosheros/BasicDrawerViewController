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
    
    private let zoomOutScale = 0.94
    private let zoomOutCornerRadius: CGFloat = 60
    
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
        let containerView = transitionContext.containerView
        fromViewController = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.view(forKey: .to)!
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
            case .zoom:
                self.fromViewController?.view.layer.cornerRadius = self.zoomOutCornerRadius
                self.fromViewController?.view.transform = CGAffineTransform(
                    scaleX: self.zoomOutScale,
                    y: self.zoomOutScale
                )
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
            CGPoint(x: -view.frame.width, y: 0)
        case .right:
            CGPoint(x: view.frame.width, y: 0)
        case .top:
            CGPoint(x: 0, y: -view.frame.height)
        case .bottom:
            CGPoint(x: 0, y: view.frame.height)
        }
    }
    
    public func resetAnimation() {
        shadowView?.alpha = shadowAlpha
        switch transitionAnimation {
        case .zoom:
            fromViewController?.view.transform = CGAffineTransform(scaleX: zoomOutScale, y: zoomOutScale)
        case .none:
            break
        }
    }
    
    public func animateAlongChange(in value: CGFloat) {
        shadowView?.alpha = shadowAlpha * value
        switch transitionAnimation {
        case .zoom:
            let scale = 1 - value + zoomOutScale * value
            fromViewController?.view.transform = CGAffineTransform(scaleX: scale, y: scale)
        case .none:
            break
        }
    }
}
