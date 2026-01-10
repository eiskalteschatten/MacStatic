//
//  PostService.swift
//  MacStatic
//
//  Created by Alex Seifert on 10.01.26.
//

import Foundation

struct PostMeta {
    var title: String
    var path: String
}

class PostService {
    var posts: [PostMeta] = []
    
    func buildPostIndex(tag: String? = nil, date: Date? = nil) -> [PostMeta] {
        // TODO: go through all markdown files and check for type "post"
        
        return posts
    }
}
