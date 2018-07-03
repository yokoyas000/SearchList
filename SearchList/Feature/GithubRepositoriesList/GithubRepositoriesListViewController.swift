//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

class GithubRepositoriesListViewController: UITableViewController {
    private var apiClient: GithubAPIClientProtocol!
    private var repositoriesModel: GithubRepositoriesListModelProtocol!
    private var repositoriesStore: Store<GithubRepositoriesListState>!

    private var renderer: GithubRepositoriesListRenderer?
    private var controller: GithubRepositoriesListController?

    static func create(
        apiClient: GithubAPIClientProtocol,
        firstRepositories: [GithubRepository],
        searchParams: SearchGithubRepositoriesParams,
        perPage: Int
    ) -> GithubRepositoriesListViewController? {
        let vc = R.storyboard.githubRepositoriesListViewController.githubRepositoriesListViewController()
        vc?.apiClient = apiClient

        let store = Store<GithubRepositoriesListState>(
            initialState: .first(list: firstRepositories)
        )
        let model =  GithubRepositoriesListModel(
            searchParams: searchParams,
            perPage: perPage,
            dataSource: GithubSearchRepositoriesAPI(apiClient: apiClient),
            store: store
        )

        vc?.repositoriesStore = store
        vc?.repositoriesModel = model

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.renderer = GithubRepositoriesListRenderer(
            observing: self.repositoriesStore,
            update: self.tableView
        )
        self.tableView.dataSource = self.renderer

        self.controller = GithubRepositoriesListController(command: self.repositoriesModel)
        self.tableView.delegate = self.controller
    }
}
