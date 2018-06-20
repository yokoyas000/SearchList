//
// Created by yokoyas000 on 2018/06/20.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation

struct HTTPResponse {
    let statusCode: HTTPStatusCode
    let headers: [String: String]
    let payload: Data

    static func from(data: Data, response: HTTPURLResponse) -> HTTPResponse {
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields {
            headers[key.description] = String(describing: value)
        }

        return HTTPResponse(
            statusCode: .from(code: response.statusCode),
            headers: headers,
            payload: data
        )
    }
}

enum HTTPStatusCode {
    case ok
    case notFound
    case unprocessableEntity
    case other(code: Int)

    static func from(code: Int) -> HTTPStatusCode {
        switch code {
        case 200:
            return .ok
        case 404:
            return .notFound
        case 422:
            return .unprocessableEntity
        default:
            return .other(code: code)
        }
    }
}
