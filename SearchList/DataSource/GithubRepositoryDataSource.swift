//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import PromiseKit

// TODO: リポジトリ層
// "Repository" という命名は Gihub 内で使われている為、 DataSource とした
protocol GithubRepositoryDataSourceProtocol {
    func get() -> Promise<GithubRepository>
}



struct GithubRepositoryDataSource {
    let api: GithubSearchRepositoriesAPIProtocol

    init(using api: GithubSearchRepositoriesAPIProtocol) {
        self.api = api
    }

    func get() -> Promise<[GithubRepository]> {
        return api.get(word: "wwdc")
            .map { response in
                response.repositories
            }
    }
}
