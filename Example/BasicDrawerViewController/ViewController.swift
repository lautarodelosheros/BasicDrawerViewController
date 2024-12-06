//
//  ViewController.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 05/07/2022.
//  Copyright (c) 2022 Lautaro de los Heros. All rights reserved.
//

import UIKit
import BasicDrawerViewController

class ViewController: UIViewController {

    private var leftDrawerViewController: BasicDrawerViewController!
    private var rightDrawerViewController: BasicDrawerViewController!
    private var topDrawerViewController: BasicDrawerViewController!
    private var bottomDrawerViewController: BasicDrawerViewController!

    private let pushTransition = SlidePresentationTransition(
        orientation: .right,
        transitionAnimation: .push(offset: 120),
        transitionViewTags: [44],
        duration: 0.25,
        shadowAlpha: 0
    )
    private let popTransition = SlideDismissalTransition(
        orientation: .right,
        transitionAnimation: .push(offset: 120),
        transitionViewTags: [44],
        duration: 0.25
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        let exampleViewController1 = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        let exampleViewController2 = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        let exampleViewController3 = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        let exampleViewController4 = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        leftDrawerViewController = BasicDrawerViewController(
            orientation: .left,
            transitionAnimation: .zoom(scale: 0.94, cornerRadius: 60),
            maximumSize: 320,
            hidesStatusBar: true,
            viewController: exampleViewController1
        )
        rightDrawerViewController = BasicDrawerViewController(
            orientation: .right,
            transitionAnimation: .push(offset: 120),
            maximumSize: 320,
            viewController: exampleViewController2
        )
        rightDrawerViewController.bounceLeeway = 36
        rightDrawerViewController.screenProportion = 0.5
        topDrawerViewController = BasicDrawerViewController(
            orientation: .top,
            transitionAnimation: .zoom(scale: 0.9, cornerRadius: 0),
            maximumSize: 500,
            presentDuration: 0.7,
            dismissDuration: 0.8,
            viewController: exampleViewController3
        )
        bottomDrawerViewController = BasicDrawerViewController(
            orientation: .bottom,
            transitionAnimation: .push(offset: 100),
            maximumSize: 500,
            viewController: exampleViewController4
        )
    }

    @IBAction func showLeftDrawerButtonTouched(_ sender: Any) {
        present(leftDrawerViewController, animated: true)
    }
    
    @IBAction func showRightDrawerButtonTouched(_ sender: Any) {
        present(rightDrawerViewController, animated: true)
    }
    
    @IBAction func showTopDrawerButtonTouched(_ sender: Any) {
        present(topDrawerViewController, animated: true)
    }
    
    @IBAction func showBottomDrawerButtonTouched(_ sender: Any) {
        present(bottomDrawerViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "slideTransitionSegueWithoutGesture":
            guard let segue = segue as? SlideTransitionSegue else {
                return
            }
            segue.panEdgeGestureViewController = nil
        case "pushSegue":
            popTransition.interactionController = SlideDismissInteractionController(
                viewController: segue.destination,
                isPushing: true
            )
        case .none, .some(_):
            break
        }
    }
}

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        switch operation {
        case .push:
            return pushTransition
        case .none:
            return nil
        case .pop:
            return popTransition
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        guard let animator = animationController as? SlideDismissalTransition,
              let interactionController = animator.interactionController,
              interactionController.interactionInProgress
        else {
            return nil
        }
        return interactionController
    }
}
