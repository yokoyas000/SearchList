//
// Created by yokoyas000 on 2018/06/25.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

enum GithubRepositoriesListState: Equatable {
    case first(list: [GithubRepository])
    case fetching(currentList: [GithubRepository])
    case fetched(Result<FetchedSuccess, FetchedFailure>)

    var repositories: [GithubRepository] {
        switch self {
        case let .first(list:repositories),
             let .fetching(currentList:repositories):
            return repositories
        case let .fetched(.success(result)):
            return result.currentList + result.nextPage
        case let .fetched(.failure(result)):
            return result.currentList
        }
    }
}



extension GithubRepositoriesListState {

    struct FetchedSuccess: Equatable {
        let currentList: [GithubRepository]
        let nextPage: [GithubRepository]
    }

    struct FetchedFailure: Error, Equatable {
        let currentList: [GithubRepository]
        let error: DataSourceError
    }

}
