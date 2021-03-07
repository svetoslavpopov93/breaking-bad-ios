//
//  Character.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import Foundation

struct Character: Decodable {
    let imageUrl: String
    let name: String
    let nickname: String
    let occupation: [String]
    let seasonAppearances: [Int]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "img"
        case name
        case nickname
        case occupation
        case appearance
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        name = try container.decode(String.self, forKey: .name)
        nickname = try container.decode(String.self, forKey: .nickname)
        occupation = try container.decode([String].self, forKey: .occupation)
        seasonAppearances = try container.decode([Int].self, forKey: .appearance)
        status = try container.decode(String.self, forKey: .status)
    }
}
