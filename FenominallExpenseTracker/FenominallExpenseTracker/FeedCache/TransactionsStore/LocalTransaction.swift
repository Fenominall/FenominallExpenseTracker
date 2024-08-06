//
//  LocalTransaction.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 27.04.2024.
//
import Foundation

public struct LocalTransaction: Equatable {
    public let id: UUID
    public let title: String
    public let remarks: String
    public let amount: Double
    public let dateAdded: Date
    public let type: LocalTransactionType
    public let category: LocalTransactionCategory
    
    public init(
        id: UUID,
        title: String,
        remarks: String,
        amount: Double,
        dateAdded: Date,
        type: LocalTransactionType,
        category: LocalTransactionCategory) {
            self.id = id
            self.title = title
            self.remarks = remarks
            self.amount = amount
            self.dateAdded = dateAdded
            self.type = type
            self.category = category
        }
    
    // Convert LocalTransactionType to string for saving to CoreData
    var transactionTypeRawValue: String {
        return type.rawValue
    }
}
