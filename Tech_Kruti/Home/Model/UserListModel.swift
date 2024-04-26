//
//  UserListModel.swift
//  Tech_Kruti
//
//  Created by Kruti on 26/04/24.
//

import Foundation

struct UserDetailListModel: Codable {
    let userID, id: Int?
    let title, body: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias UserDetailList = [UserDetailListModel]
