//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation

struct GithubRepository: Equatable {
    let id: GithubRepositoryID
    let name: String
    let fullName: String
}

extension GithubRepository: Decodable {
    static func create(from data: Data) throws -> GithubRepository {
        return try JSONDecoder().decode(GithubRepository.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GithubRepository.CodingKeys.self)

        let _id = try values.decode(Int.self, forKey: .id)
        self.id = GithubRepositoryID(_id)

        self.name = try values.decode(String.self, forKey: .name)
        self.fullName = try values.decode(String.self, forKey: .fullName)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
    }
}

