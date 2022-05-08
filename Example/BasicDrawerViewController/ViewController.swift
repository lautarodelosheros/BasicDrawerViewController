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

    private let drawerViewController = BasicDrawerViewController(maximumWidth: 320)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showDrawerButtonTouched(_ sender: Any) {
        present(drawerViewController, animated: true)
    }
}

