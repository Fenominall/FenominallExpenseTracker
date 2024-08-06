//
//  TransactionProvider.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 27.04.2024.
//

import Foundation

public protocol TransactionUpdater {
    typealias Result = Swift.Result<Void, Error>
    func update(selected transaction: Transaction, completion: @escaping (Result) -> Void)
}
