//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

enum DataSourceError: Error, Equatable {
    // 外部との通信で何かしら問題があった場合
    case networkError

    // 構造体への変換に失敗した場合
    case failedTransformFromData(debugInfo: String)
}
