//
//  CategorySelectionViewAdapter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 24.06.2024.
//

import Foundation
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

final class CategorySelectionViewAdapter: ResourceView {
    private weak var categoryViewModel: CategorySelectionViewModel?
    
    init(categoryViewModel: CategorySelectionViewModel) {
        self.categoryViewModel = categoryViewModel
    }
    
    func display(_ viewModel: [UserDefinedTransactionCategory]) {
        categoryViewModel?.userDefinedCategories = viewModel
    }
}
