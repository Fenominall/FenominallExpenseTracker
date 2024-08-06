//
//  CoreDataTransactionStore+CategoriesStore.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 25.06.2024.
//

import CoreData

extension CoreDataTransactionStore: CategoriesStore {
    public func insertCategory(_ category: LocalTransactionCategory, completion: @escaping (InsertionResult) -> Void) {
        performAsync { context in
            completion(Result {
                try ManagedTransactionCategory.saveCategory(category, in: context)
                try context.save()
            })
        }
    }
    
    public func retrieveCategories(completion: @escaping (CategoriesStore.RetrievalResult) -> Void) {
        performAsync { context in
            completion(Result {
                try ManagedTransactionCategory.fetchCategories(in: context)
            })
        }
    }
    
    public func delete(_ categories: [LocalTransactionCategory], completion: @escaping (DeletionResult) -> Void) {
        performAsync { context in
            completion(Result {
                do {
                    let managedCategories = try categories.compactMap { localCategory in
                        try ManagedTransactionCategory.first(with: localCategory, in: context)
                    }
                    
                    if managedCategories.isEmpty {
                        throw CacheError.categoryNotFound
                    }
                    
                    try ManagedTransactionCategory.deleteCategories(managedCategories, in: context)
                    try context.saveIfNeeded()
                } catch {
                    throw error
                }
            })
        }
    }
}
