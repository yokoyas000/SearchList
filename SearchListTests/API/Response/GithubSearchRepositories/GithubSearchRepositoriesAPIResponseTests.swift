//
// Created by yokoyas000 on 2018/06/18.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest

class GithubSearchRepositoriesAPI_ResponseTests: XCTestCase {

    func testDecode() {
        XCTAssertEqual(
            GithubSearchRepositoriesAPIResponseCatalog.twoRepositories.expected,
            try! GithubSearchRepositoriesAPIResponse.create(
                from: GithubSearchRepositoriesAPIResponseCatalog.twoRepositories.responseData
            ),
            GithubSearchRepositoriesAPIResponseCatalog.twoRepositories.description
        )
    }
}

