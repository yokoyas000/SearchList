//
// Created by yokoyas000 on 2018/06/21.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation

struct GithubAPIRequest: Equatable {
    let path: String
    let queries: [URLQueryItem]
    let method: HTTPMethod

    func transform(baseURL: String, headers: [String: String]) -> HTTPRequest? {
        guard let url = URL(string: baseURL + self.path) else {
            return nil
        }

        return HTTPRequest(
            url: url,
            queries: self.queries,
            headers: headers,
            method: self.method
        )
    }
}