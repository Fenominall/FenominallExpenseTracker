//
//  TransactionCategory.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 28.04.2024.
//

import Foundation

public protocol TransactionCategory {
    var id: UUID { get }
    var name: String { get }
    var hexColor: String { get }
    var imageData: String? { get }
    var transactionType: TransactionType { get }
}

extension TransactionCategory {
    var id: UUID {
        return UUID()
    }
}
