//
// Created by yokoyas000 on 2018/06/25.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

protocol NavigatorProtocol {
    func navigate(next: UIViewController, animated: Bool)
}


class Navigator: NavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigate(next: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(next, animated: animated)
    }
}
