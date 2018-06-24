//
// Created by yokoyas000 on 2018/06/24.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

protocol SearchGithubRepositoriesWithTextModelProtocol {
    func search()
}



class SearchGithubRepositoriesWithTextModel: SearchGithubRepositoriesWithTextModelProtocol {
    private let searchModel: SearchGithubRepositoriesModelProtocol
    private let textStore: Store<SearchGithubRepositoriesTextState>

    init(
        searchModel: SearchGithubRepositoriesModelProtocol,
        readOnly textStore: Store<SearchGithubRepositoriesTextState>
    ) {
        self.searchModel = searchModel
        self.textStore = textStore
    }

    func search() {
        switch self.textStore.currentState {
        case .invalid:
            // 何もしない
            return
        case .valid(let text):
            self.searchModel.search(text: text)
        }
    }
}
