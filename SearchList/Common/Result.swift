//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

enum Result<Value, E: Error> {
    case success(Value)
    case failure(E)

    var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    var error: E? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
