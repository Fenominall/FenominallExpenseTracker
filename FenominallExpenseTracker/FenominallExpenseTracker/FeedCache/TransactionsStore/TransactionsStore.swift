//
//  FeedStore.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 27.04.2024.
//

import Foundation

public protocol TransactionsStore {
    typealias DeletionResult = Swift.Result<Void, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    typealias RetrievalResult = Swift.Result<[LocalTransaction]?, Error>
    typealias UpdatingResult = Swift.Result<Void, Error>
    typealias SearchingResult = Swift.Result<[LocalTransaction]?, Error>
    
    func delete(_ transactions: [LocalTransaction], completion: @escaping (DeletionResult) -> Void)
    func insert(_ transaction: LocalTransaction, completion: @escaping (InsertionResult) -> Void)
    func retrieve(completion: @escaping (RetrievalResult) -> Void)
    func update(_ transaction: LocalTransaction, completion: @escaping (UpdatingResult) -> Void)
    func search(with argument: String, filterOption: FilterOption?, completion: @escaping (SearchingResult) -> Void)
}
