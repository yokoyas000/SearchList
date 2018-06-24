//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import PromiseKit

protocol SearchGithubRepositoriesModelProtocol {
    func search(text: String)
}



// GithubRepositoryを検索する
class SearchGithubRepositoriesModel: SearchGithubRepositoriesModelProtocol {
    private let store: Store<SearchGithubRepositoriesState>
    private let dataSource: GithubRepositoryDataSourceProtocol

    init(
        store: Store<SearchGithubRepositoriesState>,
        dataSource: GithubRepositoryDataSourceProtocol
    ) {
        self.store = store
        self.dataSource = dataSource
    }

    func search(text: String) {
        switch self.store.currentState {
        case .fetching:
            return
        case .first, .fetched:
            self.store.transition(next: .fetching)
        }

        self.dataSource.search(word: text, page: 1, perPage: 20)
            .done { result in
                self.store.transition(
                    next: self.state(by: result)
                )
            }
    }

    private func state(by result: Result<[GithubRepository], DataSourceError>) -> SearchGithubRepositoriesState {
        switch result {
        case .success(let repositories):
            return .fetched(.success(repositories))

        case .failure(let error):
            let stateError: SearchGithubRepositoriesState.StateError
            switch error {
            case let .networkError(debugInfo: debugInfo),
                 let .failedTransformFromData(debugInfo: debugInfo):
                stateError = SearchGithubRepositoriesState.StateError(debugInfo: debugInfo)
            }

            return .fetched(.failure(stateError))
        }
    }
}
