//
//  FeedUIComposer.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 16.05.2024.
//

import UIKit
import Combine
import FenominallExpenseTrackeriOS
import FenominallExpenseTracker

public final class FeedUIComposer {
    private init() {}
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[Transaction], FeedViewAdapter>
    
    public static func feedComposedWith(
        subscriptionManager: SubscriptionManager,
        transactionDeleter: TransactionDeleter,
        updateNotifier: FeedUIUpdateNotifier,
        transactionLoader: @escaping () -> AnyPublisher<[Transaction], Error>,
        selection: @escaping (Transaction) -> Void,
        deleteTransaction: @escaping (Transaction) -> AnyPublisher<Void, Error>,
        addNewTransaction: @escaping (() -> Void),
        searchTransaction: @escaping (() -> Void)
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: transactionLoader)
        let transactionsController = ListViewController()
        transactionsController.onRefresh = presentationAdapter.loadResource
        transactionsController.addNewTransaction = addNewTransaction
        transactionsController.searchTransaction = searchTransaction
        
        let updateCancellable = updateNotifier.updateTransactionPublisher.sink { _ in
            transactionsController.onRefresh?()
        }
        subscriptionManager.store(updateCancellable)
        
        presentationAdapter.presenter = ResourceOperationPresenter(
            resourceView: FeedViewAdapter(
                controller: transactionsController,
                selection: selection,
                onDelete: { transaction in
                    transactionDeleter.delete(transaction, using: deleteTransaction)
                }),
            loadingView: WeakReVirtualProxy(transactionsController),
            errorView: WeakReVirtualProxy(transactionsController))
        
        return transactionsController
    }
}
