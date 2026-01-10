//
//  PostService.swift
//  MacStatic
//
//  Created by Alex Seifert on 10.01.26.
//

import Foundation

struct PostMeta {
    var frontMatter: FrontMatter
    var path: String
    var link: String
}

class PostService {
    var posts: [PostMeta] = []
    var sourcePath: String
    
    init (sourcePath: String) {
        self.sourcePath = sourcePath
    }
    
    func buildPostIndex(tag: String? = nil, date: Date? = nil) throws -> [PostMeta] {
        let postFiles = getAllPostFiles()
        
        for postFile in postFiles {
            let markdownFile = MarkdownFile(postFile, sourcePath: sourcePath)
                       
            guard let frontMatter = try markdownFile.getFrontMatter() as FrontMatter? else {
                print("No front matter could be found for the post \(markdownFile)!")
                continue
            }
                       
            posts.append(PostMeta(frontMatter: frontMatter, path: markdownFile.relativePath, link: markdownFile.getLink()))
        }
        
        return posts
    }

    private func getAllPostFiles() -> [String] {
        let fullPathToContent = "\(sourcePath)/\(ProjectFiles.pathToMarkdownContent)"
        let fileManager = FileManager.default
        var postFiles: [String] = []
        
        guard let enumerator = fileManager.enumerator(atPath: fullPathToContent) else {
            return []
        }
        
        for case let file as String in enumerator {
            if file.hasSuffix(".post.md") {
                let fullPath = "\(fullPathToContent)/\(file)"
                postFiles.append(fullPath)
            }
        }
        
        return postFiles;
    }
}
