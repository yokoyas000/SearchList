//
// Created by yokoyas000 on 2018/06/20.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import PromiseKit

class HTTPClientTests: XCTestCase {

    // 実際に HTTP レスポンスを受け取れることを確認する
    func testRequestSuccess() {
        // Arrange
        let client = HTTPClient()
        let request = HTTPRequest(
            url: URL(string: "https://github.com")!,
            queries: [],
            headers: [:],
            method: .get
        )

        // Act
        AsyncTestKit.wait(testCase: self) {
            return client.fetch(request: request)
                .done { result in

                    // Assert
                    XCTAssertTrue(self.responseIsSuccess(result: result))
                }
        }
    }

    // HTTP リクエストに失敗した場合、エラーを返すことを確認する
    func testRequestFailure() {
        // Arrange
        let client = HTTPClient()
        let request = HTTPRequest(
            url: URL(string: "https://testForFailure")!,
            queries: [],
            headers: [:],
            method: .get
        )

        // Act
        AsyncTestKit.wait(testCase: self) {
            return client.fetch(request: request)
                .done { result in

                    // Assert
                    XCTAssertFalse(self.responseIsSuccess(result: result))
                }
        }
    }

    private func responseIsSuccess(result: SearchList.Result<HTTPResponse, HTTPClientError>) -> Bool {
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }

}
