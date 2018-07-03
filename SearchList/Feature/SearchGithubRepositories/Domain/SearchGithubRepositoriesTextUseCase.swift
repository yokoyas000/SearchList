//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import RxSwift

protocol SearchGithubRepositoriesTextUseCaseProtocol {
    func validate(text: String?)
}

class SearchGithubRepositoriesTextUseCase: SearchGithubRepositoriesTextUseCaseProtocol {
    private let store: Store<SearchGithubRepositoriesTextState>

    init(store: Store<SearchGithubRepositoriesTextState>) {
        self.store = store
    }

    func validate(text: String?) {
        guard let text = text, !text.isEmpty else {
            self.store.transition(next: .invalid)
            return
        }

        self.store.transition(next: .valid(text: text))
    }
}
