//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import Foundation
import PromiseKit
import MirrorDiffKit

class GithubAPIClientTests: XCTestCase {

    struct TestCase {
        let description: String
        let responseResult: SearchList.Result<HTTPResponse, HTTPClientError>
        let expected: SearchList.Result<GithubAPIResponse, GithubAPIClientError>

        func apiClient() -> GithubAPIClient {
            return GithubAPIClient(
                httpClient: HTTPClientStub(result: self.responseResult)
            )
        }
    }

    // HTTPClient へ想定通りのリクエストを渡せているか確認する
    func testRequest() {
        let githubRequest = GithubAPIRequest(
            path: "/test",
            queries: [URLQueryItem(name: "name", value: "value")],
            method: .get
        )
        let httpClientSpy = HTTPClientSpy()
        let apiClient = GithubAPIClient(httpClient: httpClientSpy)

        let expected = HTTPRequest(
            url: URL(string: "https://api.github.com/test")!,
            queries: [URLQueryItem(name: "name", value: "value")],
            headers: [:],
            method: .get
        )


        PromiseTestKit.waitGuarantee(testCase: self) {
            return apiClient.fetch(request: githubRequest)
                .done { _ in
                    XCTAssertEqual(
                        expected, httpClientSpy.callArgs.first!,
                        diff(between: expected, and: httpClientSpy.callArgs.first!)
                    )
                }
        }

    }

    // HTTPClient からのレスポンスを任意の形式に変換できているか確認する
    func testFetchWhenGetResponse() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                description: "レスポンス取得成功",
                responseResult: .success(
                    HTTPResponse(
                        statusCode: .ok,
                        headers: [:],
                        payload: "success".data(using: .utf8)!
                    )
                ),
                expected: .success(
                    GithubAPIResponse(payload: "success".data(using: .utf8)!)
                )
            ),
            #line: TestCase(
                description: "HTTPステータスコードが 200 以外",
                responseResult: .success(
                    HTTPResponse(
                        statusCode: .notFound,
                        headers: [:],
                        payload: "not found".data(using: .utf8)!
                    )
                ),
                expected: .failure(.invalidStatusCode(code: .notFound))
            ),
            #line: TestCase(
                description: "通信エラー",
                responseResult: .failure(.notFoundDataOrResponse(debugInfo: "")),
                expected: .failure(.httpClientError(error: .notFoundDataOrResponse(debugInfo: "")))
            )
        ]

        let exampleRequest = GithubAPIRequest(
            path: "",
            queries: [],
            method: .get
        )

        testCases.forEach { testCase in
            PromiseTestKit.waitGuarantee(testCase: self) {
                return testCase.value.apiClient().fetch(request: exampleRequest)
                    .done { result in
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



struct HTTPClientStub: HTTPClientProtocol {
    private let result: SearchList.Result<HTTPResponse, HTTPClientError>

    init(result: SearchList.Result<HTTPResponse, HTTPClientError>) {
        self.result = result
    }

    func fetch(request: HTTPRequest) -> PromiseKit.Guarantee<SearchList.Result<HTTPResponse, HTTPClientError>> {
        return PromiseKit.Guarantee<SearchList.Result<HTTPResponse, HTTPClientError>>.value(self.result)
    }
}

class HTTPClientSpy: HTTPClientProtocol {
    var callArgs: [HTTPRequest] = []

    func fetch(request: HTTPRequest) -> Guarantee<SearchList.Result<HTTPResponse, HTTPClientError>> {
        self.callArgs.append(request)

        return PromiseKit.Guarantee<SearchList.Result<HTTPResponse, HTTPClientError>>.value(.failure(.notFoundDataOrResponse(debugInfo: "")))
    }
}
