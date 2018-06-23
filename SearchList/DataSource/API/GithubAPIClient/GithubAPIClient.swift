//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation
import PromiseKit

typealias GithubAPIClientResult = Result<GithubAPIResponse, GithubAPIClientError>

protocol GithubAPIClientProtocol {
    // NOTE: Error の詳細を伝える為、throws ではなく Result 型を利用する
    func fetch(request: GithubAPIRequest) -> Guarantee<GithubAPIClientResult>
}



/**
 プロダクトと GithubAPI 間の通信を行うクラス
**/
struct GithubAPIClient: GithubAPIClientProtocol {
    private static let baseURL = "https://api.github.com"
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetch(request githubRequest: GithubAPIRequest) -> Guarantee<GithubAPIClientResult> {
        guard let httpRequest = self.httpRequest(from: githubRequest) else {
            return Guarantee<GithubAPIClientResult>.value(
                .failure(.failedCreatingRequest(using: githubRequest))
            )
        }

        return self.httpClient.fetch(request: httpRequest)
            .map { (result: Result<HTTPResponse, HTTPClientError>) in
                switch result {
                case .success(let response):
                    return self.check(httpResponse: response)
                case .failure(let error):
                    return .failure(.httpClientError(error: error))
                }
            }

    }

    private func check(httpResponse: HTTPResponse) -> GithubAPIClientResult {
        switch httpResponse.statusCode {
        case .ok:
            return .success(GithubAPIResponse(payload: httpResponse.payload))
        case .notFound, .unprocessableEntity, .other:
            return .failure(.invalidStatusCode(code: httpResponse.statusCode))
        }
    }

    private func httpRequest(from githubRequest: GithubAPIRequest) -> HTTPRequest? {
        return githubRequest.transform(
            baseURL: GithubAPIClient.baseURL,
            // MEMO: 現状、指定しないでも特に問題がないので空のままにしている
            headers: [:]
        )
    }

}
