//
//  LocalFeedLoader.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 27.04.2024.
//

import Foundation

public final class LocalFeedTransactionManager {
    public let store: TransactionsStore
    
    public init(store: TransactionsStore) {
        self.store = store
    }
    
    // MARK: - Helpers
    private typealias Completion<T> = (T) -> Void
    
    private func execute<T>(_ completion: Completion<T>?, result: T) {
        guard completion != nil else { return }
        completion?(result)
    }
}

/// TransactionLoader
extension LocalFeedTransactionManager: TransactionManager {
    public typealias LoadResult = TransactionLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(.some(cache)):
                completion(.success(cache.toModel()))
            case .success:
                completion(.success([]))
            }
        }
    }
}

// Transaction Cache
extension LocalFeedTransactionManager {
    public func save(_ transaction: Transaction,
                     completion: @escaping (SaveResult) -> Void) {
        store.insert(transactionToLocal(transaction)) { [weak self] insertionError in
            self?.execute(completion,
                          result: insertionError)
        }
    }
}

// TransactionUpdater
extension LocalFeedTransactionManager  {
    public func update(selected transaction: Transaction,
                       completion: @escaping (TransactionUpdater.Result) -> Void) {
        store.update(transactionToLocal(transaction)) { [weak self] updatingError in
            self?.execute(completion,
                          result: updatingError)
        }
    }
    
    private func transactionToLocal(_ transaction: Transaction) -> LocalTransaction {
        return LocalTransaction(
            id: transaction.id,
            title: transaction.title,
            remarks: transaction.remarks,
            amount: transaction.amount,
            dateAdded: transaction.dateAdded,
            type: transaction.type.convertToLocal(),
            category:
                LocalTransactionCategory(
                    id: transaction.category.id,
                    name: transaction.category.name,
                    hexColor: transaction.category.hexColor,
                    imageData: transaction.category.imageData,
                    transactionType:
                        transaction.category.transactionType.convertToLocal()))
    }
    
    private func transactionToModel(_ transaction: LocalTransaction) -> Transaction {
        return Transaction(
            id: transaction.id,
            title: transaction.title,
            remarks: transaction.remarks,
            amount: transaction.amount,
            dateAdded: transaction.dateAdded,
            type: transaction.type.convertToModel(),
            category:
                ConcreteTransactionCategory(
                    id: transaction.category.id,
                    name: transaction.category.name,
                    hexColor: transaction.category.hexColor,
                    imageData: transaction.category.imageData,
                    transactionType:
                        transaction.category.transactionType.convertToModel()))
    }
}

// TransactionRemover
extension LocalFeedTransactionManager {
    public func delete(selected transactions: [Transaction],
                       completion: @escaping (DeletionResult) -> Void) {
        store.delete(transactions.toLocal(),
                     completion: completion)
    }
}

extension LocalFeedTransactionManager {
    public typealias SearchResult = TransactionSearcher.Result
    
    public func searchAndLoad(
        with argument: String,
        filterOption: FilterOption?,
        completion: @escaping (SearchResult) -> Void
    ) {
        store.search(with: argument, filterOption: filterOption) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(.some(cache)):
                completion(.success(cache.toModel()))
            case .success:
                completion(.success([]))
            }
        }
    }
}

private extension Array where Element == Transaction {
    func toLocal() -> [LocalTransaction] {
        return map {
            LocalTransaction(
                id: $0.id,
                title: $0.title,
                remarks: $0.remarks,
                amount: $0.amount,
                dateAdded: $0.dateAdded,
                type: $0.type.convertToLocal(),
                category: LocalTransactionCategory(
                    id: $0.category.id,
                    name: $0.category.name,
                    hexColor: $0.category.hexColor,
                    imageData: $0.category.imageData,
                    transactionType: $0.category.transactionType.convertToLocal()))
        }
    }
}

private extension Array where Element == LocalTransaction {
    func toModel() -> [Transaction] {
        return map {
            Transaction(
                id: $0.id,
                title: $0.title,
                remarks: $0.remarks,
                amount: $0.amount,
                dateAdded: $0.dateAdded,
                type: $0.type.convertToModel(),
                category: ConcreteTransactionCategory(
                    id: $0.category.id,
                    name: $0.category.name,
                    hexColor: $0.category.hexColor,
                    imageData: $0.category.imageData,
                    transactionType: $0.category.transactionType.convertToModel()
                )
            )
        }
    }
}

private struct ConcreteTransactionCategory: TransactionCategory {
    var id: UUID
    var name: String
    var hexColor: String
    var imageData: String?
    var transactionType: TransactionType
    
    init(
        id: UUID,
        name: String,
        hexColor: String,
        imageData: String?,
        transactionType: TransactionType
    ) {
        self.id = id
        self.name = name
        self.hexColor = hexColor
        self.imageData = imageData
        self.transactionType = transactionType
    }
}
