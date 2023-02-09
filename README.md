# EasyConstraints

EasyConstraints is a lightweight library to make Auto Layout easy on iOS.

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+

## Installation

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

> Xcode 13+ is required to build EasyConstraints using Swift Package Manager.

To integrate EasyConstraints into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/mghlm/EasyConstraints")
]
```

## Usage

### Quick Start

```swift
import EasyConstraints

class SomeViewController: UIViewController {
    
    lazy var centeredSquare = UIView()
    lazy var rightAlignedSquare = UIView()
    
    lazy var topStackedSquare = UIView()
    lazy var bottomStackedSquare = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(centeredSquare)
        centeredSquare.match(100, on: .size)
        centeredSquare.matchSuperview(at: .center)
        
        self.view.addSubview(rightAlignedSquare)
        rightAlignedSquare.match(100, on: .size)
        rightAlignedSquare.layout(in: view, insets: 16, edges: [.trailing])
        
        self.view.addSubview(topStackedSquare)
        self.view.addSubview(bottomStackedSquare)
        [topStackedSquare, bottomStackedSquare].stackVertically(spacing: 4)
    }
}
```