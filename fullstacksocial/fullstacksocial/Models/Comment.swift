//
//  Comment.swift
//  fullstacksocial
//
//  Created by Gabriel Del VIllar De Santiago on 1/21/20.
//  Copyright © 2020 Gabriel Del VIllar De Santiago. All rights reserved.
//

import Foundation


struct Comment: Decodable {
    let text: String
    let user: User
    let fromNow: String
}
