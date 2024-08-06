//
//  FilterOptions.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 08.06.2024.
//

import Foundation

public enum FilterOption: String, CaseIterable {
    case all = "All"
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
    case lastYear = "Last Year"

    public func dateRange() -> (startDate: Date?, endDate: Date?) {
        let calendar = Calendar.current
        let now = Date()

        switch self {
        case .all:
            return (startDate: nil, endDate: nil)
        case .lastWeek:
            if let startOfWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: now) {
                return (startDate: startOfWeek, endDate: now)
            }
        case .lastMonth:
            if let startOfMonth = calendar.date(byAdding: .month, value: -1, to: now) {
                return (startDate: startOfMonth, endDate: now)
            }
        case .lastYear:
            if let startOfYear = calendar.date(byAdding: .year, value: -1, to: now) {
                return (startDate: startOfYear, endDate: now)
            }
        }
        return (startDate: nil, endDate: nil)
    }
}


