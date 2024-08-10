//
//  TransactionDeleter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 31.05.2024.
//

import Combine
import FenominallExpenseTracker

public final class TransactionDeleter {
    private var cancellables = Set<AnyCancellable>()
    private let notifier: FeedUIUpdateNotifier
    
    init(notifier: FeedUIUpdateNotifier) {
        self.notifier = notifier
    }
    
    public func delete(_ transaction: Transaction, using deletePublisher: @escaping (Transaction) -> AnyPublisher<Void, Error>) {
        deletePublisher(transaction)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.notifier.notifyTransactionUpdated()
                case .failure(let error):
                    print("Failed to delete transaction: \(error)")
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }
}
