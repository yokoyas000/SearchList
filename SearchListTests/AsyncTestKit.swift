//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import XCTest
import PromiseKit

/**
 非同期テスト共通処理部分

 # 使用例
 ```
  func testRequest() {
      let expected = ...
      TestAsync.wait(testCase: self, description: "async test") {
         return API.get(word: "word")
             .done { response in
                 XCTAssertEqual(expected, response)
             }
      }
  }
 ```
 **/
enum AsyncTestKit {
    static func wait<T>(testCase: XCTestCase, block: () -> Promise<T>) {
        let e = testCase.expectation(description: "async test with Promise")

        block()
            .done { _ in
                e.fulfill()
            }
            .catch { error in
                XCTFail("Async Error: \(error)")
                e.fulfill()
            }

        testCase.wait(for: [e], timeout: 1.0)
    }
}
