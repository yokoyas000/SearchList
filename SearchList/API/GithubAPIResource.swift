//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation
import PromiseKit

/// TODO: ネットワーク部分
protocol GithubAPIResourceProtocol {
    func get() -> Promise<Data>
}



struct GithubAPIResource: GithubAPIResourceProtocol {
    func get() -> Promise<Data> {
        return Promise<Data> { resolver in
            resolver.fulfill(Data())
        }
    }
}
