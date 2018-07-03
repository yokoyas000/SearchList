//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

class SearchGithubRepositoriesController: NSObject {
    private let searchUseCase: SearchGithubRepositoriesUseCaseProtocol
    private let textStore: Store<SearchGithubRepositoriesTextState>
    private let textUseCase: SearchGithubRepositoriesTextUseCaseProtocol

    init(
        handle view: SearchGithubRepositoriesViewProtocol,
        searchUseCase: SearchGithubRepositoriesUseCaseProtocol,
        textStore: Store<SearchGithubRepositoriesTextState>,
        textUseCase: SearchGithubRepositoriesTextUseCaseProtocol
    ) {
        self.searchUseCase = searchUseCase
        self.textStore = textStore
        self.textUseCase = textUseCase

        super.init()

        view.searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        view.searchWordTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    }

    @objc func didTapSearchButton(_ button: UIButton) {
        switch self.textStore.currentState {
        case .invalid:
            // 何もしない
            return
        case .valid(let text):
            self.searchUseCase.search(text: text)
        }
    }

    @objc func didChangeTextField(_ textField: UITextField) {
        self.textUseCase.validate(text: textField.text)
    }
}
