//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import PromiseKit

// NOTE: "Repository" という命名は Github 内で使われている為、 DataSource とした
protocol GithubRepositoryDataSourceProtocol {
    func search(text: String, page: Int?, perPage: Int?) -> Guarantee<Result<[GithubRepository], DataSourceError>>
}
