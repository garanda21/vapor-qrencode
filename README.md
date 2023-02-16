# QREncode


![Swift](http://img.shields.io/badge/swift-5.5-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-4.0-brightgreen.svg)

Vapor 4 library for create QR codes into image files using
[libqrencode](https://fukuchi.org/works/qrencode/manual/index.html).

## Getting Started

QREncode uses the Swift Package Manager to manage its code dependencies. To use QREncode in your codebase it is recommended you do the same. Add a dependency to the package in your own Package.swift dependencies.

Add the following in your `Package.swift` file
```Swift
dependencies: [
    .package(url: "https://github.com/garanda21/vapor-qrencode.git", branch: "main"),
],
```

Then add target dependencies for each of the QREncode targets you want to use.
```Swift
targets: [
        .target(name: "MyApp", dependencies: [
            .product(name: "QREncode", package: "vapor-qrencode")
        ]),
    ]
)
```
## 📘 Overview

First, install [libqrencode](https://github.com/fukuchi/libqrencode). This 
library is tested on version 4.1.1 Specify the location of `qrencode` 
in the `QREncode` initialiser. The default is `/usr/bin/qrencode`. 
Run it to ensure it and any dependencies are installed correctly.

### 🖥️ macOS installation

First, install [homebrew](https://formulae.brew.sh/), then on your terminal type the following command:
```
brew install qrencode
```

### 🐧 Ubuntu installation

Type the following commands:
```
apt-get update
apt-get install qrencode
```

To create a QR code, create and configure a `QREncode`, then call `generateQR(on: threadPool, eventLoop: eventLoop)`. Here is a full example using Vapor:

```Swift
import QREncode

func qr(_ req: Request) async throws -> Response {
                    
    //Make sure to initialice using the correct path for qrencode
    let qrencode = QREncode(text: "Test", fileName: "testfile.png", size: .large ,path: "/opt/homebrew/bin/qrencode")
  
    
    if let data = try await qrencode.generateQR(on: req.application.threadPool, eventLoop: req.eventLoop)
    {
        FileManager.default.createFile(atPath: "/tmp/vapor-qrencode/testOutput.png", contents: data, attributes: nil)
        
        print("Test output QR image can be viewed at /tmp/vapor-qrencode/testOutput.png")
        
        return Response(
            status: .ok,
            headers: HTTPHeaders([("Content-Type", "image/png")]),
            body: .init(data: data)
        )
    }
    else
    {
            return Response(
            status: .ok,
            headers: HTTPHeaders([("Content-Type", "text/plain")]),
            body: "No data"
        )
    }
}
```

