//
// Created by yokoyas000 on 2018/06/18.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation
import PromiseKit

/**
 Githubの検索APIを利用して検索結果を取得する
 see: https://developer.github.com/v3/search/#search-repositories
 **/
protocol GithubSearchRepositoriesAPIProtocol {
    func get(word: String) -> Promise<GithubSearchRepositoriesAPIResponse>
}



struct GithubSearchRepositoriesAPI: GithubSearchRepositoriesAPIProtocol {

    private let resource: GithubAPIResourceProtocol

    init(resource: GithubAPIResourceProtocol) {
        self.resource = resource
    }

    func get(word: String) -> Promise<GithubSearchRepositoriesAPIResponse> {
        return self.resource.get()
            .map { data -> GithubSearchRepositoriesAPIResponse in
                let response = try GithubSearchRepositoriesAPIResponse.create(from: data)
                return response
            }
    }
}
