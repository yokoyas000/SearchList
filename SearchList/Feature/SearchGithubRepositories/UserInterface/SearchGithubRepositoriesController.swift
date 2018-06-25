//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

class SearchGithubRepositoriesController: NSObject {
    private let searchModel: SearchGithubRepositoriesModelProtocol
    private let textStore: Store<SearchGithubRepositoriesTextState>
    private let textModel: SearchGithubRepositoriesTextModelProtocol

    init(
        handle view: SearchGithubRepositoriesViewProtocol,
        searchModel: SearchGithubRepositoriesModelProtocol,
        textStore: Store<SearchGithubRepositoriesTextState>,
        textModel: SearchGithubRepositoriesTextModelProtocol
    ) {
        self.searchModel = searchModel
        self.textStore = textStore
        self.textModel = textModel

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
            self.searchModel.search(text: text)
        }
    }

    @objc func didChangeTextField(_ textField: UITextField) {
        self.textModel.validate(text: textField.text)
    }
}
