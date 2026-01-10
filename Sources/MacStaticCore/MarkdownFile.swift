//
//  MarkdownFile.swift
//  MacStaticCore
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation
import Markdown

struct FrontMatter {
    var title: String?
    var description: String?
    var author: String?
    var date: Date?
    var updated: Date?
    var draft: Bool?
    var tags: [String]?
    var layout: String
}

class MarkdownFile {
    let fullPath: String
    let relativePath: String
    
    var frontMatter: FrontMatter?
    var parsedContent: String?
    
    init(_ fullPath: String, sourcePath: String? = nil) {
        self.fullPath = fullPath
        
        let cwd = sourcePath ?? FileManager.default.currentDirectoryPath
        relativePath = fullPath.replacingOccurrences(of: cwd + "/", with: "")
    }
        
    func parse() throws -> String? {
        let fileContent = try getFileContents()
        setFrontMatter(fileContent)
        let markdownContent = parseMarkdownContent(fileContent)
        let document = Document(parsing: markdownContent)
        parsedContent = HTMLFormatter.format(document)
        return parsedContent
    }
    
    func getFrontMatter() throws -> FrontMatter {
        if frontMatter != nil {
            return frontMatter!
        }
        
        let fileContent = try getFileContents()
        setFrontMatter(fileContent)
        
        return frontMatter!
    }
    
    func getLink() -> String {
        let htmlFileName = relativePath.replacingOccurrences(of: ".post", with: "")
        return htmlFileName.replacingOccurrences(of: ".md", with: ".html")
    }
    
    private func getFileContents() throws -> String {
        return try String(contentsOfFile: fullPath, encoding: .utf8)
    }
    
    private func setFrontMatter(_ content: String) {
        frontMatter = FrontMatter(layout: "default")

        // Check if content starts with ---
        guard content.hasPrefix("---") else {
            return
        }
        
        // Find the closing ---
        let lines = content.components(separatedBy: .newlines)
        var frontMatterLines: [String] = []
        var foundClosing = false
        var lineIndex = 1 // Skip first ---
        
        while lineIndex < lines.count {
            let line = lines[lineIndex]
            if line.trimmingCharacters(in: .whitespaces) == "---" {
                foundClosing = true
                break
            }
            frontMatterLines.append(line)
            lineIndex += 1
        }
        
        guard foundClosing else {
            return
        }
        
        // Parse the front matter lines
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for line in frontMatterLines {
            let parts = line.components(separatedBy: ": ")
            guard parts.count >= 2 else { continue }
            
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts[1...].joined(separator: ": ").trimmingCharacters(in: .whitespaces)
            
            switch key {
            case "title":
                frontMatter!.title = value
            case "layout":
                frontMatter!.layout = value
            case "description":
                frontMatter!.description = value
            case "author":
                frontMatter!.author = value
            case "date":
                frontMatter!.date = dateFormatter.date(from: value)
            case "updated":
                frontMatter!.updated = dateFormatter.date(from: value)
            case "draft":
                frontMatter!.draft = value.lowercased() == "true"
            case "tags":
                frontMatter!.tags = value.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            default:
                break
            }
        }
    }
    
    private func parseMarkdownContent(_ content: String) -> String {
        // Remove front matter section
        let lines = content.components(separatedBy: .newlines)
        var markdownLines: [String] = []
        var inFrontMatter = false
        var lineIndex = 0
        
        while lineIndex < lines.count {
            let line = lines[lineIndex]
            if line.trimmingCharacters(in: .whitespaces) == "---" {
                inFrontMatter.toggle()
                lineIndex += 1
                continue
            }
            if !inFrontMatter {
                markdownLines.append(line)
            }
            lineIndex += 1
        }
        
        return markdownLines.joined(separator: "\n")
    }
}
