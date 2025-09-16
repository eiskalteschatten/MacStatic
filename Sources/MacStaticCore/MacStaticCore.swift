//
//  MacStaticCore.swift
//  MacStaticCore
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation

@MainActor
public class MacStaticCore: ObservableObject {
    @Published public var status: String = "Ready"
    @Published public var isProcessing: Bool = false
    @Published public var results: [String] = []
    
    public init() {}
    
    public func processCommand(_ command: String, arguments: [String] = []) async throws -> String {
        isProcessing = true
        status = "Processing..."
        
        defer {
            isProcessing = false
            status = "Ready"
        }
        
        // Your core business logic here
        let result = await performOperation(command: command, arguments: arguments)
        results.append(result)
        
        return result
    }
    
    private func performOperation(command: String, arguments: [String]) async -> String {
        // Simulate work
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Your actual implementation
        switch command {
        case "build":
            let siteBuilder = SiteBuilder()
            do {
                // Expect arguments: [sourcePath, outputPath]
                let sourcePath = arguments.count > 0 ? arguments[0] : ""
                let outputPath = arguments.count > 1 ? arguments[1] : ""
                let result = try siteBuilder.build(source: sourcePath, output: outputPath)
                return "Site built successfully: \(result)"
            } catch {
                return "Build failed: \(error.localizedDescription)"
            }
        case "analyze":
            return "Analysis complete: \(arguments.count) items processed"
        default:
            return "Unknown command: \(command)"
        }
    }
}
