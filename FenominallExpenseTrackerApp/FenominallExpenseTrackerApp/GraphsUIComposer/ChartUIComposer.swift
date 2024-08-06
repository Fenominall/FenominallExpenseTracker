//
//  GraphsUIComposer.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 04.06.2024.
//

import Combine
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

public final class ChartUIComposer {
    private init() {}
    
    private typealias ChartPresentationAdapter = LoadResourcePresentationAdapter<[Transaction], ChartViewAdapter>
    
    public static func chartComposedWith(
        subscriptionManager: SubscriptionManager,
        transactionLoader: @escaping () -> AnyPublisher<[Transaction], Error>,
        updateNotifier: FeedUIUpdateNotifier
    ) -> ChartViewController {
        let presentationAdapter = ChartPresentationAdapter(loader: transactionLoader)
        let chartViewModel = ChartTransactionsViewModel(transactions: [])
        let chartViewController = ChartViewController(viewModel: chartViewModel)
        chartViewController.onRefresh = presentationAdapter.loadResource
        
        
        let updateCancellable = updateNotifier
            .updateTransactionPublisher
            .sink { _ in
            chartViewController.onRefresh?()
        }
        subscriptionManager.store(updateCancellable)
        
        presentationAdapter.presenter = ResourceOperationPresenter(
            resourceView: ChartViewAdapter(controller: chartViewController, viewModel: chartViewModel),
            loadingView: WeakReVirtualProxy(chartViewController),
            errorView: WeakReVirtualProxy(chartViewController))
        
        return chartViewController
    }
}

