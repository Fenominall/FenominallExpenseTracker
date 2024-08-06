//
//  TransactionsLoader.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 26.04.2024.
//

import Foundation

public protocol TransactionLoader {
    typealias Result = Swift.Result<[Transaction], Error>
    func load(completion: @escaping (Result) -> Void)
}
