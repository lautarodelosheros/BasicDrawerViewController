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
    let viewController = CustomViewController() // This is the view controller that will get displayed inside the drawer.
    drawerViewController = BasicDrawerViewController(
        orientation: .left,
        maximumSize: 320,
        presentDuration: 0.7,
        dismissDuration: 0.8,
        doesZoomOut: true,
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
| maximumSize | The maximum width or height that the Drawer will ever take (Except for the elastic bounce leeway). |
| presentDuration | The duration of the presentation animation. |
| dismissDuration | The duration of the dismissal animation. |
| doesZoomOut | Boolean that indicates if the presenting ViewController should zoom out (animated) when the Drawer appears. |
| bounceLeeway | The extra width or height that the Drawer will expand in an elastic bounce fashion with the pan gesture. |
| screenProportion | The maximum portion of the screen that the Drawer will ever take, so it will be shorter than the maximumSize if necessary. |

## Demo

![Screen Recording 2022-05-19 at 00 26 42](https://user-images.githubusercontent.com/14253506/169198350-c20acef0-1533-4ac7-b5a0-7c7119467446.gif)

## Author

lautarodelosheros, lautarodelosheros@gmail.com

## License

BasicDrawerViewController is available under the MIT license. See the LICENSE file for more info.
