//
//  MacStaticCore.swift
//  MacStaticCore
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation

// Unified command processing - not main actor isolated
public class MacStaticCommandProcessor {
    public static func processCommand(_ command: String, arguments: [String] = []) throws -> String {
        return executeCommand(command: command, arguments: arguments)
    }
    
    // Validate command and arguments
    public static func validateCommand(_ command: String, arguments: [String]) -> (isValid: Bool, message: String) {
        switch command.lowercased() {
        case "build":
            if arguments.count < 2 {
                return (false, "Build command requires source and output paths")
            }
            return (true, "Valid build command")
        case "new":
            return (true, "Valid new command")
        default:
            return (false, "Unknown command: \(command)")
        }
    }
    
    private static func executeCommand(command: String, arguments: [String]) -> String {
        switch command.lowercased() {
        case "build":
//            let markdownService = MarkdownService()
            let buildService = BuildService()
            do {
                 let sourcePath = arguments.count > 0 ? arguments[0] : ""
                 let outputPath = sourcePath + "/dist"
                // let result = try markdownService.buildSite(from: sourcePath, to: outputPath)
//                let result = try markdownService.processMarkdownFile("")
                try buildService.buildSite(from: sourcePath, to: outputPath)
                return "Site built successfully at \(outputPath)"
            } catch {
                return "Build failed: \(error.localizedDescription)"
            }
        case "new":
            let name = arguments.count > 0 ? arguments[0] : ""
            let directory = arguments.count > 1 ? arguments[1] : ""
            let projectService = ProjectService()
            let result = projectService.createNewProject(name: name, at: directory)
            return result
        default:
            return "Unknown command: \(command)"
        }
    }
}

@MainActor
public class MacStaticCore: ObservableObject {
    @Published public var status: String = "Ready"
    @Published public var isProcessing: Bool = false
    @Published public var results: [String] = []
    
    public init() {}
    
    // Async version for GUI
    public func processCommand(_ command: String, arguments: [String] = []) async throws -> String {
        isProcessing = true
        status = "Processing..."
        
        defer {
            isProcessing = false
            status = "Ready"
        }
        
        let result = await performOperation(command: command, arguments: arguments)
        results.append(result)
        
        return result
    }
    
    private func performOperation(command: String, arguments: [String]) async -> String {
        // Simulate work for GUI
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return try! MacStaticCommandProcessor.processCommand(command, arguments: arguments)
    }
}
