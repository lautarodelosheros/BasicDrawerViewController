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

    private var drawerViewController: BasicDrawerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let exampleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ExampleViewController.self))
        drawerViewController = BasicDrawerViewController(maximumWidth: 320, viewController: exampleViewController)
    }

    @IBAction func showDrawerButtonTouched(_ sender: Any) {
        present(drawerViewController, animated: true)
    }
}

