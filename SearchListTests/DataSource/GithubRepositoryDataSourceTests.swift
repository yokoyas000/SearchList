//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import PromiseKit
import MirrorDiffKit

class GithubRepositoryDataSourceTests: XCTestCase {

    func testGetGithubRepository() {
        let repositories = [
            GithubRepository(
                id: GithubRepositoryID(34222505),
                name: "WWDC",
                fullName: "insidegui/WWDC"
            ),
            GithubRepository(
                id: GithubRepositoryID(11025353),
                name: "wwdc-downloader",
                fullName: "ohoachuck/wwdc-downloader"
            ),
        ]

        let dataSource = GithubRepositoryDataSource(
            using: GithubSearchRepositoriesAPIStub(
                response: GithubSearchRepositoriesAPIResponse(repositories: repositories)
            )
        )

        AsyncTestKit.wait(testCase: self) {
            return dataSource.get()
                .done { result in
                    XCTAssertEqual(
                        repositories,
                        result,
                        diff(between: repositories, and: result)
                    )
                }
        }

    }
}


struct GithubSearchRepositoriesAPIStub: GithubSearchRepositoriesAPIProtocol {
    private let response: GithubSearchRepositoriesAPIResponse

    init(response: GithubSearchRepositoriesAPIResponse) {
        self.response = response
    }

    func get(word: String) -> Promise<GithubSearchRepositoriesAPIResponse> {
        return Promise<GithubSearchRepositoriesAPIResponse> { (resolver: Resolver<GithubSearchRepositoriesAPIResponse>) -> Void in
            resolver.fulfill(self.response)
        }
    }
}