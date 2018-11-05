//
//  UserModel.swift
//  MasterPlayer
//
//  Created by Glny Gl on 24.10.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    var user: User?
    var feed: [Feed]?
    var feedTotal: Int?
}

struct User: Codable {
    var profilePhoto: String?
    var coverPhoto: String?
    var id: String?
    var name: String?
    var email: String?
    var bio: String?
}

struct Feed: Codable {
    var photo: String?
    var Name: String?
    var FollowerCount: String?
    var CreatedAt: String?
}

