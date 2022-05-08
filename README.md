# BasicDrawerViewController

[![Version](https://img.shields.io/cocoapods/v/BasicDrawerViewController.svg?style=flat)](https://cocoapods.org/pods/BasicDrawerViewController)
[![License](https://img.shields.io/cocoapods/l/BasicDrawerViewController.svg?style=flat)](https://cocoapods.org/pods/BasicDrawerViewController)
[![Platform](https://img.shields.io/cocoapods/p/BasicDrawerViewController.svg?style=flat)](https://cocoapods.org/pods/BasicDrawerViewController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0+

## Installation

BasicDrawerViewController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BasicDrawerViewController'
```

## Usage

Initialize an instance of BasicDrawerViewController and provide the constructor parameters, then present it when necessary:

```swift
func setUpDrawer() {
    let viewController = UIViewController() // This is the view controller that will get displayed inside the drawer.
    drawerViewController = BasicDrawerViewController(maximumWidth: 320, viewController: viewController)
}

func presentDrawer() {
    present(drawerViewController, animated: true)
}
```

You can also refer to the example app on this repository.

## Author

lautarodelosheros, lautarodelosheros@gmail.com

## License

BasicDrawerViewController is available under the MIT license. See the LICENSE file for more info.
