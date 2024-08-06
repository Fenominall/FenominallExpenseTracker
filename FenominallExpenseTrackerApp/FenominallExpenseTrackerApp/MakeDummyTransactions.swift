//
//  MakeDummyTransactions.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 22.05.2024.
//

import Foundation
import Combine
import FenominallExpenseTracker

public class MakeDummyTransactions {
    public static let shared = MakeDummyTransactions()
    
    public func loadTransactions() -> AnyPublisher<[Transaction], Error> {
        Future<[Transaction], Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                promise(.success([
                    Transaction(id: UUID(), title: "First", remarks: "1Remark", amount: 100.25, dateAdded: Date.now - TimeInterval(60 * 60 * 24), type: .expense, category: ExpenseCategory.cafe),
                    Transaction(id: UUID(), title: "Eigth", remarks: "Eigth", amount: 10000, dateAdded: Date.now, type: .income, category: IncomeCategory.gift),
                    Transaction(id: UUID(), title: "Second", remarks: "2Remark", amount: 4234, dateAdded: .now + 1, type: .expense, category: ExpenseCategory.cafe),
                    Transaction(id: UUID(), title: "Third", remarks: "Salary", amount: 500.55, dateAdded: Date.now - TimeInterval(100 * 100 * 24), type: .income, category: IncomeCategory.paycheck),
                    Transaction(id: UUID(), title: "Fourth", remarks: "NewSalary", amount: 9909, dateAdded: Date.now - TimeInterval(120 * 120 * 24), type: .income, category: IncomeCategory.gift),
                    Transaction(id: UUID(), title: "Fifth", remarks: "Spair Parts", amount: 55, dateAdded: .now + 1, type: .expense, category: ExpenseCategory.other),
                    Transaction(id: UUID(), title: "Sixth", remarks: "Restaurant", amount: 222, dateAdded: .now + 1, type: .expense, category: ExpenseCategory.cafe),
                    Transaction(id: UUID(), title: "Seventh", remarks: "Gym Session", amount: 20, dateAdded: Date.now - TimeInterval(240 * 240 * 24), type: .expense, category: ExpenseCategory.workout),
                ]))
            }
        }
        .receive(on: DispatchQueue.main) // Ensure the publisher emits on the main thread
        .eraseToAnyPublisher()
    }
}
