//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit
import RxSwift

class SearchGithubRepositoriesRenderer {
    private let view: SearchGithubRepositoriesViewProtocol
    private let disposeBag = DisposeBag()

    init(
        view: SearchGithubRepositoriesViewProtocol,
        textStore: Store<SearchGithubRepositoriesTextState>,
        repositoriesStore: Store<SearchGithubRepositoriesState>
    ) {
        self.view = view

        textStore.state.subscribe(onNext: { [weak self] state in
                switch state {
                case .invalid:
                    self?.view.searchButton.isEnabled = false
                    self?.view.searchButton.alpha = 0.5
                case .valid:
                    self?.view.searchButton.isEnabled = true
                    self?.view.searchButton.alpha = 1
                }
            })
            .disposed(by: self.disposeBag)

        repositoriesStore.state.subscribe(onNext: { [weak self] state in
            switch state {
            case .first:
                self?.view.indicator.isHidden = true
                self?.view.searchLabel.isHidden = true
            case .fetching:
                self?.view.indicator.isHidden = false
                self?.view.searchLabel.isHidden = false
                self?.view.indicator.startAnimating()
                self?.view.searchLabel.text = "Searching"
            case .fetched(.success):
                self?.view.indicator.isHidden = true
                self?.view.searchLabel.isHidden = true
            case .fetched(.failure(let error)):
                self?.view.indicator.isHidden = true
                self?.view.searchLabel.isHidden = false
                self?.view.searchLabel.text = error.debugInfo
            }
        })
        .disposed(by: self.disposeBag)
    }
}
