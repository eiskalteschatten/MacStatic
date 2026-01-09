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

struct FrontMatterPage {
    var title: String?
    var layout: String?
    var type: FrontMatterType?
}

struct FrontMatterPost {
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
//        let markdownContent = try String(contentsOfFile: filePath)
        let markdownContent = "# Test Headline"
        let document = Document(parsing: markdownContent)
        return HTMLFormatter.format(document)
    }
}
