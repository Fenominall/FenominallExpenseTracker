//
//  AddEditTransactionViewModel.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 20.06.2024.
//

import Foundation
import FenominallExpenseTracker

public final class AddEditTransactionViewModel {
    
    var transactionToEdit: TransactionViewModel?
    public var selectedType: TransactionTypeViewModel = .income {
        didSet { categoriesDidUpdate?() }
    }
    
    var selectedCategory: TransactionCategory? = ExpenseCategory.allCases.first {
        didSet { categoriesDidUpdate?() }
    }
    public var categories: [TransactionCategory] {
        selectedType == .expense ? ExpenseCategory.allCases : IncomeCategory.allCases }
    public var deleteHandler: (() -> Void)?
    public var onSaveAddTransaction: ((TransactionViewModel) -> Void)?
    public var onSaveUpdateTransaction: ((TransactionViewModel) -> Void)?
    public var onCategorySelected: ((TransactionTypeViewModel) -> Void)?
    var categoriesDidUpdate: (() -> Void)?
    
    public var userDefinedCategories: [TransactionCategory] = [] {
        didSet { categoriesDidUpdate?() }
    }
    
    var allCategories: [TransactionCategory] {
        let filteredUserDefinedCategories = userDefinedCategories.filter {
            $0.transactionType.rawValue == selectedType.rawValue
        }
        return filteredUserDefinedCategories + categories
    }
    
    public init(transaction: TransactionViewModel? = nil) {
        self.transactionToEdit = transaction
        if let transaction = transaction {
            self.selectedType = transaction.type
            self.selectedCategory = transaction.actualCategory
        }
    }
    
    func saveTransaction(title: String, remarks: String, amount: Double, date: Date) {
        guard let category = selectedCategory else { return }
        
        let transaction = TransactionViewModel(
            id: transactionToEdit?.transactionID ?? UUID(),
            title: title,
            remarks: remarks,
            amount: amount,
            dateAdded: date,
            modelType: selectedType,
            categoryName: category.name,
            category: category
        )
        
        transactionToEdit != nil ? 
        onSaveUpdateTransaction?(transaction) :
        onSaveAddTransaction?(transaction)
    }
    
    func deleteTransaction() {
        deleteHandler?()
    }
}

extension AddEditTransactionViewModel: ResourceErrorView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceErrorViewModel) {
        
    }
}
extension AddEditTransactionViewModel: ResourceLoadingView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceLoadingViewModel) {
        
    }
}
