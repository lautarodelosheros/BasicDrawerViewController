//
//  SlidePresentationTransition.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

public class SlidePresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private weak var fromViewController: UIViewController?
    private let zoomOutScale = 0.94
    private let zoomOutCornerRadius: CGFloat = 20
    private var shadowView: UIView?
    private let shadowAlpha: CGFloat
    
    private let orientation: BasicDrawerViewController.Orientation
    private let duration: TimeInterval
    private let doesZoomOut: Bool
    
    public init(orientation: BasicDrawerViewController.Orientation, duration: TimeInterval, shadowAlpha: CGFloat = 0.6, doesZoomOut: Bool = false) {
        self.orientation = orientation
        self.duration = duration
        self.shadowAlpha = shadowAlpha
        self.doesZoomOut = doesZoomOut
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
            shadowView.alpha = self.shadowAlpha
            if self.doesZoomOut {
                self.fromViewController?.view.layer.cornerRadius = self.zoomOutCornerRadius
                self.fromViewController?.view.transform = CGAffineTransform(scaleX: self.zoomOutScale, y: self.zoomOutScale)
            }
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    public func resetAnimation() {
        shadowView?.alpha = shadowAlpha
        if doesZoomOut {
            fromViewController?.view.transform = CGAffineTransform(scaleX: zoomOutScale, y: zoomOutScale)
        }
    }
    
    public func animateAlongChange(in value: CGFloat) {
        shadowView?.alpha = shadowAlpha * value
        if doesZoomOut {
            let scale = 1 - value + zoomOutScale * value
            fromViewController?.view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
