//
// Created by yokoyas000 on 2018/06/20.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation

enum HTTPClientError: Error, Equatable {
    // リクエストの作成に失敗した場合
    case failedCreatingRequest(debugInfo: HTTPRequest)

    // URL通信の段階でエラーがあった場合
    // SEE: https://developer.apple.com/documentation/foundation/url_loading_system
    case urlLoadingSystemError(error: URLLoadingSystemError)

    // レスポンスのデータまたはレスポンス自体が存在しない場合
    case notFoundDataOrResponse(debugInfo: String)



    /**
     NSURL関連のエラー
     NOTE: Foundation ライブラリ内では Int で定義されているので識別しやすいように型にする
        全てのエラーコードを定義するのは大変かつ現状不要なので, 主要なもののみ定義する
     SEE: https://developer.apple.com/documentation/foundation/1508628-url_loading_system_error_codes
     **/
    enum URLLoadingSystemError: Error, Equatable {
        case timeout
        case cancelled
        case cannotFindHost
        case otherError(errorCode: Int)

        static func from(errorCode: Int) -> URLLoadingSystemError {
            switch errorCode {
            case NSURLErrorTimedOut:
                return .timeout
            case NSURLErrorCancelled:
                return .cancelled
            case NSURLErrorCannotFindHost:
                return .cannotFindHost
            default:
                return .otherError(errorCode: errorCode)
            }
        }
    }
}