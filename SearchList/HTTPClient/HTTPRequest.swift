//
// Created by yokoyas000 on 2018/06/20.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation

struct HTTPRequest: Equatable {
    let url: URL
    let queries: [URLQueryItem]
    let headers: [String: String]
    let method: HTTPMethod

    func transform() -> URLRequest? {
        var components = URLComponents(string: self.url.description)
        components?.queryItems = self.queries
        guard let urlWithQueries = components?.url else {
            return nil
        }

        return self.create(
            url: urlWithQueries,
            headers: self.headers,
            method: self.method.string,
            payload: self.method.payload
        )
    }

    private func create(url: URL, headers: [String: String], method: String, payload: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        request.httpBody = payload

        return request
    }
}



enum HTTPMethod: Equatable {
    case get
    case post(payload: Data?)

    var string: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }

    var payload: Data? {
        switch self {
        case .get:
            return nil
        case .post(let payload):
            return payload
        }
    }
}