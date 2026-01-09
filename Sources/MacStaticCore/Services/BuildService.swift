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
        let fileManager = FileManager.default
             
        for markdownFile in allMarkdownFiles {
            let markdownService = MarkdownService(markdownFile)
            
            guard let parsedMarkdown = try markdownService.processMarkdownFile() else {
                continue
            }
            
            guard let frontMatter = markdownService.frontMatter as FrontMatter? else {
                continue
            }
            
            // Get relative path from content directory
            let fullPathToContent = "\(sourcePath)/\(pathToMarkdownContent)"
            let relativePath = markdownFile.replacingOccurrences(of: fullPathToContent + "/", with: "")
            
            // Change .md extension to .html
            let htmlFileName = relativePath.replacingOccurrences(of: ".md", with: ".html")
            let outputFilePath = makeURLFriendly("\(outputPath)/\(htmlFileName)")
            
            // Create intermediate directories if needed
            let outputDirectory = (outputFilePath as NSString).deletingLastPathComponent
            try fileManager.createDirectory(atPath: outputDirectory, withIntermediateDirectories: true, attributes: nil)
            
            // TODO: figure out how to apply templates/layouts here
            
            // Write the HTML content to file
            try parsedMarkdown.write(toFile: outputFilePath, atomically: true, encoding: .utf8)
            
            NSLog("Built and saved: \(fullPathToContent)/\(relativePath) -> \(outputFilePath)")
        }
        
        // TODO:
        //  - Process templates and layouts
        //  - Copy static assets (CSS, JS, images, etc.) from source to output
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
    
    private func makeURLFriendly(_ path: String) -> String {
        let components = path.components(separatedBy: "/")
        
        let friendlyComponents = components.map { component -> String in
            // Convert to lowercase
            var friendly = component.lowercased()
            
            // Replace spaces with hyphens
            friendly = friendly.replacingOccurrences(of: " ", with: "-")
            
            // Remove or replace other non-URL-friendly characters
            let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_."))
            friendly = String(friendly.unicodeScalars.filter { allowedCharacters.contains($0) })
            
            return friendly
        }
        
        return friendlyComponents.joined(separator: "/")
    }
}
