//
//  BasicDrawerViewController.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import UIKit

public class BasicDrawerViewController: UIViewController {

    @IBOutlet weak var drawerWidthConstraint: NSLayoutConstraint!
    
    private var presentTransition = LeftPushPresentationTransition()
    private var dismissTransition = LeftPushDismissalTransition()
    
    private let maximumWidth: Double
    private let screenProportion: Double
    
    public init(maximumWidth: Double, screenProportion: Double = 0.7) {
        self.screenProportion = screenProportion
        self.maximumWidth = maximumWidth
        
        super.init(nibName: String(describing: BasicDrawerViewController.self), bundle: Library.resourceBundle)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder initialization not implemented.")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawerWidthConstraint.constant = min(view.frame.width * screenProportion, maximumWidth)
    }
    
    @IBAction func trailingViewTouched(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension BasicDrawerViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}
