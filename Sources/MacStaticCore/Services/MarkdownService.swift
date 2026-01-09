//
//  MarkDownService.swift
//  MacStaticCore
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation
import Markdown

public class MarkdownService {
    public func processMarkdownFile(_ filePath: String) throws -> String {
//        let markdownContent = try String(contentsOfFile: filePath)
        let markdownContent = "# Test Headline"
        let document = Document(parsing: markdownContent)
        return HTMLFormatter.format(document)
    }
}
