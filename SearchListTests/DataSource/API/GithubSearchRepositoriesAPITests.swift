//
// Created by yokoyas000 on 2018/06/14.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import PromiseKit
import MirrorDiffKit

class GithubSearchRepositoriesAPITests: XCTestCase {

    struct TestCase {
        let description: String
        let apiClientResult: GithubAPIClientResult
        let expected: SearchList.Result<[GithubRepository], DataSourceError>
    }

    // APIClient へ想定通りのリクエストを渡せているか確認する
    func testTransformRequest() {
        // Arrange
        let testParams: (word: String, page: Int?, perPage: Int?) = (
            word: "test",
            page: 1,
            perPage: 2
        )
        let expected = GithubAPIRequest(
            path: "/search/repositories",
            queries: [
                URLQueryItem(name: "q", value: "test"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "per_page", value: "2")
            ],
            method: .get
        )
        let apiClientSpy = GithubAPIClientSpy()
        let api = GithubSearchRepositoriesAPI(apiClient: apiClientSpy)

        // Act
        PromiseTestKit.wait(testCase: self) {
            return api.search(
                    word: testParams.word,
                    page: testParams.page,
                    perPage: testParams.perPage
                )
                .done { _ in
                    // Assert
                    XCTAssertEqual(expected, apiClientSpy.callArgs.first!)
                }
        }
    }

    // APIClient のレスポンスを任意の形式に変換できているか確認する
    func testFetchResponse() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                description: "複数の Github リポジトリを取得できた場合",
                apiClientResult: .success(
                    GithubAPIResponse(
                        payload: GithubSearchRepositoriesAPIResponseCatalog.twoRepositories.responseData
                    )
                ),
                expected: .success(
                    GithubSearchRepositoriesAPIResponseCatalog.twoRepositories.expected.repositories
                )
            ),
            #line: TestCase(
                description: "検索結果が0件だった場合",
                apiClientResult: GithubAPIClientResult.success(
                    GithubAPIResponse(payload: """
                    {
                        "total_count": 0,
                        "incomplete_results": false,
                        "items": []
                    }
                    """.data(using: .utf8)!)
                ),
                expected: .success([])
            ),
            #line: TestCase(
                description: "APIClient が Error を返した場合",
                apiClientResult: .failure(.invalidStatusCode(code: .notFound)),
                expected: .failure(.networkError)
            ),
            #line: TestCase(
                description: "レスポンスを構造体へ変換する工程で Error が生じた場合",
                apiClientResult: GithubAPIClientResult.success(
                    GithubAPIResponse(payload: """
                    {
                        "total_count": 0,
                        "incomplete_results": false
                    }
                    """.data(using: .utf8)!)
                ),
                expected: .failure(
                    .failedTransformFromData(debugInfo: """
                    {
                        "total_count": 0,
                        "incomplete_results": false
                    }
                    """)
                )
            ),
        ]

        testCases.forEach { testCase in
            let api = GithubSearchRepositoriesAPI(
                apiClient: GithubAPIClientStub(result: testCase.value.apiClientResult)
            )

            PromiseTestKit.wait(testCase: self) {
                return api.search(word: "test")
                    .done { (result: SearchList.Result<[GithubRepository], DataSourceError>) in
                        switch (testCase.value.expected, result) {
                        case let (.success(expected), .success(actual)):
                            XCTAssertEqual(
                                expected, actual,
                                diff(between: expected, and: actual),
                                line: testCase.key
                            )
                        case let (.failure(expected), .failure(actual)):
                            XCTAssertEqual(
                                expected, actual,
                                diff(between: expected, and: actual),
                                line: testCase.key
                            )
                        default:
                            XCTFail(line: testCase.key)
                        }
                    }
            }
        }
    }

}



struct GithubAPIClientStub: GithubAPIClientProtocol {
    private let result: GithubAPIClientResult

    init(result: GithubAPIClientResult) {
        self.result = result
    }

    func fetch(request: GithubAPIRequest) -> PromiseKit.Guarantee<GithubAPIClientResult> {
        return Guarantee<GithubAPIClientResult>.value(result)
    }
}



class GithubAPIClientSpy: GithubAPIClientProtocol {
    var callArgs: [GithubAPIRequest] = []

    func fetch(request: GithubAPIRequest) -> Guarantee<GithubAPIClientResult> {
        self.callArgs.append(request)
        return Guarantee<GithubAPIClientResult>.value(.failure(.invalidStatusCode(code: .notFound)))
    }
}
