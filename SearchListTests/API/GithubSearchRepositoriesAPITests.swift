//
// Created by yokoyas000 on 2018/06/14.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import PromiseKit

class GithubSearchRepositoriesAPITests: XCTestCase {

    func testRequest() {
        let api = GithubSearchRepositoriesAPI(
            resource: GithubAPIResourceStub(jsonData: GithubSearchRepositoriesAPIResponseCatalog.twoRepositories.responseData)
        )
        let expected = GithubSearchRepositoriesAPIResponseCatalog.twoRepositories.expected

        AsyncTestKit.wait(testCase: self) {
            return api.get(word: "test")
                .done { response in
                    XCTAssertEqual(expected, response)
                }
        }

    }

}

struct GithubAPIResourceStub: GithubAPIResourceProtocol {
    private let jsonData: Data

    init(jsonData: Data) {
        self.jsonData = jsonData
    }

    func get() -> Promise<Data> {
        return Promise<Data>.value(self.jsonData)
    }
}