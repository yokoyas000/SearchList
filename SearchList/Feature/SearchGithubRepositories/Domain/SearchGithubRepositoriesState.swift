//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

// GithubRepository の検索状態
enum SearchGithubRepositoriesState {
    // 初期状態(何もしていない)
    case first

    // 取得中
    case fetching(for: SearchGithubRepositoriesParams)

    // 取得結果<取得できたレポジトリ or エラー>
    case fetched(Result<SearchResult, StateError>)

    struct SearchResult {
        let repositories: [GithubRepository]
        let params: SearchGithubRepositoriesParams
    }

    struct StateError: Error {
        let debugInfo: String
    }
}
