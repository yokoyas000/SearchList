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



extension Result: Equatable where Value: Equatable, E: Equatable {
    static func == (lhs: Result<Value, E>, rhs: Result<Value, E>) -> Bool {
        switch (lhs, rhs) {
        case let (.success(lvalue), .success(rvalue)):
            return lvalue == rvalue
        case let (.failure(lerror), .failure(rerror)):
            return lerror == rerror
        default:
            return false
        }
    }
}
