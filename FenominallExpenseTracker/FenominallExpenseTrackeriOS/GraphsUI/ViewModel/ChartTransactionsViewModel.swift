//
//  ChartTransactionsViewModel.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 04.06.2024.
//

import Combine
import Foundation
import FenominallExpenseTracker

public final class ChartTransactionsViewModel: ObservableObject {
    @Published public var transactions: [TransactionViewModel]
    @Published private(set) var chartGroups: [ChartGroup] = []
    
    public init(transactions: [TransactionViewModel]) {
        self.transactions = transactions
        createChartGroup()
    }
    
    public func updateTransactions(_ transactions: [TransactionViewModel]) {
        self.transactions = transactions
        createChartGroup()
    }
    
    public func createChartGroup() {
        let calendar = Calendar.current
        
        let groupedByDate = Dictionary(grouping: transactions) { transaction in
            let components = calendar.dateComponents([.month, .year], from: transaction.rawDateAdded)
            return components
        }
        
        let sortedGroups = groupedByDate.sorted {
            let date1 = calendar.date(from: $0.key) ?? .init()
            let date2 = calendar.date(from: $1.key) ?? .init()
            
            return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
        }
        
        let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
            let date = calendar.date(from: dict.key) ?? .init()
            let income = dict.value.filter { $0.type.rawValue == TransactionTypeViewModel.income.rawValue }
            let expense = dict.value.filter { $0.type.rawValue == TransactionTypeViewModel.expense.rawValue }
            
            let incomeTotalValue = total(income, type: .income)
            let expenseTotalValue = total(expense, type: .expense)
            
            return ChartGroup(
                date: date,
                types: [
                    ChartType(totalValue: incomeTotalValue, type: .income),
                    ChartType(totalValue: expenseTotalValue, type: .expense)
                ],
                totalIncome: incomeTotalValue,
                totalExpense: expenseTotalValue
            )
        }
        
        DispatchQueue.main.async {
            self.chartGroups = chartGroups
        }
    }
    
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    private func total(_ transactions: [TransactionViewModel], type: TransactionTypeViewModel) -> Double {
        return transactions.filter { $0.type.rawValue == type.rawValue }.reduce(0) { $0 + $1.transactionAmount }
    }
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
}
