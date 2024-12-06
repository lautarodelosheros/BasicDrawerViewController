# BasicDrawerViewController

[![Version](https://img.shields.io/cocoapods/v/BasicDrawerViewController.svg?style=flat)](https://cocoapods.org/pods/BasicDrawerViewController)
[![License](https://img.shields.io/cocoapods/l/BasicDrawerViewController.svg?style=flat)](https://cocoapods.org/pods/BasicDrawerViewController)
[![Platform](https://img.shields.io/cocoapods/p/BasicDrawerViewController.svg?style=flat)](https://cocoapods.org/pods/BasicDrawerViewController)

This library provides a View Controller that shows up in a portion of the screen and can embed any other kind of View Controller.

It also has a nice optional zoom animation (similar to the formSheet modal presentation animation), and an elastic effect when you drag to the opposite direction.

Check out the demo below!

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
    // This is the view controller that will get displayed inside the drawer.
    let viewController = CustomViewController()

    drawerViewController = BasicDrawerViewController(
        orientation: .left,
        transitionAnimation: .zoom(scale: 0.94, cornerRadius: 60),
        maximumSize: 320,
        presentDuration: 0.7,
        dismissDuration: 0.8,
        viewController: viewController
    )
    drawerViewController.bounceLeeway = 36
    drawerViewController.screenProportion = 0.5
}

func presentDrawer() {
    present(drawerViewController, animated: true)
}
```

You can also refer to the example app on this repository.

## Parameters

| Name | Description |
| ------------- | ------------- |
| orientation | The orientation of the Drawer. It can be left, right, top or bottom. |
| transitionAnimation | The animation applied to the presenting View Controller. It can be a zoom animation or a similar animation to the one applied by a Navigation Controller; or no animation at all. |
| maximumSize | The maximum width or height that the Drawer will ever take (Except for the elastic bounce leeway.) |
| presentDuration | The duration of the presentation animation. |
| dismissDuration | The duration of the dismissal animation. |
| bounceLeeway | The extra width or height that the Drawer will expand in an elastic bounce fashion with the pan gesture. |
| screenProportion | The maximum portion of the screen that the Drawer will ever take, so it will be shorter than the maximumSize if necessary. |

## Demo

https://user-images.githubusercontent.com/14253506/185003248-7f2b48ea-78d7-4a4a-a848-0e45b3848018.mov

## Author

lautarodelosheros, lautarodelosheros@gmail.com

## License

BasicDrawerViewController is available under the MIT license. See the LICENSE file for more info.
