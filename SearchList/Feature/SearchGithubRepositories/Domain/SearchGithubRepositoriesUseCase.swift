//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import PromiseKit

protocol SearchGithubRepositoriesUseCaseProtocol {
    func search(text: String)
}



// GithubRepositoryを検索する
class SearchGithubRepositoriesUseCase: SearchGithubRepositoriesUseCaseProtocol {
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
        let params = SearchGithubRepositoriesParams(text: text)

        switch self.store.currentState {
        case .fetching:
            return
        case .first, .fetched:
            self.store.transition(
                next: .fetching(for: params)
            )
        }

        self.dataSource.search(text: text, page: 1, perPage: 20)
            .done { result in
                self.store.transition(
                    next: self.state(by: result, params: params)
                )
            }
    }

    private func state(by result: Result<[GithubRepository], DataSourceError>, params: SearchGithubRepositoriesParams) -> SearchGithubRepositoriesState {
        switch result {
        case .success(let repositories):
            return .fetched(.success(
                SearchGithubRepositoriesState.SearchResult(
                    repositories: repositories,
                    params: params
                )
            ))

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
