//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest

class GithubRepositoryTests: XCTestCase {

    func testDecode() {
        let jsonData = """
        {
          "id": 34222505,
          "name": "WWDC",   
          "full_name": "insidegui/WWDC"
        }
        """.data(using: .utf8)!

        let expected = GithubRepository(
            id: GithubRepositoryID(34222505),
            name: "WWD",
            fullName: "insidegui/WWDC"
        )

        let result = try! GithubRepository.create(from: jsonData)

        XCTAssertEqual(expected, result)
    }
}
