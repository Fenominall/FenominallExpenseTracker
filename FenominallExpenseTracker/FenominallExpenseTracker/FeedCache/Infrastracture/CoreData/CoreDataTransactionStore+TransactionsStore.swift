////
////  CoreData.swift
////  FenominallExpenseTracker
////
////  Created by Fenominall on 29.04.2024.
////

import CoreData

extension CoreDataTransactionStore: TransactionsStore {
    
    public func insert(
        _ transaction: LocalTransaction,
        completion: @escaping (InsertionResult) -> Void
    ) {
        performAsync { context in
            completion(Result {
                let managedCache = try ManagedCache.fetchOrCreateCache(in: context)
                try managedCache.updateCache(with: transaction, in: context)
                try context.save()
            })
        }
    }
    
    public func retrieve(completion: @escaping (TransactionsStore.RetrievalResult) -> Void) {
        performAsync { context in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    return $0.localTransactionFeed
                }
            })
        }
    }
    
    public func update(
        _ transaction: LocalTransaction,
        completion: @escaping (UpdatingResult) -> Void
    ) {
        performAsync { context in
            completion(Result {
                try ManagedCache.update(transaction, context: context)
            })
        }
    }
    
    public func delete(_ transactions: [LocalTransaction], completion: @escaping (DeletionResult) -> Void) {
        performAsync { context in
            completion(Result {
                // Retrieve the cache from the managed object context
                guard let cache = try ManagedCache.find(in: context)?.cache else {
                    throw CacheError.missingManagedObjectContext
                }
                // Convert LocalTransaction objects to ManagedTransaction objects
                let managedTransactions = transactions.compactMap { localTransaction in
                    try? ManagedTransaction.first(with: localTransaction, in: context)
                }
                // Call deleteTransactions function
                try ManagedCache.deleteTransactions(managedTransactions, in: cache, context)
            })
        }
    }
    
    public func search(with argument: String, filterOption: FilterOption?, completion: @escaping (SearchingResult) -> Void) {
        performAsync { context in
            completion(Result {
                let transactions = try ManagedTransaction.fetchTransactions(with: argument, filterOption: filterOption, in: context)
                return transactions
            })
        }
    }
}
