//
//  SiteConfig.swift
//  MacStatic
//
//  Created by Alex Seifert on 10.01.26.
//

import Foundation

struct SiteConfigProperties: Codable {
    let configVersion: String
    let siteName: String
    let lang: String
}

enum SiteConfigError: Error {
    case configNotLoaded
    case fileNotFound
    case invalidJSON
}

final class SiteConfig: @unchecked Sendable {
    static let shared = SiteConfig()
    
    private var config: SiteConfigProperties?
    
    private init() {}
    
    public func loadSiteConfig(sourcePath: String) throws {
        if config != nil {
            return
        }
        
        let configPath = "\(sourcePath)/config.json"
        let url = URL(fileURLWithPath: configPath)
        let data: Data
        
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw SiteConfigError.fileNotFound
        }
        
        do {
            let decoder = JSONDecoder()
            config = try decoder.decode(SiteConfigProperties.self, from: data)
        } catch {
            throw SiteConfigError.invalidJSON
        }
    }
    
    public func getSiteConfig() throws -> SiteConfigProperties {
        guard let config = config else {
            throw SiteConfigError.configNotLoaded
        }
        return config
    }
}

    
