//
//  QREncode+Generate.swift
//  
//
//  Created by Giovanny Aranda on 16/2/23.
//

import Foundation
import NIO

extension QREncode {
    @available(macOS 12.0.0, *)
    public func generateQR(on threadPool: NIOThreadPool, eventLoop: EventLoop) async throws -> Data? {
        try await withCheckedThrowingContinuation { continuation in
            _ = threadPool.runIfActive(eventLoop: eventLoop) {
                let fileManager = FileManager.default
                
                // Create the temp folder if it doesn't already exist
                let qrDir = "/tmp/vapor-qrencode"
                try fileManager.createDirectory(atPath: qrDir, withIntermediateDirectories: true)
                let fullPath = "\(qrDir)/\(self.fileName)"
                // Save input pages to temp files, and build up args to qrencode
                var qrArgs: [String] = [
                    "--type", self.format.rawValue,
                    "-o", fullPath,
                    "-s", self.size.rawValue,
                    "-m", "1"
                ]
                
                qrArgs += self.qrArgs
                qrArgs += ["\(self.text)"]
                
                // Call qrencode and retrieve the result data
                let qrencode = Process()
                let stdout = Pipe()
                qrencode.launchPath = self.launchPath
                qrencode.arguments = qrArgs
                qrencode.standardOutput = stdout
                qrencode.launch()
                
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TimeInterval(0.5)) 
                {
                    var data:Data?
                    let imagePath = URL(fileURLWithPath: fullPath)
                    #if os(macOS)
                    guard imagePath.startAccessingSecurityScopedResource() else {
                        continuation.resume(returning: nil)
                        return
                    }
                    #endif
                    data = try? Data(contentsOf: imagePath)
                    do {
                        if FileManager.default.fileExists(atPath: fullPath) {
                            try? FileManager.default.removeItem(atPath: fullPath)
                        }
                    }
                    continuation.resume(returning: data)
                }
            }.flatMapErrorThrowing { err in
                continuation.resume(throwing: err)
                return
            }
        }
    }
}
