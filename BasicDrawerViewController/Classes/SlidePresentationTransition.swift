//
//  SlidePresentationTransition.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

public class SlidePresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let orientation: BasicDrawerViewController.Orientation
    private let duration: TimeInterval
    private let doesZoomOut: Bool
    
    public init(orientation: BasicDrawerViewController.Orientation, duration: TimeInterval, doesZoomOut: Bool = false) {
        self.orientation = orientation
        self.duration = duration
        self.doesZoomOut = doesZoomOut
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
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

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            toView.frame.origin = .zero
            shadowView.alpha = 0.5
            if self.doesZoomOut {
                fromViewController?.view.layer.cornerRadius = 20
                fromViewController?.view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
            }
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
