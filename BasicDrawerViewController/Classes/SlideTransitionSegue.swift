//
//  SlideTransitionSegue.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 30/08/2022.
//

import UIKit

class SlideTransitionSegue: UIStoryboardSegue {
    
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
    
    override func perform() {
        destination.transitioningDelegate = self
        super.perform()
        slideDismissalTransition.interactionController = SlideDismissInteractionController(viewController: destination)
    }
}

extension SlideTransitionSegue: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidePresentationTransition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideDismissalTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? SlideDismissalTransition,
              let interactionController = animator.interactionController,
              interactionController.interactionInProgress
        else {
            return nil
        }
        return interactionController
    }
}
