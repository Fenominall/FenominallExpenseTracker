//
//  FeedViewAdapter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 19.05.2024.
//

import Foundation
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

final class FeedViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let selection: (Transaction) -> Void
    private let onDelete: (Transaction) -> Void
    
    init(controller: ListViewController, 
         selection: @escaping (Transaction) -> Void,
         onDelete: @escaping (Transaction) -> Void
    ) {
        self.controller = controller
        self.selection = selection
        self.onDelete = onDelete
    }
    
    func display(_ viewModel: [Transaction]) {
        let income = total(viewModel, type: .income)
        let expense = total(viewModel, type: .expense)
        
        DispatchQueue.main.async { [weak self] in
            self?.configureHeaderView(withIncome: income, withExpense: expense)
            self?.controller?.tableModel = viewModel.map { model in
                TransactionCellController(
                    viewModel: TransactionViewModel(model: model),
                    selection: {
                        self?.selection(model)
                        
                    }, deleteHandler: {
                        self?.onDelete(model)
                    })
            }
        }
    }
    
    private func total(_ transactions: [Transaction], type: TransactionType) -> Double {
        let filteredTransactions = transactions.filter { $0.type.rawValue == type.rawValue }
        let totalAmount = filteredTransactions.reduce(0) { $0 + $1.amount }
        return totalAmount
    }
    
    private func configureHeaderView(withIncome incomeAmount: Double, withExpense expenseAmount: Double) {
        guard let controller = controller else { return }
        controller.cardHeaderView.delegate = controller
        controller.cardHeaderView.configureTotal(forIncome: incomeAmount, forExpense: expenseAmount)
    }
}
