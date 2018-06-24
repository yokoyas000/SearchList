//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

/**
 NOTE: Optional<String> で表しても良かったが、
        それだと「nil or "" = 検索に使えない文字列」という意味を持たせられないので
        別途、型を定義した。
 **/
enum SearchGithubRepositoriesTextState {
    // 検索に使えない文字列
    case invalid

    // 検索可能な文字列
    case valid(text: String)
}
