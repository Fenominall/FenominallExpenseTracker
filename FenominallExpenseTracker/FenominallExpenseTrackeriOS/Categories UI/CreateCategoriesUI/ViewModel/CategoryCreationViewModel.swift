//
//  CategoryCreationViewModel.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 16.06.2024.
//

import Foundation
import FenominallExpenseTracker

public final class CategoryCreationViewModel {
    var selectedColor: String?
    private var selectedIcon: String?
    var canAddCategory: ((Bool) -> Void)?
    public var onAddCategory: ((UserDefinedTransactionCategoryViewModel) -> Void)?
    private var transactionTypeViewModel: TransactionTypeViewModel
    
    public init(transactionTypeViewModel: TransactionTypeViewModel) {
        self.transactionTypeViewModel = transactionTypeViewModel
    }
    
    var categoryName: String = "" {
        didSet {
            validateInputs()
        }
    }
    
    private var isIconSelected: Bool {
        return selectedIcon != nil
    }
    
    private var isColorSelected: Bool {
        return selectedColor != nil
    }
    
    private var isCategoryNameEntered: Bool {
        return !categoryName.isEmpty
    }
    
    func didNotifyNewCategoryAdded() {
        NotificationCenter.default.post(name: .didAddNewCategory, object: nil)
    }
    
    func addNewCategory() {
        guard isCategoryNameEntered && isIconSelected && isColorSelected,
              let selectedColor = selectedColor,
              let selectedIcon = selectedIcon else {
            return
        }
        
        let newCategory = UserDefinedTransactionCategoryViewModel(
            id: UUID(),
            name: categoryName,
            hexColor: selectedColor,
            imageData: selectedIcon,
            transactionType: transactionTypeViewModel.toTransactionType()
        )
        
        onAddCategory?(newCategory)
    }
    
    func selectColor(_ color: String) {
        selectedColor = color
        validateInputs()
    }
    
    func selectIcon(_ icon: String) {
        selectedIcon = icon
        validateInputs()
    }
    
    private func validateInputs() {
        let isValid = isCategoryNameEntered && isIconSelected && isColorSelected
        canAddCategory?(isValid)
    }
    
    func updateTransactionType(to type: TransactionTypeViewModel) {
        transactionTypeViewModel = type
    }
}

extension CategoryCreationViewModel: ResourceErrorView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceErrorViewModel) {
        
    }
}

extension CategoryCreationViewModel: ResourceLoadingView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceLoadingViewModel) {
        
    }
}

extension Notification.Name {
    static let didAddNewCategory = Notification.Name("didAddNewCategory")
}

