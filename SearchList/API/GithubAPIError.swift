//
// Created by yokoyas000 on 2018/06/21.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

enum GithubAPIError: Error, Equatable {
    // 通信の段階で何かしら問題があった場合
    case apiClientError(error: GithubAPIClientError)

    // 構造体への変換に失敗した場合
    case failedTransformFromData(debugInfo: String)
}
