//
//  Library.swift
//  BasicDrawerViewController
//
//  Created by Lautaro de los Heros on 07/05/2022.
//

import Foundation

final class Library {
    
    static let resourceBundle: Bundle = {
        guard let resourceBundle = myBundle else {
            fatalError("Cannot access BasicDrawerViewControllerBundle.bundle")
        }

        return resourceBundle
    }()
    
    private static let myBundle: Bundle? = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(url: Bundle(for: Library.self).url(
            forResource: "BasicDrawerViewControllerBundle",
            withExtension: "bundle"
        )!)
        #endif
    }()
}
