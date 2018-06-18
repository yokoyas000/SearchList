//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

/**
 NOTE: ### "id: Int" にしない理由
       - "user_id" と "repository_id" など、別カテゴリのIDの誤った代入や比較を避けるため
 **/
struct GithubRepositoryID: Equatable {
    let value: Int

    init(_ value: Int) {
        self.value = value
    }
}
