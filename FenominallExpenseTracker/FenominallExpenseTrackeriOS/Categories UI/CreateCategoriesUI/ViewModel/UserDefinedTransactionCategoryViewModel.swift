//
//  UserDefinedTransactionCategoryViewModel.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 21.06.2024.
//

import Foundation
import FenominallExpenseTracker

public struct UserDefinedTransactionCategoryViewModel {
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
