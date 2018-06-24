//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import UIKit

protocol SearchGithubRepositoriesViewProtocol {
    var searchWordTextField: UITextField! { get set }
    var searchButton: SearchGithubRepositoriesButton! { get set }
    var indicator: UIActivityIndicatorView! { get set }
    var searchLabel: UILabel! { get set }
}

class SearchGithubRepositoriesView: UIView, SearchGithubRepositoriesViewProtocol {
    @IBOutlet weak var searchWordTextField: UITextField!
    @IBOutlet weak var searchButton: SearchGithubRepositoriesButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
    }

    private func loadFromNib() {
        guard let view = R.nib.searchGithubRepositoriesView().instantiate(withOwner: self).first as? UIView else {
            return
        }

        view.frame = self.bounds
        self.addSubview(view)
    }
}
