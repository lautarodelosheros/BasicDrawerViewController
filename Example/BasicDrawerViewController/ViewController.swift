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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let exampleViewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        let exampleViewController2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        let exampleViewController3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        let exampleViewController4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        leftDrawerViewController = BasicDrawerViewController(orientation: .left, maximumSize: 320, viewController: exampleViewController1)
        rightDrawerViewController = BasicDrawerViewController(orientation: .right, maximumSize: 320, viewController: exampleViewController2)
        rightDrawerViewController.bounceLeeway = 36
        rightDrawerViewController.screenProportion = 0.5
        topDrawerViewController = BasicDrawerViewController(orientation: .top, maximumSize: 500, presentDuration: 0.7, dismissDuration: 0.8, viewController: exampleViewController3)
        bottomDrawerViewController = BasicDrawerViewController(orientation: .bottom, maximumSize: 500, viewController: exampleViewController4)
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
}

