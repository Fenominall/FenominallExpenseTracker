//
//  CategorySelectionViewModel.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 21.06.2024.
//

import Foundation
import FenominallExpenseTracker

public final class CategorySelectionViewModel {
    
    // MARK: - Properties
    public var didSelectCategory: ((TransactionCategory) -> Void)?
    var categoriesDidUpdate: (() -> Void)?
    public var onAddCategorySelected: (() -> Void)?
    public var didDeleteCategory: ((TransactionCategory) -> Void)?
    private var selectedType: TransactionTypeViewModel = .income {
        didSet { categoriesDidUpdate?() }
    }
    
    var predefinedCategories: [TransactionCategory] {
        return selectedType == .expense ?
        ExpenseCategory.allCases :
        IncomeCategory.allCases
    }
    
    public var userDefinedCategories: [TransactionCategory] = [] {
        didSet { categoriesDidUpdate?() }
    }
    
    var categories: [TransactionCategory] {
        let filteredUserDefinedCategories = userDefinedCategories.filter {
            $0.transactionType.rawValue == selectedType.rawValue
        }
        return predefinedCategories + filteredUserDefinedCategories
    }
    
    // MARK: - Initialisation
    public init(selectedType: TransactionTypeViewModel,
                didSelectCategory: @escaping (TransactionCategory) -> Void
    ) {
        self.selectedType = selectedType
        self.didSelectCategory = didSelectCategory
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    func numberOfItems() -> Int {
        categories.count + 1
    }
    
    func handleSelection(at indexPath: IndexPath) {
        if indexPath.item < categories.count {
            let selectedCategory = categories[indexPath.item]
            didSelectCategory?(selectedCategory)
        } else {
            onAddCategorySelected?()
        }
    }
    
    func deleteUserDefinedCategory(at index: Int) {
        let filteredUserDefinedCategories = userDefinedCategories.filter {
            $0.transactionType.rawValue == selectedType.rawValue
        }
        guard index >= 0 && index < filteredUserDefinedCategories.count else { return }
        let categoryToRemove = filteredUserDefinedCategories[index]
        userDefinedCategories.removeAll { $0.id == categoryToRemove.id }
        didDeleteCategory?(categoryToRemove)
        categoriesDidUpdate?()
    }
}

// MARK: - Notification observer helpers
extension CategorySelectionViewModel {
    private func observeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCategoryAddedNotification),
            name: .didAddNewCategory,
            object: nil
        )
    }
    
    @objc private func handleCategoryAddedNotification() {
        categoriesDidUpdate?()
    }
}

extension CategorySelectionViewModel: ResourceErrorView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceErrorViewModel) {
        
    }
}

extension CategorySelectionViewModel: ResourceLoadingView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceLoadingViewModel) {
        
    }
}
