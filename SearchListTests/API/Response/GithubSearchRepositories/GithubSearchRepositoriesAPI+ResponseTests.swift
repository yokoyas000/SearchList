//
// Created by yokoyas000 on 2018/06/18.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest

import Foundation
class GithubSearchRepositoriesAPI_ResponseTests: XCTestCase {

    func testDecode() {
        let result = JsonReader.dictionary(from: R.file.githubSearchRepositoriesAPIResponseJson.path()!)
        print(result)
    }
}
