//
//  TransactionCache.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 27.04.2024.
//

import Foundation

public protocol TransactionCache {
    typealias SaveResult = Swift.Result<Void, Error>
    func save(_ transaction: Transaction, completion: @escaping (SaveResult) -> Void)
}
