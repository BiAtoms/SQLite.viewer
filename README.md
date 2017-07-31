[![Platform](https://img.shields.io/cocoapods/p/SQLite.viewer.svg?style=flat)](https://github.com/BiAtoms/SQLite.viewer)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/SQLite.viewer.svg)](https://cocoapods.org/pods/SQLite.viewer)

# SQLite.viewer

An elegant library for viewing, editing, or debugging sqlite databases in iOS applications. Inspired by [Android Debug Database](https://github.com/amitshekhariitbhu/Android-Debug-Database).

## Features

* List available databases
* List tables
* Run raw query

## ToDo

- [ ] Insert rows
- [ ] Edit rows

## Usage

In AppDelegate.swift file, just start `SQLiteViewer`.
```swift
import UIKit
import SQLiteViewer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SQLiteViewer.shared.start()
        return true
    }
}
```

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SQLite.viewer into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
target '<Your Target Name>' do
    pod 'SQLite.viewer', '~> 1.0', :configurations => ['Debug']
end
```

Then, run the following command:

```bash
$ pod install
```

## Authors

* **Orkhan Alikhanov** - *Initial work* - [OrkhanAlikhanov](https://github.com/OrkhanAlikhanov)

See also the list of [contributors](https://github.com/BiAtoms/SQLite.viewer/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
