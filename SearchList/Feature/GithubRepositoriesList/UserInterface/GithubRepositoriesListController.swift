//
// Created by yokoyas000 on 2018/06/26.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

class GithubRepositoriesListController: NSObject {
    private let useCase: GithubRepositoriesListUseCaseProtocol

    init(
        command useCase: GithubRepositoriesListUseCaseProtocol
    ) {
        self.useCase = useCase
    }
}



extension GithubRepositoriesListController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging
               && scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height {
            self.useCase.getNextPage()
        }
    }
}
