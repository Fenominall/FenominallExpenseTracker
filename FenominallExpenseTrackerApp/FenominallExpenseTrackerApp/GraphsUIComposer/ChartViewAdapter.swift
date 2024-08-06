//
//  ChartsViewAdapter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 04.06.2024.
//

import Foundation
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

final class ChartViewAdapter: ResourceView {
    private weak var controller: ChartViewController?
    private var viewModel: ChartTransactionsViewModel
    
    init(controller: ChartViewController, viewModel: ChartTransactionsViewModel) {
        self.controller = controller
        self.viewModel = viewModel
    }
    
    func display(_ viewModel: [Transaction]) {
        let transactionViewModels = viewModel.map { TransactionViewModel(model: $0) }
        DispatchQueue.main.async {
            self.viewModel.transactions = transactionViewModels
            self.viewModel.createChartGroup()
        }
    }
}
