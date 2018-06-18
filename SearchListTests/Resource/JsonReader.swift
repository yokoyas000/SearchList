//
// Created by yokoyas000 on 2018/06/18.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import Foundation


/// JSON をファイルパスから読み込む関数の名前空間
enum JsonReader {

    /// JSON ファイルから Data 型を生成する
    static func data(from filePath: String) -> Data {
        let fileHandle = FileHandle(forReadingAtPath: filePath)!
        return fileHandle.readDataToEndOfFile()
    }

    /// JSON ファイルから辞書を生成する
    static func dictionary(from filePath: String) -> [String: Any] {
        let fileHandle = FileHandle(forReadingAtPath: filePath)!
        let data = fileHandle.readDataToEndOfFile()
        let json = try! JSONSerialization.jsonObject(with: data)

        return json as! [String: Any]
    }

}