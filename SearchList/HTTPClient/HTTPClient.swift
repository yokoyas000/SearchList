//
// Created by yokoyas000 on 2018/06/20.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation
import PromiseKit



protocol HTTPClientProtocol {
    // HTTP リクエストを送信する
    // NOTE: Error の詳細を伝える為、throws ではなく Result 型を利用する
    func fetch(request: HTTPRequest) -> Guarantee<Result<HTTPResponse, HTTPClientError>>
}



/**
 - 与えられた HTTP リクエストの送信
 - HTTP レスポンスの受け取り
    - レスポンスを扱いやすい形へ変換
 **/
struct HTTPClient: HTTPClientProtocol {
    func fetch(request httpRequest: HTTPRequest) -> Guarantee<Result<HTTPResponse, HTTPClientError>> {
        guard let request = httpRequest.transform() else {
            return Guarantee<Result<HTTPResponse, HTTPClientError>>.value(
                .failure(.failedCreatingRequest(debugInfo: httpRequest))
            )
        }

        return Guarantee<Result<HTTPResponse, HTTPClientError>> { resolver in
            let task = URLSession
                .shared
                .dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

                if let urlLoadingError = self.urlLoadingError(error: error) {
                    let error = HTTPClientError.urlLoadingSystemError(error: urlLoadingError)
                    resolver(.failure(error))
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse else {
                    let error = HTTPClientError.notFoundDataOrResponse(debugInfo: error.debugDescription)
                    resolver(.failure(error))

                    return
                }

                let result = HTTPResponse.from(data: data, response: response)
                resolver(.success(result))
            }

            // 通信開始
            task.resume()
        }
    }

    private func urlLoadingError(error: Error?) -> HTTPClientError.URLLoadingSystemError? {
        guard let error = error else {
            return nil
        }

        let nsError = error as NSError
        guard nsError.domain == NSURLErrorDomain else {
            return nil
        }

        return HTTPClientError.URLLoadingSystemError.from(errorCode: nsError.code)
    }

}
