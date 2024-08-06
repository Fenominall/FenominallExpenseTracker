//
//  Transaction.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 26.04.2024.
//

import Foundation

public struct Transaction {
    public let id: UUID
    public let title: String
    public let remarks: String
    public let amount: Double
    public let dateAdded: Date
    public let type: TransactionType
    public let category: TransactionCategory
    
    public init(
        id: UUID,
        title: String,
        remarks: String,
        amount: Double,
        dateAdded: Date,
        type: TransactionType,
        category: TransactionCategory) {
            self.id = id
            self.title = title
            self.remarks = remarks
            self.amount = amount
            self.dateAdded = dateAdded
            self.type = type
            self.category = category
        }
}
