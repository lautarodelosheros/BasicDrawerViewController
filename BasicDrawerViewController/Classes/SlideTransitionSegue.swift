//
//  SlideTransitionSegue.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 30/08/2022.
//

import UIKit

public class SlideTransitionSegue: UIStoryboardSegue {
    
    public var shouldDismissWithPanEdgeGesture = true
    
    private let slidePresentationTransition = SlidePresentationTransition(
        orientation: .right,
        duration: 0.3,
        doesZoomOut: true
    )
    private let slideDismissalTransition = SlideDismissalTransition(
        orientation: .right,
        duration: 0.3,
        restoresZoom: true
    )
    
    override public func perform() {
        destination.transitioningDelegate = self
        super.perform()
        if shouldDismissWithPanEdgeGesture {
            slideDismissalTransition.interactionController = SlideDismissInteractionController(viewController: destination)
        }
    }
}

extension SlideTransitionSegue: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidePresentationTransition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideDismissalTransition
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? SlideDismissalTransition,
              let interactionController = animator.interactionController,
              interactionController.interactionInProgress
        else {
            return nil
        }
        return interactionController
    }
}
