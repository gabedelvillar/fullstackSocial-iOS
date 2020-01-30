//
//  Post.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/9/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let id: String
    let text: String
    let createdAt: Int
    let imageUrl: String
    
    let user: User?
    
    var fromNow: String?
    
    var comments: [Comment]?
    
    var hasLiked: Bool?
    
    var numLikes: Int
}


