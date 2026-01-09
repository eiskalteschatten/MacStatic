//
//  TemplateService.swift
//  MacStatic
//
//  Created by Alex Seifert on 09.01.26.
//

import Foundation
import Stencil

public class TemplateRenderService {
    private var type: String
    private var layout: String
    
    public init(type: String, layout: String) {
        self.type = type
        self.layout = layout
    }
    
    public func render(markdownContent: String) -> String {
        // TODO: render the right layout with the right type
        return markdownContent
    }
}
