//
//  UserSettings.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/12/25.
//


import Foundation

struct UserSettings: Codable {
    var username: String?
    var email: String
    var password: String
    var avatarData: Data?
}
