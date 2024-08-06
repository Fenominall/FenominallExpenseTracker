//
//  PredefinedTransactionCategory.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 12.05.2024.
//

import Foundation

public enum ExpenseCategory: String, CaseIterable, TransactionCategory {
    case health
    case leisure
    case home
    case cafe
    case education
    case gifts
    case groceries
    case family
    case workout
    case transportation
    case other
    
    public var id: UUID {
        return UUID()
    }
    
    public var name: String {
        return self.rawValue
    }
    
    public var hexColor: String {
        switch self {
        case .health:
            return "#f43636"
        case .leisure:
            return "#5db638"
        case .home:
            return "#2e77d5"
        case .cafe:
            return "#f1cb04"
        case .education:
            return "#db4d87"
        case .gifts:
            return "#9ab68e"
        case .groceries:
            return "#73b6e1"
        case .family:
            return "#f63635"
        case .workout:
            return "#68af45"
        case .transportation:
            return "#2e78cf"
        case .other:
            return "#fb3238"
        }
    }
    
    public var imageData: String? {
        switch self {
            
        case .health:
            return "health.png"
        case .leisure:
            return "leisure.png"
        case .home:
            return "home.png"
        case .cafe:
            return "cafe.png"
        case .education:
            return "education.png"
        case .gifts:
            return "gift.png"
        case .groceries:
            return "groceries.png"
        case .family:
            return "family.png"
        case .workout:
            return "workout.png"
        case .transportation:
            return "transportation.png"
        case .other:
            return "other.png"
        }
    }
    
    public var transactionType: TransactionType {
        return .expense
    }
}
