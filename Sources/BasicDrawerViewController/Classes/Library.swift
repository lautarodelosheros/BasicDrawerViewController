//
//  Library.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

final class Library {
    
    static let resourceBundle: Bundle = {
        guard let resourceBundleURL = myBundle.url(
            forResource: "BasicDrawerViewControllerBundle", withExtension: "bundle")
            else { fatalError("BasicDrawerViewControllerBundle.bundle not found") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access BasicDrawerViewControllerBundle.bundle") }

        return resourceBundle
    }()
    
    private static let myBundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: Library.self)
        #endif
    }()
}
