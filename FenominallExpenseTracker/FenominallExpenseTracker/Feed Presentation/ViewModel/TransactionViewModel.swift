//
//  TransactionFeedViewModel.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 18.05.2024.
//

import Foundation
import FenominallExpenseTracker

import Foundation
import FenominallExpenseTracker

public class TransactionViewModel {
    private let id: UUID
    private let title: String
    private let remarks: String
    private let amount: Double
    private let dateAdded: Date
    private let categoryName: String
    private let modelType: TransactionTypeViewModel
    private let category: TransactionCategory
    
    public init(model: Transaction) {
        self.id = model.id
        self.title = model.title
        self.remarks = model.remarks
        self.amount = model.amount
        self.dateAdded = model.dateAdded
        self.categoryName = model.category.name.capitalized
        self.category = model.category
        self.modelType = TransactionTypeViewModel(type: model.type)
    }
    
    public init(
        id: UUID,
        title: String,
        remarks: String,
        amount: Double,
        dateAdded: Date,
        modelType: TransactionTypeViewModel,
        categoryName: String,
        category: TransactionCategory)
    {
        self.id = id
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.modelType = modelType
        self.categoryName = categoryName
        self.category = category
    }
    
    var transactionID: UUID {
        id
    }
    
    
    var transactionTitle: String {
        title
    }
    
    var rawDateAdded: Date {
        dateAdded
    }
    
    var transactionRemars: String {
        remarks
    }
    
    var transactionAmount: Double {
        amount
    }
    
    var transactionCategoryName: String {
        categoryName
    }
    
    var categoryColor: String {
        category.hexColor
    }
    
    var categoryImage: String {
        category.imageData ?? ""
    }
    
    var actualCategory: TransactionCategory {
        category
    }
    
    var convertedAmount: String {
        return modelType == .income ?
        "+ \(currencyString(amount))" :
        "- \(currencyString(amount))"
    }
    
    var convertedDate: String {
        convertDate(with: dateAdded)
    }
    
    var type: TransactionTypeViewModel {
        switch modelType {
        case .income:
            return .income
        case .expense:
            return .expense
        }
    }
}

extension TransactionTypeViewModel {
    func toTransactionType() -> TransactionType {
        switch self {
        case .income:
            return .income
        case .expense:
            return .expense
        }
    }
    
    init(type: TransactionType) {
        switch type {
        case .income:
            self = .income
        case .expense:
            self = .expense
        @unknown default:
            self = .expense
        }
    }
}

extension TransactionViewModel {
    public func createTransactionModel() -> Transaction {
        Transaction(
            id: id,
            title: title,
            remarks: remarks,
            amount: amount,
            dateAdded: dateAdded,
            type: modelType.toTransactionType(),
            category: category)
    }
}

