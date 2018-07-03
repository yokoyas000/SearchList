//
// Created by yokoyas000 on 2018/07/03.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import RxSwift



class SearchGithubRepositoriesNavigator {

    typealias NavigationArgs = (
        // TODO: 循環参照なる気がする
        apiClient: GithubAPIClient,
        store: Store<SearchGithubRepositoriesState>
    )

    private let navigator: NavigatorProtocol
    private let navigationArgs: NavigationArgs
    private let disposeBag = DisposeBag()

    init(
        navigator: NavigatorProtocol,
        navigationArgs: NavigationArgs
    ) {
        self.navigator = navigator
        self.navigationArgs = navigationArgs

        navigationArgs.store.state.subscribe(onNext: { [weak self] state in
                switch state {
                case .first, .fetching, .fetched(.failure):
                    return
                case .fetched(.success(let repositories)):
                    self?.navigate(with: repositories)
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func navigate(with repositories: [GithubRepository]) {
        // TODO: 遷移
    }
}
