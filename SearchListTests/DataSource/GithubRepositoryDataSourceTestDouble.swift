//
// Created by yokoyas000 on 2018/06/25.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import PromiseKit

struct GithubRepositoryDataSourceStub: GithubRepositoryDataSourceProtocol {
    private let result: SearchList.Result<[GithubRepository], DataSourceError>

    init(result: SearchList.Result<[GithubRepository], DataSourceError>) {
        self.result = result
    }

    func search(text: String, page: Int?, perPage: Int?)
            -> PromiseKit.Guarantee<SearchList.Result<[GithubRepository], DataSourceError>> {
        return Guarantee.value(result)
    }
}

class GithubRepositoryDataSourceSpy: GithubRepositoryDataSourceProtocol {
    private(set) var callArgs: [CallArgs] = []

    func search(text: String, page: Int?, perPage: Int?)
            -> PromiseKit.Guarantee<SearchList.Result<[GithubRepository], DataSourceError>> {
        self.callArgs.append(.search(text: text, page: page, perPage: perPage))
        return Guarantee.value(.success([]))
    }


    enum CallArgs: Equatable {
        case search(text: String, page: Int?, perPage: Int?)
    }
}
