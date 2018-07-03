//
// Created by yokoyas000 on 2018/06/26.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

class GithubRepositoriesListController: NSObject {
    private let model: GithubRepositoriesListModelProtocol

    init(
        command model: GithubRepositoriesListModelProtocol
    ) {
        self.model = model
    }
}



extension GithubRepositoriesListController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging
               && scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height {
            self.model.getNextPage()
        }
    }
}
