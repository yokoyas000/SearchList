//
// Created by yokoyas000 on 2018/06/20.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

enum GithubAPIClientError: Error, Equatable {
    // HTTP リクエスト送信/受信の段階でエラーがある場合
    case httpClientError(error: HTTPClientError)

    // HTTP ステータスコードが 200 以外の場合
    case invalidStatusCode(code: HTTPStatusCode)
}