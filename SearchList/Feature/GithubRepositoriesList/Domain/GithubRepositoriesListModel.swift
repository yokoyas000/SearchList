//
// Created by yokoyas000 on 2018/06/25.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import PromiseKit

protocol GithubRepositoriesListModelProtocol {
    func getNextPage()
}



class GithubRepositoriesListModel: GithubRepositoriesListModelProtocol {
    private let searchParams: SearchGithubRepositoriesParams
    private let perPage: Int
    private let dataSource: GithubRepositoryDataSourceProtocol
    private let store: Store<GithubRepositoriesListState>

    init(
        searchParams: SearchGithubRepositoriesParams,
        perPage: Int,
        dataSource: GithubRepositoryDataSourceProtocol,
        store: Store<GithubRepositoriesListState>
    ) {
        self.searchParams = searchParams
        self.perPage = perPage
        self.dataSource = dataSource
        self.store = store
    }

    func getNextPage() {
        switch self.store.currentState {
        case .fetching:
            // 何もしない
            return
        case .first, .fetched:
            self.store.transition(
                next: .fetching(
                    currentList: self.store.currentState.repositories
                )
            )
        }

        let nextPage = self.lastPageCount() + 1
        self.dataSource.search(
            text: self.searchParams.text,
            page: nextPage,
            perPage: self.perPage
        )
        .done { (result: Result<[GithubRepository], DataSourceError>) in
            self.store.transition(next: self.nextState(from: result))
        }
    }

    private func lastPageCount() -> Int {
        let repositoriesCount = self.store.currentState.repositories.count
        guard repositoriesCount != 0 else {
            return 0
        }

        return repositoriesCount / self.perPage
    }

    private func nextState(from result: Result<[GithubRepository], DataSourceError>) -> GithubRepositoriesListState {
        switch result {
        case .success(let repositories):
            let fetchedSuccess = GithubRepositoriesListState.FetchedSuccess(
                currentList: [],
                nextPage: repositories
            )

            return .fetched(.success(fetchedSuccess))

        case .failure(let error):
            let fetchedFailure = GithubRepositoriesListState.FetchedFailure(
                 currentList: [],
                error: error
            )

            return .fetched(.failure(fetchedFailure))
        }
    }
}
