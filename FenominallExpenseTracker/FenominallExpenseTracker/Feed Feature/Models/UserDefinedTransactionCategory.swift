//
//  UserDefinedTransactionCategory.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 12.05.2024.
//

import Foundation

public struct UserDefinedTransactionCategory: TransactionCategory {
    
    public var id: UUID
    public var name: String
    public var hexColor: String
    public var imageData: String?
    public var transactionType: TransactionType

    public init(
        id: UUID,
        name: String,
        hexColor: String,
        imageData: String?,
        transactionType: TransactionType
    ) {
        self.id = id
        self.name = name
        self.hexColor = hexColor
        self.imageData = imageData
        self.transactionType = transactionType
    }
}
