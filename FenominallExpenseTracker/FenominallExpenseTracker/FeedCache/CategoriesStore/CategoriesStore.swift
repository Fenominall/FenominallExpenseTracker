//
//  CategoriesStore.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 25.06.2024.
//

import Foundation

public protocol CategoriesStore {
    typealias DeletionResult = Swift.Result<Void, Error>
    typealias RetrievalResult = Swift.Result<[LocalTransactionCategory]?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func delete(_ categories: [LocalTransactionCategory], completion: @escaping (DeletionResult) -> Void)
    func insertCategory(_ category: LocalTransactionCategory, completion: @escaping (InsertionResult) -> Void)
    func retrieveCategories(completion: @escaping (RetrievalResult) -> Void)
}
