import XCTest
import NIO
@testable import QREncode

@available(macOS 12.0.0, *)
final class QREncodeTests: XCTestCase {
    var group: EventLoopGroup!

        override func setUp() {
            super.setUp()

            group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        }

        override func tearDown() {
            super.tearDown()

            XCTAssertNoThrow(try group.syncShutdownGracefully())
        }

    func testStringQR() async throws {
        for i in 1 ..< 2 {
            print("\u{001B}[2K\r\(i)...", terminator: "")
            let eventLoop = group.next()
            
            let qrencode = QREncode(text: "Text", fileName: "testfile.png", size: .xlarge ,path: "/opt/homebrew/bin/qrencode")
            
            let threadPool = NIOThreadPool(numberOfThreads: 1)
            threadPool.start()
            if let data = try await qrencode.generateQR(on: threadPool, eventLoop: eventLoop)
            {
                try threadPool.syncShutdownGracefully()
                // Cop-out test, just ensuring that the returned data is something
                XCTAssert(data.count > 50)
                // Visual test
                FileManager.default.createFile(atPath: "/tmp/vapor-qrencode/testOutput_\(i).png", contents: data, attributes: nil)
                
                print("Test output QR image can be viewed at /tmp/vapor-qrencode/testOutput_\(i).png")
            }
            else
            {
                XCTAssert(false)
            }
        }
    }

        static var allTests = [
            ("testStringQR", testStringQR),
        ]
}
