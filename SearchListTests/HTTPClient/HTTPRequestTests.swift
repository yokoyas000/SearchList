//
// Created by yokoyas000 on 2018/06/21.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import Foundation
import MirrorDiffKit

class HTTPRequestTests: XCTestCase {

    struct TestCase {
        let description: String
        let httpRequest: HTTPRequest
        let expected: () -> URLRequest
    }

    func testTransformToURLRequest() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                description: "GET Request",
                httpRequest: HTTPRequest(
                    url: URL(string: "https://test")!,
                    queries: [
                        URLQueryItem(name: "query1", value: "value1"),
                        URLQueryItem(name: "query2", value: "value2")
                    ],
                    headers: ["header": "header"],
                    method: .get
                ),
                expected: {
                    var urlRequest = URLRequest(url: URL(
                        string: "https://test" +
                            "?query1=value1" +
                            "&query2=value2"
                    )!)
                    urlRequest.allHTTPHeaderFields = ["header": "header"]
                    urlRequest.httpMethod = "GET"
                    urlRequest.httpBody = nil

                    return urlRequest
                }
            ),
            #line: TestCase(
                description: "POST Request",
                httpRequest: HTTPRequest(
                    url: URL(string: "https://test")!,
                    queries: [
                        URLQueryItem(name: "query1", value: "value1"),
                        URLQueryItem(name: "query2", value: "value2")
                    ],
                    headers: ["header": "header"],
                    method: .post(payload: "payload".data(using: .utf8))
                ),
                expected: {
                    var urlRequest = URLRequest(url: URL(
                        string: "https://test" +
                            "?query1=value1" +
                            "&query2=value2"
                    )!)
                    urlRequest.allHTTPHeaderFields = ["header": "header"]
                    urlRequest.httpMethod = "POST"
                    urlRequest.httpBody = "payload".data(using: .utf8)

                    return urlRequest
                }
            ),
        ]

        testCases.forEach { testCase in
            let actual = testCase.value.httpRequest.transform()
            XCTAssertEqual(
                testCase.value.expected(), actual,
                diff(between: testCase.value.expected(), and: actual),
                line: testCase.key
            )
        }
    }
}
