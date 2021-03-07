# AppleMusicSlider

A custom Slider View written in Swift. It has been inspired by the Apple Music's slider.

![alt text](https://github.com/demarte/apple-music-slider/blob/main/Readme/slider.gif)

## Requirements
- iOS 12.0+
- Xcode 11+
- Swift 5.2+

## Usage

### View Code

```swift
  import AppleMusicSlider
  
  let slider = Slider()
  
  func setUpSlider() {
    slider.addGestureRecognizer(panGesture)
    slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    slider.addTarget(self, action: #selector(sliderEditingDidEnd), for: .editingDidEnd)
    slider.setUpSlider(primaryColor: UIColor.orange, secondaryColor: UIColor.red)
  }
  
```
### Storyboard/Xib

- Add a simple UIView.
- Change the class to Slider and check if the module is poiting to AppleMusicSlider.


## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate AppleMusicSlider into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'AppleMusicSlider', '~> 0.1.2'
```
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding AppleMusicSlider as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/demarte/apple-music-slider.git", .upToNextMajor(from: "0.1.2"))
]
```
