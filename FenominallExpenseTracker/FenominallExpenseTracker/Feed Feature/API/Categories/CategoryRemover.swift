//
//  CategoryRemover.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 25.06.2024.
//

import Foundation

public protocol CategoryRemover {
    typealias DeletionResult = Swift.Result<Void, Error>
    func delete(selected category: [TransactionCategory], completion: @escaping (DeletionResult) -> Void)
}
