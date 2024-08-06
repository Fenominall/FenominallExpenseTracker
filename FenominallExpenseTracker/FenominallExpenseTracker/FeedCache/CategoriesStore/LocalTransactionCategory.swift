//
//  LocalTransactionCategory.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 28.04.2024.
//

import Foundation

public struct LocalTransactionCategory: Equatable {
    public let id: UUID
    public let name: String
    var hexColor: String
    var imageData: String?
    public let transactionType: LocalTransactionType
    
    init(
        id: UUID,
        name: String,
        hexColor: String,
        imageData: String?,
        transactionType: LocalTransactionType
    ) {
        self.id = id
        self.name = name
        self.hexColor = hexColor
        self.imageData = imageData
        self.transactionType = transactionType
    }
    
    init(from transactionCategory: TransactionCategory) {
        self.id = transactionCategory.id
        self.name = transactionCategory.name
        self.hexColor = transactionCategory.hexColor
        self.imageData = transactionCategory.imageData
        self.transactionType = transactionCategory.transactionType.convertToLocal()
    }
}
