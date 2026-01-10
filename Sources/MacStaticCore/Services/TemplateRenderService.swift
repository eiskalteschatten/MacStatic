//
//  TemplateService.swift
//  MacStatic
//
//  Created by Alex Seifert on 09.01.26.
//

import Foundation
import Stencil

public class TemplateRenderService {
    private var layout: String
    
    public init(layout: String) {
        self.layout = layout
    }
    
    public func render(markdownContent: String) -> String {
        // TODO: render the right layout with the right type
        return markdownContent
    }
}
