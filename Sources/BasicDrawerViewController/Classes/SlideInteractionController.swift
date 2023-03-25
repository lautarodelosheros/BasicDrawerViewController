//
//  SlideInteractionController.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 30/08/2022.
//

import Foundation
import UIKit

public class SlideDismissInteractionController: UIPercentDrivenInteractiveTransition {
    
    public var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController?
    
    private let cancelSpeed = 0.5
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let viewController = viewController,
              let view = gestureRecognizer.view
        else {
            return
        }
        
        let translation = gestureRecognizer.translation(in: view)
        let progress = translation.x / (view.bounds.width * 4/3)
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true)
        case .changed:
            let velocity = gestureRecognizer.velocity(in: view).x
            shouldCompleteTransition = velocity > 100 || progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            completionSpeed = cancelSpeed * progress
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                completionSpeed = 1
                finish()
            } else {
                completionSpeed = cancelSpeed * progress
                cancel()
            }
        default:
            break
        }
    }
}
