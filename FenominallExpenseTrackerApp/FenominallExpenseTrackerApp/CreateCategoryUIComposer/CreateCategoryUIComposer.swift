//
//  CreateCategoryUIComposer.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 21.06.2024.
//

import Combine
import UIKit
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

final class CreateCategoryUIComposer {
    private init() {}
    
    private typealias CreateCategoryPresentationAdapter = SaveResourcePresentationAdapter<UserDefinedTransactionCategory, Bool, CategoryViewAdapter>
    
    static func categoryCreationComposedWith(
        onAddCategory: @escaping (UserDefinedTransactionCategory) -> AnyPublisher<Bool, Error>
    ) -> CreateCategoryViewController {
        let viewModel = CategoryCreationViewModel(transactionTypeViewModel: TransactionTypeViewModel.expense)
        let presentationAdapter = CreateCategoryPresentationAdapter(saver: onAddCategory)
        let controller = CreateCategoryViewController(viewModel: viewModel)
        
        viewModel.onAddCategory = { categoryViewModel in
            presentationAdapter.saveResource(with: categoryViewModel.toUserDefinedTransactionCategory())
        }
        
        presentationAdapter.presenter = ResourceOperationPresenter(
            resourceView: CategoryViewAdapter(),
            loadingView: WeakReVirtualProxy(viewModel),
            errorView: WeakReVirtualProxy(viewModel)
        )
        return controller
    }
}

private extension UserDefinedTransactionCategoryViewModel {
    func toUserDefinedTransactionCategory()
    -> UserDefinedTransactionCategory {
        return UserDefinedTransactionCategory(
            id: id,
            name: name,
            hexColor: hexColor,
            imageData: imageData,
            transactionType: transactionType
        )
    }
}

final class CategoryViewAdapter: ResourceView {
    typealias ResourceViewModel = Bool
    
    func display(_ viewModel: ResourceViewModel) {
        
    }
}
