//
// Created by yokoyas000 on 2018/06/18.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation
import PromiseKit

/**
 Githubの検索APIを利用する関数の名前空間
 see: https://developer.github.com/v3/search/#search-repositories
 **/
enum GithubSearchRepositoriesAPI {
    static func get(word: String) -> Promise<GithubSearchRepositoriesAPI.Response> {
        let response = GithubSearchRepositoriesAPI.Response(
            repositories: [
                GithubRepository(
                    id: GithubRepositoryID(34222505),
                    name: "WWDC",
                    fullName: "insidegui/WWDC"
                ),
                GithubRepository(
                    id: GithubRepositoryID(11025353),
                    name: "wwdc-downloader",
                    fullName: "ohoachuck/wwdc-downloader"
                ),
            ]
        )

        return Promise<GithubSearchRepositoriesAPI.Response> { (resolver: Resolver<GithubSearchRepositoriesAPI.Response>) -> Void in
            resolver.fulfill(response)
        }
    }
}
