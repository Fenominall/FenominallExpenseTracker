//
//  LocalTransactionCategoryStore.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 25.06.2024.
//

import Foundation

public final class LocalTransactionCategoryManager {
    private let store: CategoriesStore
    
    public init(store: CategoriesStore) {
        self.store = store
    }
    
    // MARK: - Helpers
    private typealias Completion<T> = (T) -> Void
    
    private func execute<T>(_ completion: Completion<T>?, result: T) {
        guard completion != nil else { return }
        completion?(result)
    }
}

extension LocalTransactionCategoryManager: CategoryManager {
    public func addNewCategory(
        _ category: TransactionCategory,
        completion: @escaping (SaveResult) -> Void
    ) {
        let localCategory = LocalTransactionCategory(
            id: category.id,
            name: category.name,
            hexColor: category.hexColor,
            imageData: category.imageData,
            transactionType: category.transactionType.convertToLocal()
        )
        
        store.insertCategory(localCategory) { [weak self] insertionError in
            self?.execute(completion, result: insertionError)
        }
    }
}

extension LocalTransactionCategoryManager {
    public func loadCategories(
        completion: @escaping (CategoryLoader.Result) -> Void
    ) {
        store.retrieveCategories { result in
            switch result {
            case let .success(.some(savedCategories)):
                completion(.success(savedCategories.toModelCategories()))
            case let .failure(error):
                completion(.failure(error))
            case .success:
                completion(.success([]))
            }
        }
    }
}

extension LocalTransactionCategoryManager {
    public func delete(
        selected category: [TransactionCategory],
        completion: @escaping (DeletionResult) -> Void
    ) {
        let localCategories = category.map { LocalTransactionCategory(from: $0) }
        store.delete(localCategories) { [weak self] deletionError in
            self?.execute(completion, result: deletionError)
        }
    }
}

// MARK: - Helpers
private extension Array where Element == LocalTransactionCategory {
    func toModelCategories() -> [UserDefinedTransactionCategory] {
        return map {
            UserDefinedTransactionCategory(
                id: $0.id,
                name: $0.name,
                hexColor: $0.hexColor,
                imageData: $0.imageData,
                transactionType: $0.transactionType.convertToModel()
            )
        }
    }
}
