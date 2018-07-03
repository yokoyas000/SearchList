//
//  Created by yokoyas000 on 2018/06/26.
//  Copyright © 2018年 yokoyas000. All rights reserved.
//

import UIKit

class GithubRepositoriesListCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    static func register(tableView: UITableView) -> RegisteredToken {
        tableView.register(R.nib.githubRepositoriesListCell)
        return RegisteredToken()
    }

    static func dequeueReusableCell(
        from tableView: UITableView,
        token: RegisteredToken,
        githubRepository: GithubRepository
        ) -> GithubRepositoriesListCell {
        // NOTE: ここで落ちる場合は storyboard もしくはコード上で register を忘れている
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.githubRepositoriesListCell.identifier)! as! GithubRepositoriesListCell

        cell.titleLabel.text = githubRepository.name
        cell.detailLabel.text = githubRepository.fullName
        return cell
    }



    struct RegisteredToken {
        fileprivate init() {}
    }
}
