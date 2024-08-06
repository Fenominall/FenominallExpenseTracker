//
//  CategoryUIComposer.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 15.06.2024.
//

import Combine
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

final class CategorySelectionUIComposer {
    private init() {}
    
    private typealias CategorySelectionPresentationAdapter = LoadResourcePresentationAdapter<[UserDefinedTransactionCategory], CategorySelectionViewAdapter>
    
    static func categorySelectionComposedWith(
        transactionType: TransactionTypeViewModel,
        didSelectCategory: @escaping (TransactionCategory) -> Void,
        didDeleteCategory: @escaping (TransactionCategory) -> AnyPublisher<Void, Error>,
        onAddCategorySelected: @escaping (() -> Void),
        categoriesLoader: @escaping () -> AnyPublisher<[UserDefinedTransactionCategory], Error>
    ) -> CategorySelectionViewController {
        let presentationAdapter = CategorySelectionPresentationAdapter(loader: categoriesLoader)
        let viewModel = CategorySelectionViewModel(
            selectedType: transactionType,
            didSelectCategory: didSelectCategory)
        viewModel.onAddCategorySelected = onAddCategorySelected
        let controller = CategorySelectionViewController(viewModel: viewModel)
        let deletionAdapter = CategoryDeletionAdapter(
            viewModel: viewModel,
            didDeleteCategoryPublisher: didDeleteCategory)
        
        controller.onLoad = presentationAdapter.loadResource
        viewModel.didDeleteCategory = { category in
            deletionAdapter.deleteCategory(category)
        }
        
        presentationAdapter.presenter = ResourceOperationPresenter(
            resourceView: CategorySelectionViewAdapter(categoryViewModel: viewModel),
            loadingView: WeakReVirtualProxy(viewModel),
            errorView: WeakReVirtualProxy(viewModel))
        
        return controller
    }
}
