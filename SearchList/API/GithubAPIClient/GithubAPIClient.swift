//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation
import PromiseKit


protocol GithubAPIClientProtocol {
    // NOTE: Error の詳細を伝える為、throws ではなく Result 型を利用する
    func fetch(request: HTTPRequest) -> Guarantee<Result<GithubAPIResponse, GithubAPIClientError>>
}



/**
 プロダクトと GithubAPI 間の通信を行うクラス
**/
struct GithubAPIClient: GithubAPIClientProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetch(request: HTTPRequest) -> Guarantee<Result<GithubAPIResponse, GithubAPIClientError>> {
        return self.httpClient.fetch(request: request)
            .map { (result: Result<HTTPResponse, HTTPClientError>) in
                switch result {
                case .success(let response):
                    return self.check(httpResponse: response)
                case .failure(let error):
                    return .failure(.httpClientError(error: error))
                }
            }

    }

    private func check(httpResponse: HTTPResponse) -> Result<GithubAPIResponse, GithubAPIClientError> {
        switch httpResponse.statusCode {
        case .ok:
            return .success(GithubAPIResponse(payload: httpResponse.payload))
        case .notFound, .unprocessableEntity, .other:
            return .failure(.invalidStatusCode(code: httpResponse.statusCode))
        }
    }

}
