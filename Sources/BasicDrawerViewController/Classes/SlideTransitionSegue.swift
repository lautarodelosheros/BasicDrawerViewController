//
//  SlideTransitionSegue.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 30/08/2022.
//

import Foundation
import UIKit

public class SlideTransitionSegue: UIStoryboardSegue {
    
    public weak var panEdgeGestureViewController: UIViewController?
    
    override public init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        panEdgeGestureViewController = destination
    }
    
    private let slidePresentationTransition = SlidePresentationTransition(
        orientation: .right,
        transitionAnimation: .push(offset: 120),
        duration: 0.3,
        shadowAlpha: 0
    )
    private let slideDismissalTransition = SlideDismissalTransition(
        orientation: .right,
        transitionAnimation: .push(offset: 120),
        duration: 0.3
    )
    
    override public func perform() {
        destination.transitioningDelegate = self
        super.perform()
        if let panEdgeGestureViewController = panEdgeGestureViewController {
            slideDismissalTransition.interactionController = SlideDismissInteractionController(
                viewController: panEdgeGestureViewController,
                isPushing: false
            )
        }
    }
}

extension SlideTransitionSegue: UIViewControllerTransitioningDelegate {
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        slidePresentationTransition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideDismissalTransition
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? SlideDismissalTransition,
              let interactionController = animator.interactionController,
              interactionController.interactionInProgress
        else {
            return nil
        }
        return interactionController
    }
}
