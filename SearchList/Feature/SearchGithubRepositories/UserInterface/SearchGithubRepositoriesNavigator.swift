//
// Created by yokoyas000 on 2018/07/03.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import RxSwift



class SearchGithubRepositoriesNavigator {

    typealias NavigationArgs = GithubAPIClient

    private let navigator: NavigatorProtocol
    private let navigationArgs: NavigationArgs
    private let disposeBag = DisposeBag()

    init(
        navigator: NavigatorProtocol,
        navigationArgs: NavigationArgs,
        store: Store<SearchGithubRepositoriesState>
    ) {
        self.navigator = navigator
        self.navigationArgs = navigationArgs

        store.state.subscribe(onNext: { [weak self] state in
                switch state {
                case .first, .fetching, .fetched(.failure):
                    return
                case .fetched(.success(let result)):
                    self?.navigate(with: result)
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func navigate(with successResult: SearchGithubRepositoriesState.SearchResult) {
        guard let next = GithubRepositoriesListViewController.create(
            apiClient: self.navigationArgs,
            firstRepositories: successResult.repositories,
            searchParams: successResult.params,
            perPage: Const.SearchGithubRepositories.listPerPage
        ) else {
            // MEMO: プロダクトでないので何もしないが、プロダクトならエラー検知なりハンドリングなりなんかする
            return
        }
        self.navigator.navigate(next: next, animated: true)
    }
}
