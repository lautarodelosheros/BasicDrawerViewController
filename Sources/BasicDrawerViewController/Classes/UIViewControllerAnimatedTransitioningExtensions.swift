//
//  UIViewControllerAnimatedTransitioningExtensions.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 06/12/2024.
//

import Foundation

extension UIViewControllerAnimatedTransitioning {
    
    func createSnapshotViews(tags: [Int], transitionContext: UIViewControllerContextTransitioning) -> [UIView] {
        var snapshotViews: [UIView] = []
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to)
        else {
            return snapshotViews
        }
        tags.forEach { tag in
            if let fromTransitionView = fromViewController.view.viewWithTag(tag) {
                if let snapshotView = fromTransitionView.snapshotView(afterScreenUpdates: false) {
                    let referenceView = fromViewController.navigationController?.view ?? fromViewController.view
                    snapshotView.frame = fromViewController.view.convert(fromTransitionView.frame, to: referenceView)
                    snapshotView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    transitionContext.containerView.addSubview(snapshotView)
                    snapshotViews.append(snapshotView)
                }
                fromTransitionView.isHidden = true
            }
            toViewController.view.viewWithTag(tag)?.isHidden = true
        }
        return snapshotViews
    }
    
    func removeSnapshotViews(tags: [Int], snapshotViews: [UIView], transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        snapshotViews.forEach { $0.removeFromSuperview() }
        tags.forEach { tag in
            fromViewController.view.viewWithTag(tag)?.isHidden = false
            toViewController.view.viewWithTag(tag)?.isHidden = false
        }
    }
}
