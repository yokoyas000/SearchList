//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

class SearchGithubRepositoriesViewController: UIViewController {
    private var apiClient: GithubAPIClient!
    private var controller: SearchGithubRepositoriesController?
    private var renderer: SearchGithubRepositoriesRenderer?
    private var navigator: SearchGithubRepositoriesNavigator?

    static func create(apiClient: GithubAPIClient) -> SearchGithubRepositoriesViewController? {
        let vc = R.storyboard.searchGithubRepositoriesViewController.searchGithubRepositoriesViewController()
        vc?.apiClient = apiClient

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let rootView = SearchGithubRepositoriesView()
        self.view = rootView

        let repositoriesStore = Store<SearchGithubRepositoriesState>(initialState: .first)
        let searchModel = SearchGithubRepositoriesModel(
            store: repositoriesStore,
            dataSource: GithubSearchRepositoriesAPI(apiClient: self.apiClient)
        )

        let textStore = Store<SearchGithubRepositoriesTextState>(initialState: .invalid)
        let searchTextModel = SearchGithubRepositoriesTextModel(store: textStore)

        self.controller = SearchGithubRepositoriesController(
            handle: rootView,
            searchModel: searchModel,
            textStore: textStore,
            textModel: searchTextModel
        )

        self.navigator = SearchGithubRepositoriesNavigator(
            navigator: Navigator(navigationController: self.navigationController),
            navigationArgs: (
                apiClient: self.apiClient,
                store: repositoriesStore
            )
        )

        self.renderer = SearchGithubRepositoriesRenderer(
            view: rootView,
            textStore: textStore,
            repositoriesStore: repositoriesStore
        )
    }
}
