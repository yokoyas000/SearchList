//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation

/**
 Githubの検索API(https://developer.github.com/v3/search/#search-repositories)の
 レスポンスに対応する構造体

 see also: GithubSearchRepositoriesAPI
 **/
extension GithubSearchRepositoriesAPI {
    struct Response: Equatable {
        let repositories: [GithubRepository]

        static func create(from data: Data) throws -> GithubSearchRepositoriesAPI.Response {
            return try JSONDecoder().decode(GithubSearchRepositoriesAPI.Response.self, from: data)
        }
    }
}

extension GithubSearchRepositoriesAPI.Response: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GithubSearchRepositoriesAPI.Response.CodingKeys.self)
        self.repositories = try values.decode([GithubRepository].self, forKey: .items)
    }

    enum CodingKeys: String, CodingKey {
        case items
    }
}
