//
//  BasicDrawerViewController.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import UIKit

public class BasicDrawerViewController: UIViewController {

    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var drawerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerWidthConstraint: NSLayoutConstraint!
    @IBOutlet var pressTrailingViewGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    private var presentTransition = LeftPushPresentationTransition()
    private var dismissTransition = LeftPushDismissalTransition()
    
    private let maximumWidth: Double
    private let screenProportion: Double
    private let bounceLeeway: Double
    private let viewController: UIViewController
    
    private var drawerActualWidth: CGFloat {
        get {
            min(view.frame.width * screenProportion, maximumWidth)
        }
    }
    
    private var xPanStart: CGFloat = 0
    
    public init(maximumWidth: Double, screenProportion: Double = 0.7, bounceLeeway: Double = 10, viewController: UIViewController) {
        self.screenProportion = screenProportion
        self.maximumWidth = maximumWidth
        self.bounceLeeway = bounceLeeway
        self.viewController = viewController
        
        super.init(nibName: String(describing: BasicDrawerViewController.self), bundle: Library.resourceBundle)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder initialization not implemented.")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpGestureRecognizers()
        setUpViewController()
    }
    
    private func setUpGestureRecognizers() {
        pressTrailingViewGestureRecognizer.delegate = self
        panGestureRecognizer.delegate = self
        pressTrailingViewGestureRecognizer.require(toFail: panGestureRecognizer)
    }
    
    private func setUpViewController() {
        addChildViewController(viewController)
        drawerView.addSubview(viewController.view)
        viewController.view.frame = drawerView.bounds
        viewController.didMove(toParentViewController: self)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawerLeadingConstraint.constant = 0
        drawerWidthConstraint.constant = drawerActualWidth
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.drawerWidthConstraint.constant = self.drawerActualWidth
        }
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: view)
        switch sender.state {
        case .began:
            xPanStart = point.x
        case .changed:
            let difference = max(xPanStart - point.x, -bounceLeeway)
            if difference < 0 {
                drawerWidthConstraint.constant = drawerActualWidth - difference
            } else {
                drawerLeadingConstraint.constant = -difference
            }
        case .ended:
            guard sender.velocity(in: view).x > -100 else {
                dismiss(animated: true)
                break
            }
            let xDrawer = drawerActualWidth - xPanStart + point.x
            if xDrawer < view.frame.width / 2 {
                dismiss(animated: true)
            } else {
                drawerWidthConstraint.constant = drawerActualWidth
                drawerLeadingConstraint.constant = 0
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        case .cancelled:
            drawerLeadingConstraint.constant = 0
        case .possible, .failed:
            break
        @unknown default:
            break
        }
    }
    
    @IBAction func didPressTrailingView(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true)
        }
    }
}

extension BasicDrawerViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentTransition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissTransition
    }
}

extension BasicDrawerViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
