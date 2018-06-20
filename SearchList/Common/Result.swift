//
// Created by yokoyas000 on 2018/06/19.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

enum Result<Value, E: Error> {
    case success(Value)
    case failure(E)
}
