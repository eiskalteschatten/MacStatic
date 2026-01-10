//
//  TemplateService.swift
//  MacStatic
//
//  Created by Alex Seifert on 09.01.26.
//

import Foundation
import Stencil
import PathKit

class TemplateRenderService {
    private var layout: String
    private var pathToTemplates: String
    
    init(layout: String, pathToTemplates: String) {
        self.layout = layout
        self.pathToTemplates = pathToTemplates
    }
    
    func render(markdownContent: String, frontMatter: FrontMatter) throws -> String {
        let siteConfig = try SiteConfig.shared.getSiteConfig()
        
        let context: [String: Any] = [
            "content": markdownContent,
            "siteName": siteConfig.siteName,
            "lang": siteConfig.lang,
            "frontMatter": frontMatter
        ]
        
        let environment = Environment(loader: FileSystemLoader(paths: [Path(pathToTemplates)]))
        let rendered = try environment.renderTemplate(name: "layouts/\(layout).html", context: context)

        return rendered
    }
}
