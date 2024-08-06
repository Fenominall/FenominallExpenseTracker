//
//  FeedUIUpdateNotifier.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 30.05.2024.
//

import Combine

public final class FeedUIUpdateNotifier {
    private var updateTransactionSubject = PassthroughSubject<Void, Never>()
    
    public var updateTransactionPublisher: AnyPublisher<Void, Never> {
        updateTransactionSubject.eraseToAnyPublisher()
    }

    public func notifyTransactionUpdated() {
        updateTransactionSubject.send(())
    }
}
