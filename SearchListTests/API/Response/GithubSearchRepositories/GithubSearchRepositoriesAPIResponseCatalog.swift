//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

@testable import SearchList
import Foundation

/**
 GithubSearchRepositoriesAPI の JSON <-> Swift の変換を確認するテスト用の値の一覧
 テストケースが増えたらここに追加していく(予定
 **/
enum GithubSearchRepositoriesAPIResponseCatalog {

    struct Entry {
        let description: String
        let responseData: Data
        let expected: GithubSearchRepositoriesAPIResponse
    }

    static let twoRepositories = Entry(
        description: "リポジトリが２つ(複数)の場合",
        responseData: JsonReader.data(from: R.file.githubSearchRepositoriesAPIResponseJson.path()!),
        expected:
            GithubSearchRepositoriesAPIResponse(
                repositories: [
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
            )
    )
}
