//
// Created by yokoyas000 on 2018/06/14.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import PromiseKit

class GithubSearchRepositoriesAPITests: XCTestCase {

    func testRequest() {
        let expected = GithubSearchRepositoriesAPIResponseCatalog.twoRepositories.expected

        AsyncTestKit.wait(testCase: self, description: "GET GithubSearchRepositoriesAPI") {
            return GithubSearchRepositoriesAPI.get(word: "wwdc")
                .done { response in
                    XCTAssertEqual(expected, response)
                }
        }

    }

}
