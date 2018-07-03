//
// Created by yokoyas000 on 2018/06/25.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit
import RxSwift

protocol GithubRepositoriesListViewProtocol {}



class GithubRepositoriesListRenderer: NSObject {
    private let store: Store<GithubRepositoriesListState>
    private let cellRegisterToken: GithubRepositoriesListCell.RegisteredToken
    private let tableView: UITableView
    private let disposeBag = DisposeBag()

    init(
        observing store: Store<GithubRepositoriesListState>,
        update tableView: UITableView
    ) {
        self.store = store
        self.cellRegisterToken = GithubRepositoriesListCell.register(tableView: tableView)
        self.tableView = tableView

        super.init()

        store.state.subscribe(onNext: { [weak self] state in
            switch state {
            case .first:
                return
            case .fetching, .fetched:
                self?.tableView.reloadData()
            }
        })
        .disposed(by: self.disposeBag)
    }
}



extension GithubRepositoriesListRenderer: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.currentState.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        return GithubRepositoriesListCell.dequeueReusableCell(
            from: tableView,
            token: self.cellRegisterToken,
            githubRepository: self.store.currentState.repositories[row]
        )
    }
}

