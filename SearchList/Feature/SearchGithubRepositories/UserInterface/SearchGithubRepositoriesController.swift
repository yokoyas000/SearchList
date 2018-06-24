//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

class SearchGithubRepositoriesController: NSObject {
    private let searchModel: SearchGithubRepositoriesWithTextModelProtocol
    private let textModel: SearchGithubRepositoriesTextModelProtocol

    init(
        handle view: SearchGithubRepositoriesViewProtocol,
        searchModel: SearchGithubRepositoriesWithTextModelProtocol,
        textModel: SearchGithubRepositoriesTextModelProtocol
    ) {
        self.searchModel = searchModel
        self.textModel = textModel

        super.init()

        view.searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        view.searchWordTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    }

    @objc func didTapSearchButton(_ button: UIButton) {
        self.searchModel.search()
    }

    @objc func didChangeTextField(_ textField: UITextField) {
        self.textModel.validate(text: textField.text)
    }
}
