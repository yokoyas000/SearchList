//
// Created by yokoyas000 on 2018/06/18.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation
import PromiseKit

/**
 Githubの検索APIを利用して検索結果を取得するクラス
 see: https://developer.github.com/v3/search/#search-repositories
 **/
struct GithubSearchRepositoriesAPI: GithubRepositoryDataSourceProtocol {
    private static let apiPath = "/search/repositories"
    private let apiClient: GithubAPIClientProtocol

    init(apiClient: GithubAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func search(text: String, page: Int? = nil, perPage: Int? = nil) -> Guarantee<Result<[GithubRepository], DataSourceError>> {
        return self.apiClient.fetch(
                request: self.githubRequest(text: text, page: page, parPage: perPage)
            )
            .map { result -> Result<[GithubRepository], DataSourceError> in
                switch result {
                case .success(let response):
                    do {
                        let response = try GithubSearchRepositoriesAPI.Response.create(from: response.payload)
                        return  .success(response.repositories)
                    }
                    catch {
                        let debugInfo = String(data: response.payload, encoding: .utf8) ?? "cannot UTF8 Encoding"
                        return .failure(.failedTransformFromData(
                            debugInfo: debugInfo
                        ))
                    }

                case .failure:
                    return .failure(.networkError(debugInfo: "Failed GET: \(GithubSearchRepositoriesAPI.apiPath)"))
                }
            }
    }

    private func githubRequest(text: String, page: Int?, parPage: Int?) -> GithubAPIRequest {
        var queries = [URLQueryItem(name: "q", value: text)]
        if let page = page {
            queries.append(URLQueryItem(name: "page", value: String(describing: page)))
        }
        if let parPage = parPage {
            queries.append(URLQueryItem(name: "per_page", value: String(describing: parPage)))
        }

        return GithubAPIRequest(
            path: GithubSearchRepositoriesAPI.apiPath,
            queries: queries,
            method: .get
        )
    }

}
