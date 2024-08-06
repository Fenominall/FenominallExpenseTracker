//
//  ChartModel.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 03.06.2024.
//

import Foundation
import FenominallExpenseTracker

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    var date: Date
    var types: [ChartType]
    var totalIncome: Double
    var totalExpense: Double
}

struct ChartType: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var type: TransactionType
}
