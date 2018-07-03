//
// Created by yokoyas000 on 2018/06/28.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import MirrorDiffKit

class GithubRepositoriesListStateTests: XCTestCase {

    struct TestCase {
        let description: String
        let state: GithubRepositoriesListState
        let expected: [GithubRepository]
    }

    // どの Enum Case でも想定の [GithubRepository] が帰ってくること
    func testRepositories() {
        let testCases: [UInt: TestCase] = [
            #line: TestCase(
                description: "first",
                state: .first(list: [
                    GithubRepository(id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ]),
                expected: [
                    GithubRepository(id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ]
            ),
            #line: TestCase(
                description: "fetching",
                state: .fetching(currentList: [
                    GithubRepository(id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ]),
                expected: [
                    GithubRepository(id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ]
            ),
            #line: TestCase(
                description: "fetchedSuccess",
                state: .fetched(.success(
                    GithubRepositoriesListState.FetchedSuccess(
                        currentList: [
                            GithubRepository(id: GithubRepositoryID(111),
                                name: "currentName",
                                fullName: "currentFullName"
                            )
                        ],
                        nextPage: [
                            GithubRepository(id: GithubRepositoryID(222),
                                name: "nextName",
                                fullName: "nextFullName"
                            )
                        ]
                    )
                )),
                expected: [
                    GithubRepository(id: GithubRepositoryID(111),
                        name: "currentName",
                        fullName: "currentFullName"
                    ),
                    GithubRepository(id: GithubRepositoryID(222),
                        name: "nextName",
                        fullName: "nextFullName"
                    )
                ]
            ),
            #line: TestCase(
                description: "fetchedFailure",
                state: .fetched(.failure(
                    GithubRepositoriesListState.FetchedFailure(
                        currentList: [
                            GithubRepository(id: GithubRepositoryID(111),
                                name: "currentName",
                                fullName: "currentFullName"
                            )
                        ],
                        error: .failedTransformFromData(debugInfo: "Dummy Error")
                    )
                )),
                expected: [
                    GithubRepository(id: GithubRepositoryID(111),
                        name: "currentName",
                        fullName: "currentFullName"
                    ),
                ]
            )
        ]

        testCases.forEach { testCase in
            XCTAssertEqual(
                testCase.value.expected,
                testCase.value.state.repositories,
                diff(between: testCase.value.expected, and: testCase.value.state.repositories),
                line: testCase.key
            )
        }
    }
}