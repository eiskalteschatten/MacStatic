//
//  BuildService.swift
//  MacStatic
//
//  Created by Alex Seifert on 09.01.26.
//

import Foundation

public class BuildService {
    private let pathToMarkdownContent = "content"
    
    public func buildSite(from sourcePath: String, to outputPath: String) throws {
        let allMarkdownFiles = getAllMarkdownFiles(in: sourcePath)
        let markdownService = MarkdownService()
             
        for markdownFile in allMarkdownFiles {
            let parsedMarkdown = try markdownService.processMarkdownFile(markdownFile)
            NSLog("Parsed Markdown Content: \(parsedMarkdown)")
        }
    }
    
    private func getAllMarkdownFiles(in directory: String) -> [String] {
        let fullPathToContent = "\(directory)/\(pathToMarkdownContent)"
        let fileManager = FileManager.default
        var markdownFiles: [String] = []
        
        guard let enumerator = fileManager.enumerator(atPath: fullPathToContent) else {
            return []
        }
        
        for case let file as String in enumerator {
            if file.hasSuffix(".md") {
                let fullPath = "\(fullPathToContent)/\(file)"
                markdownFiles.append(fullPath)
            }
        }
        
        return markdownFiles
    }
}
