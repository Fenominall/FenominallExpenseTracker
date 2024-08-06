//
//  CategoryDeletionAdapter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 25.06.2024.
//

import Combine
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

final class CategoryDeletionAdapter {
    private var cancellables = Set<AnyCancellable>()
    private let didDeleteCategoryPublisher: (TransactionCategory) -> AnyPublisher<Void, Error>
    private let viewModel: CategorySelectionViewModel
    
    init(
        viewModel: CategorySelectionViewModel,
        didDeleteCategoryPublisher: @escaping (TransactionCategory) -> AnyPublisher<Void, Error>
    ) {
        self.viewModel = viewModel
        self.didDeleteCategoryPublisher = didDeleteCategoryPublisher
    }
    
    func deleteCategory(_ category: TransactionCategory) {
        didDeleteCategoryPublisher(category)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error deleting category: \(error)")
                }
            }, receiveValue: {})
            .store(in: &cancellables)
    }
}
