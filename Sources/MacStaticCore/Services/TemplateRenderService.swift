//
//  TemplateService.swift
//  MacStatic
//
//  Created by Alex Seifert on 09.01.26.
//

import Foundation
import Stencil
import PathKit

public class TemplateRenderService {
    private var layout: String
    private var pathToTemplates: String
    
    public init(layout: String, pathToTemplates: String) {
        self.layout = layout
        self.pathToTemplates = pathToTemplates
    }
    
    public func render(markdownContent: String) throws -> String {
        let context = [
            "content": markdownContent
        ]
        
        let environment = Environment(loader: FileSystemLoader(paths: [Path(pathToTemplates)]))
        let rendered = try environment.renderTemplate(name: "layouts/\(layout).html", context: context)

        return rendered
    }
}
