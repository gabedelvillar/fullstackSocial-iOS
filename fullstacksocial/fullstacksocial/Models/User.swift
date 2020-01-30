//
//  User.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/13/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import Foundation


struct User: Decodable {
    let id: String
    let fullName: String
    var isFollowing: Bool?
    var bio, profileImageUrl: String?
    var following, followers: [User]?
    var posts: [Post]?
    var isEditable: Bool?
}
