//
//  AddTransactionUIComposer.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 28.05.2024.
//

import Foundation
import UIKit
import Combine
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

final class AddTransactionUIComposer {
    
    private init() {}
    
    private typealias AddTransactionPresentationAdapter = SaveResourcePresentationAdapter<Transaction, Void, AddTransactionViewAdapter>
    
    static func feedComposedWith(
        notifier: FeedUIUpdateNotifier,
        onFullCategoryListSelection: ((TransactionTypeViewModel) -> Void)?,
        onSaveAddTransaction: @escaping (Transaction) -> AnyPublisher<Void, Error>
    ) -> AddEditTransactionViewController {
        let viewModel = AddEditTransactionViewModel()
        let presentationAdapter = AddTransactionPresentationAdapter(saver: onSaveAddTransaction)
        let controller = AddEditTransactionViewController(viewModel: viewModel)
        viewModel.onSaveAddTransaction = { viewModel in
            let transaction = viewModel.createTransactionModel()
            presentationAdapter.saveResource(with: transaction)
            notifier.notifyTransactionUpdated()
        }
        
        presentationAdapter.presenter = ResourceOperationPresenter(
            resourceView: AddTransactionViewAdapter(),
            loadingView: WeakReVirtualProxy(viewModel),
            errorView: WeakReVirtualProxy(viewModel)
        )
        
        viewModel.onTransactionTypeSelected = onFullCategoryListSelection
        
        return controller
    }
}
