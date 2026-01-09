//
//  MarkDownService.swift
//  MacStaticCore
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation
import Markdown

enum FrontMatterType: String {
    case page = "page"
    case post = "post"
}

struct FrontMatter{
    var title: String?
    var layout: String?
    var excerpt: String?
    var author: String?
    var date: Date?
    var updated: Date?
    var draft: Bool?
    var tags: [String]?
    var type: FrontMatterType?
}

public class MarkdownService {
    public func processMarkdownFile(_ filePath: String) throws -> String {
        let fileContent = try String(contentsOfFile: filePath)
        let frontMatter = parseFrontMatter(fileContent)
        let markdownContent = parseMarkdownContent(fileContent)
        let document = Document(parsing: markdownContent)
        return HTMLFormatter.format(document)
    }
    
    private func parseFrontMatter(_ content: String) -> FrontMatter? {
        // Check if content starts with ---
        guard content.hasPrefix("---") else {
            return nil
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
            return nil
        }
        
        // Parse the front matter lines
        var frontMatter = FrontMatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for line in frontMatterLines {
            let parts = line.components(separatedBy: ": ")
            guard parts.count >= 2 else { continue }
            
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts[1...].joined(separator: ": ").trimmingCharacters(in: .whitespaces)
            
            switch key {
            case "title":
                frontMatter.title = value
            case "layout":
                frontMatter.layout = value
            case "excerpt":
                frontMatter.excerpt = value
            case "author":
                frontMatter.author = value
            case "date":
                frontMatter.date = dateFormatter.date(from: value)
            case "updated":
                frontMatter.updated = dateFormatter.date(from: value)
            case "draft":
                frontMatter.draft = value.lowercased() == "true"
            case "tags":
                frontMatter.tags = value.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            case "type":
                frontMatter.type = FrontMatterType(rawValue: value) ?? .page
            default:
                break
            }
        }
        
        return frontMatter
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
