//
//  SiteBuilder.swift
//  MacStatic
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation
import Markdown

public struct SiteBuilder {
    private let markdownService = MarkdownService()
    public init() {}

    public func build(source: String, output: String) throws -> String {
//        try markdownService.buildSite(from: source, to: output)
        return try markdownService.processMarkdownFile("")
    }
}
