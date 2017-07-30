![Platform Linux](https://img.shields.io/badge/platform-Linux-green.svg)
[![Platform iOS macOS tvOS](https://img.shields.io/cocoapods/p/Socket.swift.svg?style=flat)](https://github.com/BiAtoms/Socket.swift)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Socket.swift.svg)](https://cocoapods.org/pods/Socket.swift)
[![Build Status - Master](https://travis-ci.org/BiAtoms/Socket.swift.svg?branch=master)](https://travis-ci.org/BiAtoms/Socket.swift)

# Socket.swift

A POSIX socket wrapper written in swift.

## OS
 
Works in linux, iOS, macOS and tvOS

## Example
```swift
let server = try Socket.tcpListening(port: 8090) //start socket listening at localhost:8090

let client = try Socket(.inet, type: .stream, protocol: .tcp)
try client.connect(port: 8090) //connecting to the socket at localhost:8090
let clientAtServerside = try server.accept()

let bytes = ([UInt8])("Hello World".utf8)
try clientAtServerside.write(bytes) //sening bytes to the client socket
clientAtServerside.close()

while let byte = try? client.read() { //reading bytes sent by server socket
    print(byte)
}
client.close()
server.close()
```

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Socket.swift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
target '<Your Target Name>' do
    pod 'Socket.swift' ~> '1.3'
end
```

Then, run the following command:

```bash
$ pod install
```
### Manually
Just drag and drop the files in the [Sources](Sources) folder.

## Authors

* **Orkhan Alikhanov** - *Initial work* - [OrkhanAlikhanov](https://github.com/OrkhanAlikhanov)

See also the list of [contributors](https://github.com/BiAtoms/Socket.swift/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
