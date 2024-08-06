//
//  NullStore.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 11.05.2024.
//

import Foundation
import FenominallExpenseTracker

class NullStore: TransactionsStore {
    func search(with argument: String, filterOption: FenominallExpenseTracker.FilterOption?, completion: @escaping (SearchingResult) -> Void) {
        completion(.success(.none))
    }
    
    
    func delete(_ transactions: [FenominallExpenseTracker.LocalTransaction], completion: @escaping (DeletionResult) -> Void) {
        completion(.success(()))
    }
    
    func insert(_ transaction: FenominallExpenseTracker.LocalTransaction, completion: @escaping (InsertionResult) -> Void) {
        completion(.success(()))
    }
    
    func retrieve(completion: @escaping (TransactionsStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
    
    func update(_ transaction: FenominallExpenseTracker.LocalTransaction, completion: @escaping (UpdatingResult) -> Void) {
        completion(.success(()))
    }
}

extension NullStore: CategoriesStore {
    func delete(_ categories: [FenominallExpenseTracker.LocalTransactionCategory], completion: @escaping (CategoriesStore.DeletionResult) -> Void) {
        completion(.success(()))
    }
    
    func retrieveCategories(completion: @escaping (CategoriesStore.RetrievalResult) -> Void) {
        completion(.success([]))
    }
    
    func insertCategory(_ category: FenominallExpenseTracker.LocalTransactionCategory, completion: @escaping (InsertionResult) -> Void) {
        completion(.success(()))
    }
}
