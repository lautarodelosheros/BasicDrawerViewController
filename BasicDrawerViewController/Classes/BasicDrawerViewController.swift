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
    @IBOutlet weak var drawerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var pressTrailingViewGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    private let presentTransition: DrawerPresentationTransition
    private let dismissTransition: DrawerDismissalTransition
    
    private let orientation: Orientation
    private let maximumSize: Double
    private let screenProportion: Double
    private let bounceLeeway: Double
    private let viewController: UIViewController
    
    private var drawerActualSize: CGFloat {
        get {
            switch orientation {
            case .left, .right:
                return min(view.frame.width * screenProportion, maximumSize)
            case .top, .bottom:
                return min(view.frame.height * screenProportion, maximumSize)
            }
        }
    }
    
    private var movingConstraint: NSLayoutConstraint {
        get {
            switch orientation {
            case .left:
                return drawerLeadingConstraint
            case .right:
                return drawerTrailingConstraint
            case .top:
                return drawerTopConstraint
            case .bottom:
                return drawerBottomConstraint
            }
        }
    }
    
    private var sizeConstraint: NSLayoutConstraint {
        get {
            switch orientation {
            case .left, .right:
                return drawerWidthConstraint
            case .top, .bottom:
                return drawerHeightConstraint
            }
        }
    }
    
    private var availableSize: CGFloat {
        get {
            switch orientation {
            case .left, .right:
                return view.frame.width
            case .top, .bottom:
                return view.frame.height
            }
        }
    }
    
    private var orientationModifier: CGFloat {
        get {
            switch orientation {
            case .left, .top:
                return 1
            case .right, .bottom:
                return -1
            }
        }
    }
    
    private var panStartOffset: CGFloat = 0
    
    public init(orientation: Orientation = .left, maximumSize: Double, screenProportion: Double = 0.7, bounceLeeway: Double = 10, viewController: UIViewController) {
        self.orientation = orientation
        self.screenProportion = screenProportion
        self.maximumSize = maximumSize
        self.bounceLeeway = bounceLeeway
        self.viewController = viewController
        
        presentTransition = DrawerPresentationTransition(orientation: orientation)
        dismissTransition = DrawerDismissalTransition(orientation: orientation)
        
        super.init(nibName: String(describing: BasicDrawerViewController.self), bundle: Library.resourceBundle)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder initialization not implemented.")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setUpGestureRecognizers()
        setUpViewController()
    }
    
    private func setUpConstraints() {
        switch orientation {
        case .left:
            drawerTrailingConstraint.isActive = false
            drawerWidthConstraint.priority = .required
        case .right:
            drawerLeadingConstraint.isActive = false
            drawerWidthConstraint.priority = .required
        case .top:
            drawerBottomConstraint.isActive = false
            drawerHeightConstraint.priority = .required
        case .bottom:
            drawerTopConstraint.isActive = false
            drawerHeightConstraint.priority = .required
        }
    }
    
    private func setUpGestureRecognizers() {
        panGestureRecognizer.cancelsTouchesInView = true
        pressTrailingViewGestureRecognizer.require(toFail: panGestureRecognizer)
    }
    
    private func setUpViewController() {
        addChild(viewController)
        drawerView.addSubview(viewController.view)
        viewController.view.frame = drawerView.bounds
        viewController.didMove(toParent: self)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sizeConstraint.constant = drawerActualSize
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        movingConstraint.constant = 0
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.sizeConstraint.constant = self.drawerActualSize
        }
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        let offset: CGFloat
        switch orientation {
        case .left, .right:
            offset = sender.location(in: view).x * orientationModifier
        case .top, .bottom:
            offset = sender.location(in: view).y * orientationModifier
        }
        switch sender.state {
        case .began:
            panStartOffset = offset
        case .changed:
            let difference = max(panStartOffset - offset, -bounceLeeway)
            if difference < 0 {
                sizeConstraint.constant = drawerActualSize - difference
            } else {
                movingConstraint.constant = -difference
            }
        case .ended:
            let velocity: CGFloat
            switch orientation {
            case .left, .right:
                velocity = sender.velocity(in: view).x * orientationModifier
            case .top, .bottom:
                velocity = sender.velocity(in: view).y * orientationModifier
            }
            guard velocity > -100 else {
                dismiss(animated: true)
                break
            }
            let drawerOffset = drawerActualSize - panStartOffset + offset
            if drawerOffset < drawerActualSize * (4 / 5), velocity < 0 {
                dismiss(animated: true)
            } else {
                sizeConstraint.constant = drawerActualSize
                movingConstraint.constant = 0
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        case .cancelled:
            movingConstraint.constant = 0
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
    
    public enum Orientation {
        case left
        case right
        case top
        case bottom
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
