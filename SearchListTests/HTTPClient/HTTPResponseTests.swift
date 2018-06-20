//
// Created by yokoyas000 on 2018/06/21.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import Foundation
import MirrorDiffKit

class HTTPResponseTests: XCTestCase {

    func testCreate() {
        let data = "data".data(using: .utf8)!
        let httpUrlResponse = HTTPURLResponse(
            url: URL(string: "http://test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["header": "header"]
        )!

        let expected = HTTPResponse(
            statusCode: HTTPStatusCode.ok,
            headers: ["header": "header"],
            payload: "data".data(using: .utf8)!
        )

        let actual = HTTPResponse.from(data: data, response: httpUrlResponse)

        XCTAssertEqual(expected, actual, diff(between: expected, and: actual))
    }
}
