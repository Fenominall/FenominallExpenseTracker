//
//  EditTransactionUIComposer.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 25.05.2024.
//

import Foundation
import Combine
import FenominallExpenseTrackeriOS
import FenominallExpenseTracker

final class EditTransactionUIComposer {
    private init() {}
    
    private typealias EditTransactionPresentationAdapter = SaveResourcePresentationAdapter<Transaction, Void, EditTransactionViewAdapter>
    private typealias FeedTransactionDeleter = TransactionDeleter
    
    static func feedComposedWith(
        selectedModel: Transaction,
        notifier: FeedUIUpdateNotifier,
        onSaveUpdateTransaction: @escaping (Transaction) -> AnyPublisher<Void, Error>,
        deleteTransaction: @escaping (Transaction) -> AnyPublisher<Void, Error>
    ) -> AddEditTransactionViewController {
        let presentationAdapter =  EditTransactionPresentationAdapter(saver: onSaveUpdateTransaction)
        let transactionDeleter = FeedTransactionDeleter(notifier: notifier)
        let viewModel = AddEditTransactionViewModel(
            transaction: TransactionViewModel(
                model: selectedModel))
        let controller = AddEditTransactionViewController(viewModel: viewModel)

        viewModel.onSaveUpdateTransaction = { viewModel in
            let transaction = viewModel.createTransactionModel()
            presentationAdapter.saveResource(with: transaction)
            notifier.notifyTransactionUpdated()
        }
        viewModel.deleteHandler = {
            transactionDeleter.delete(selectedModel, using: deleteTransaction)
        }
        
        presentationAdapter.presenter = ResourceOperationPresenter(
            resourceView: EditTransactionViewAdapter(),
            loadingView: WeakReVirtualProxy(viewModel),
            errorView: WeakReVirtualProxy(viewModel)
        )
        
        return controller
    }
}

final class EditTransactionViewAdapter: ResourceView {
    typealias ResourceViewModel = Void
    
    func display(_ viewModel: ResourceViewModel) {
        
    }
}
