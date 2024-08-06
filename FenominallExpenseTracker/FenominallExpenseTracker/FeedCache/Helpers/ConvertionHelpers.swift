//
//  ConvertionHelpers.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 25.06.2024.
//

import Foundation

extension LocalTransactionType {
    func convertToModel() -> TransactionType {
        switch self {
        case .income:
            return .income
        case .expense:
            return .expense
        }
    }
}

extension TransactionType {
    func convertToLocal() -> LocalTransactionType {
        switch self {
        case .income:
            return .income
        case .expense:
            return .expense
        }
    }
}
