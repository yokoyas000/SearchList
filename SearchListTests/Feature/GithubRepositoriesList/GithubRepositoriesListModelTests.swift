//
// Created by yokoyas000 on 2018/06/25.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import XCTest
import MirrorDiffKit

class GithubRepositoriesListTests: XCTestCase {

    struct TestCaseForTestGetFromDataSource {
        let description: String
        let currentList: [GithubRepository]
        let perPage: Int
        let expected: (getNextPageCount: Int, perPage: Int)
    }

    struct TestCaseForTestStateTransition {
        let description: String
        let currentState: GithubRepositoriesListState
        let expected: GithubRepositoriesListState
    }

    // DataSource から値を取得するときの動作(引数)が想定通りになっているか確認する
    func testGetFromDataSource() {
        let testCases: [UInt: TestCaseForTestGetFromDataSource] = [
            #line: TestCaseForTestGetFromDataSource(
                description: "現在のリストが空の場合",
                currentList: [],
                perPage: 2,
                expected: (getNextPageCount: 1, perPage: 2)
            ),
            #line: TestCaseForTestGetFromDataSource(
                description: "現在のリストが1ページ分未満の場合",
                currentList: [
                    GithubRepository(
                        id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ],
                perPage: 2,
                expected: (getNextPageCount: 1, perPage: 2)
            ),
            #line: TestCaseForTestGetFromDataSource(
                description: "現在のリストが1ページ分ぴったりの場合",
                currentList: [
                    GithubRepository(
                        id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    ),
                    GithubRepository(
                        id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ],
                perPage: 2,
                expected: (getNextPageCount: 2, perPage: 2)
            ),
            #line: TestCaseForTestGetFromDataSource(
                description: "現在のリストが1ページ分より1つ多いが、次ページ分には満たない場合",
                currentList: [
                    GithubRepository(
                        id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    ),
                    GithubRepository(
                        id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    ),
                    GithubRepository(
                        id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ],
                perPage: 2,
                expected: (getNextPageCount: 2, perPage: 2)
            ),
        ]

        testCases.forEach { testCase in
            let dataSourceSpy = GithubRepositoryDataSourceSpy()

            let model = GithubRepositoriesListModel(
                searchParams: SearchGithubRepositoriesParams(text: "test"),
                perPage: testCase.value.perPage,
                dataSource: dataSourceSpy,
                store: Store<GithubRepositoriesListState>(
                    initialState: .first(list: testCase.value.currentList)
                )
            )
            model.getNextPage()

            let expected = GithubRepositoryDataSourceSpy.CallArgs.search(
                text: "test",
                page: testCase.value.expected.getNextPageCount,
                perPage: testCase.value.expected.perPage
            )
            let actual = dataSourceSpy.callArgs.first!

            XCTAssertEqual(
                expected, actual,
                diff(between: expected, and: actual),
                line: testCase.key
            )
        }
    }

    // 状態遷移が想定通りに行われていること
    func testStateTransition() {
        let testCases: [UInt: TestCaseForTestStateTransition] = [
            #line: TestCaseForTestStateTransition(
                description: "first -> fetching",
                currentState: .first(list: [
                    GithubRepository(
                        id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ]),
                expected: .fetching(currentList: [
                    GithubRepository(
                        id: GithubRepositoryID(111),
                        name: "name",
                        fullName: "fullName"
                    )
                ])
            ),
            #line: TestCaseForTestStateTransition(
                description: "fetched(.success) -> fetching(currentList:) の時、 currentList に全ての GithubRepository が入っていること",
                currentState: .fetched(.success(
                    GithubRepositoriesListState.FetchedSuccess(
                        currentList: [
                            GithubRepository(
                                id: GithubRepositoryID(111),
                                name: "name",
                                fullName: "fullName"
                            )
                        ],
                        nextPage: [
                            GithubRepository(
                                id: GithubRepositoryID(222),
                                name: "name2",
                                fullName: "fullName2"
                            )
                        ]
                    )
                )),
                expected: .fetching(
                    currentList: [
                        GithubRepository(
                            id: GithubRepositoryID(111),
                            name: "name",
                            fullName: "fullName"
                        ),
                        GithubRepository(
                            id: GithubRepositoryID(222),
                            name: "name2",
                            fullName: "fullName2"
                        )
                    ]
                )
            ),
            #line: TestCaseForTestStateTransition(
                description: "fetched(.failure) -> .fetching の時、 currentList が引き継がれていること",
                currentState: .fetched(.failure(
                    GithubRepositoriesListState.FetchedFailure(
                        currentList: [
                            GithubRepository(
                                id: GithubRepositoryID(111),
                                name: "name",
                                fullName: "fullName"
                            )
                        ],
                        error: .networkError(debugInfo: "")
                    )
                )),
                expected: .fetching(
                    currentList: [
                        GithubRepository(
                            id: GithubRepositoryID(111),
                            name: "name",
                            fullName: "fullName"
                        )
                    ]
                )
            )
        ]

        let dummy = (
            searchParams: SearchGithubRepositoriesParams(text: "dummy"),
            perPage: 20,
            dataSource: GithubRepositoryDataSourceSpy()
        )

        testCases.forEach { testCase in
            let storeSpy = StoreSpy<GithubRepositoriesListState>(initialState: testCase.value.currentState)
            let model = GithubRepositoriesListModel(
                searchParams: dummy.searchParams,
                perPage: dummy.perPage,
                dataSource: dummy.dataSource,
                store: storeSpy
            )

            model.getNextPage()

            let actual = storeSpy.callArgs.first!

            XCTAssertEqual(
                testCase.value.expected,
                actual,
                diff(between: testCase.value.expected, and: actual),
                line: testCase.key
            )
        }
    }
}

class StoreSpy<State>: Store<State> {
    private(set) var callArgs: [State] = []

    override func transition(next state: State) {
        self.callArgs.append(state)
    }
}