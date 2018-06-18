//
// Created by yokoyas000 on 2018/06/14.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest

class GithubSearchRepositoriesAPITests {

    func testRequest() {
        let result = GithubSearchRepositoriesAPI.get(word: "wwdc")
        XCTAssertEqual("wwdc", result)
    }

}
