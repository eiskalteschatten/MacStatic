//
//  BuildService.swift
//  MacStatic
//
//  Created by Alex Seifert on 09.01.26.
//

import Foundation

class BuildService {
    private var posts: [PostMeta] = []
    
    func buildSite(from sourcePath: String, to outputPath: String) throws {
        try SiteConfig.shared.loadSiteConfig(sourcePath: sourcePath)
        
        let postService = PostService(sourcePath: sourcePath)
        posts = try postService.buildPostIndex()
        
        try renderPages(from: sourcePath, to: outputPath)
        try copyAssets(from: sourcePath, to: outputPath)
    }
       
    private func getAllMarkdownFiles(in directory: String) -> [String] {
        let fullPathToContent = "\(directory)/\(ProjectFiles.pathToMarkdownContent)"
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
    
    private func renderPages(from sourcePath: String, to outputPath: String) throws {
        let allMarkdownFiles = getAllMarkdownFiles(in: sourcePath)
        
        for markdownFilePath in allMarkdownFiles {
            let markdownFile = MarkdownFile(markdownFilePath, sourcePath: sourcePath)
            
            guard let parsedMarkdown = try markdownFile.parse() else {
                print("Could not parse the Markdown file \(markdownFilePath)!")
                continue
            }
            
            guard let frontMatter = markdownFile.frontMatter as FrontMatter? else {
                print("No front matter could be found for \(markdownFilePath)!")
                continue
            }
            
            // Get relative path from content directory
            let fullPathToContent = "\(sourcePath)/\(ProjectFiles.pathToMarkdownContent)"
            let relativePath = markdownFilePath.replacingOccurrences(of: fullPathToContent + "/", with: "")
            
            // Change .md extension to .html
            let htmlFileName = markdownFile.getHTMLFilePath()
            let outputFilePath = makeURLFriendly("\(outputPath)/\(htmlFileName)")
            
            // Create intermediate directories if needed
            let outputDirectory = (outputFilePath as NSString).deletingLastPathComponent
            let fileManager = FileManager.default
            try fileManager.createDirectory(atPath: outputDirectory, withIntermediateDirectories: true, attributes: nil)
            
            // Render the templates with the parsed Markdown content
            
            let templateRenderService = TemplateRenderService(layout: frontMatter.layout, pathToTemplates: sourcePath)
            let renderedContent = try templateRenderService.render(markdownContent: parsedMarkdown, frontMatter: frontMatter, posts: posts)
            
            // Write the HTML content to file
            try renderedContent.write(toFile: outputFilePath, atomically: true, encoding: .utf8)
            
            print("Saved: \(fullPathToContent)/\(relativePath) -> \(outputFilePath)")
        }
    }
    
    private func copyAssets(from sourcePath: String, to outputPath: String) throws {
        let fileManager = FileManager.default
        let sourceURL = URL(fileURLWithPath: "\(sourcePath)/assets")
        let destinationURL = URL(fileURLWithPath: "\(outputPath)/assets")
        
        if fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.removeItem(at: destinationURL)
        }

        try fileManager.copyItem(at: sourceURL, to: destinationURL)

        print("Assets copied from \(sourceURL.path) to \(destinationURL.path)")
    }
}
