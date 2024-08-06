//
//  SectionHeaderCalculator.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 19.05.2024.
//

import Foundation

final class SectionHeaderCalculator {
    static func groupTransactionsByDate(_ transactions: [TransactionCellController]) -> [(date: String, transactions: [TransactionCellController])] {
            let calendar = Calendar.current
            let sortedTransactions = transactions.sorted(by: { $0.transactionDate > $1.transactionDate }) // Sort in descending order
            var groupedTransactions: [(date: String, transactions: [TransactionCellController])] = []
            
            for transaction in sortedTransactions {
                let transactionDate = transaction.transactionDate
                let components = calendar.dateComponents([.year, .month, .day], from: transactionDate)
                let date = calendar.date(from: components)!
                let formattedDate = convertDateForShort(with: date)
                
                // Check if the date already exists in the groupedTransactions array
                if let index = groupedTransactions.firstIndex(where: { $0.date == formattedDate }) {
                    // Append the transaction to the existing group
                    groupedTransactions[index].transactions.append(transaction)
                } else {
                    // Create a new group for the date and append the transaction
                    groupedTransactions.append((date: formattedDate, transactions: [transaction]))
                }
            }
            
            return groupedTransactions
        }

    static func calculateTotalAmount(for transactions: [TransactionCellController]) -> Double {
        return transactions.reduce(0) { $0 + $1.amount }
    }
}

