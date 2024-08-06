//
//  TransactionRemover.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 29.04.2024.
//

import Foundation

public protocol TransactionRemover {
    typealias DeletionResult = Swift.Result<Void, Error>
    func delete(selected transactions: [Transaction], completion: @escaping (DeletionResult) -> Void)
}
