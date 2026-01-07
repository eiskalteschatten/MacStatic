//
//  ProjectService.swift
//  MacStaticCore
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation

public class ProjectService {
    public init() {}
    
    public func createNewProject(name: String) -> String {
        // TODO: Implement project creation
        // Resources are available via Bundle.module
        // Example: let templatesURL = Bundle.module.url(forResource: "NewProjectFiles/templates", withExtension: nil)
        return "New project created: \(name)"
    }
    
    /// Get the URL for the NewProjectFiles directory
    public func getNewProjectFilesURL() -> URL? {
        return Bundle.module.resourceURL?.appendingPathComponent("NewProjectFiles")
    }
    
    /// Copy template files to a destination
    public func copyTemplateFiles(to destinationURL: URL) throws {
        guard let templateURL = getNewProjectFilesURL() else {
            throw NSError(domain: "ProjectService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Template files not found"])
        }
        
        let fileManager = FileManager.default
        
        // Create destination directory if needed
        try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true)
        
        // Copy template files
        let items = try fileManager.contentsOfDirectory(at: templateURL, includingPropertiesForKeys: nil)
        
        for item in items {
            let destinationPath = destinationURL.appendingPathComponent(item.lastPathComponent)
            try fileManager.copyItem(at: item, to: destinationPath)
        }
    }
}
