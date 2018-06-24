//
// Created by yokoyas000 on 2018/06/23.
// Copyright (c) 2018 yokoyas000. All rights reserved.
//

import RxSwift

class Store<State> {
    let state: Observable<State>

    var currentState: State {
        // this try! is ok because subject can't error out or be disposed
        // SEE: https://github.com/ReactiveX/RxSwift/blob/faeb158ce76d355f3f9242fdd0258a9face62f37/RxCocoa/Traits/BehaviorRelay.swift#L27
        return try! self.subject.value()
    }

    private let subject: BehaviorSubject<State>

    init(initialState: State) {
        self.subject = BehaviorSubject<State>(value: initialState)
        self.state = self.subject.asObservable()
    }

    func transition(next state: State) {
        self.subject.onNext(state)
    }
}
