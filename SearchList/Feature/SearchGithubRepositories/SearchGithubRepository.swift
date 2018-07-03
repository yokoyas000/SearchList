//
// Created by yokoyas000 on 2018/06/21.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

/**
 使い勝手など含め
 どうクラス分割をするか考えるゾーン
**/

import UIKit
import RxSwift

class SearchGithubRepositoryListViewController: UIViewController {

    static func create() {}

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = SearchGithubRepositoryListView()
        self.view = view

        let store = Store<GithubRepositoryListState>(initialState: .first)

        let dataSource = GithubSearchRepositoriesAPI(
            apiClient: GithubAPIClient(
                httpClient: HTTPClient()
            )
        )

        let model = SearchGithubRepositoryListDomain(
            store: store,
            dataSource: dataSource
        )

        let action = SearchGithubRepositoryListAction(
            view: view,
            model: model
        )

        let renderer = SearchGithubRepositoryListRenderer(
            store: store,
            view: view
        )
    }
}

// 画面構築
// UIView
import UIKit

class SearchGithubRepositoryListView: UIView {
    var searchTextField: UITextField!
    var searchButton: UIButton!
    // 外に出したい
    // どう使われるかはここでは決めない
    func update() {}
}

class SearchGithubRepositoryListViewTests {
    func testUpdate() {
        let view = SearchGithubRepositoryListView()
        view.update()

        // XCTAssertEqual(expected, view.searchButton.enable)
        // XCTAssertEqual(expected, view.searchButton.searchTextField.text)
    }
}




// action付与
class SearchGithubRepositoryListAction {
    private let view: SearchGithubRepositoryListView
    private let model: SearchGithubRepositoryListDomain

    init(
        view: SearchGithubRepositoryListView,
        model: SearchGithubRepositoryListDomain
    ) {
        self.view = view
        self.model = model

        self.view.searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }

    @objc func didTapSearchButton() {
        let word = "aaa"
        self.model.search(word: word)
    }
}
class SearchGithubRepositoryListActionTests {
    // UIテストかな？
}


import PromiseKit

// action実行
// 唯一副作用があるProcess
// 状態分岐もある
// 状態にあった判断をしてStoreを更新する
class SearchGithubRepositoryListDomain {
    private let store: Store<GithubRepositoryListState>
    private let dataSource: GithubRepositoryDataSourceProtocol

    init(
        store: Store<GithubRepositoryListState>,
        dataSource: GithubRepositoryDataSourceProtocol
    ) {
        self.store = store
        self.dataSource = dataSource
    }

    func search(word: String) {
        switch self.store.currentState {
        case .fetching:
            return
        case .first, .fetched:
            self.store.transition(next: .fetching)
        }

        self.dataSource.search(word: word, page: nil, perPage: nil)
            .done { (result: Result<[GithubRepository], DataSourceError>) in
                switch result {
                case .success(let repositories):
                    self.store.transition(
                        next: .fetched(.success(repositories))
                    )
                case .failure(let error):
                    self.store.transition(
                        next: .fetched(.failure(GithubRepositoryListState.StateError(debugInfo: "cannot fetch")))
                    )
                }
            }
    }
}

class SearchGithubRepositoryListModelTests {
    func testSearch() {
        // let dataSourceStub = ...
        // let storeSpy = ...
        // let model = SearchGithubRepositoryListModel(store: StoreSpy, dataSource: dataSourceStub)
        // model.search(word: "test")
        // XCTAssertEqual(expected, storeSpy.callArgs.first!)
    }
}

// 画面更新
class SearchGithubRepositoryListRenderer {
    private let store: Store<GithubRepositoryListState>
    private let view: SearchGithubRepositoryListView
    private let disposeBag = DisposeBag()

    init(
        store: Store<GithubRepositoryListState>,
        view: SearchGithubRepositoryListView
    ) {
        self.store = store
        self.view = view

        self.store.state.subscribe(onNext: { [weak self] state in
                switch state {
                case .first:
                    self?.view.update()
                case .fetching:
                    self?.view.update()
                case let .fetched(.success(repositories)):
                    self?.view.update()
                case let .fetched(.failure(error)):
                    print(error)
                }
            })
            .disposed(by: self.disposeBag)

    }
}

class SearchGithubRepositoryListPassiveViewTests {
    func testSubscribe() {
        // let storeStub = ...
        // let viewSpy = ...
        // XCTAssertEqual(expected, viewSpy.callArgs.first!)
    }
}

enum GithubRepositoryListState {
    case first
    case fetching
    case fetched(Result<[GithubRepository], StateError>)

    struct StateError: Error {
        let debugInfo: String
    }
}
