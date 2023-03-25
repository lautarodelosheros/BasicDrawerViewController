//
//  Library.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

final class Library {
    
    static let resourceBundle: Bundle = {
        guard let resourceBundleURL = bundleUrl else {
            fatalError("BasicDrawerViewControllerBundle.bundle not found")
        }

        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Cannot access BasicDrawerViewControllerBundle.bundle")
        }

        return resourceBundle
    }()
    
    private static let bundleUrl: URL? = {
        #if SWIFT_PACKAGE
        return Bundle.module.path(forResource: "\(Library.self)", ofType: "bundle")
        #else
        return Bundle(for: Library.self).url(
            forResource: "BasicDrawerViewControllerBundle",
            withExtension: "bundle"
        )
        #endif
    }()
}
