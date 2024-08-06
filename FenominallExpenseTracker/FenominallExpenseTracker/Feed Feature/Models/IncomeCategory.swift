//
//  IncomeCategory.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 13.05.2024.
//

import Foundation

public enum IncomeCategory: String, CaseIterable, TransactionCategory {
    case paycheck
    case gift
    case interest
    case other
    
    public var id: UUID {
        return UUID()
    }
    
    public var name: String {
        return self.rawValue
    }
    
    public var hexColor: String {
        switch self {
            
        case .paycheck:
            return "#2e78cf"
        case .gift:
            return "#d84e89"
        case .interest:
            return "#68af45"
        case .other:
            return "#6bae45"
        }
    }
    
    public var imageData: String? {
        switch self {
            
        case .paycheck:
            return "paycheck.png"
        case .gift:
            return "gift.png"
        case .interest:
            return "interest.png"
        case .other:
            return "other.png"
        }
    }
    
    public var transactionType: TransactionType {
        return .income
    }
}

