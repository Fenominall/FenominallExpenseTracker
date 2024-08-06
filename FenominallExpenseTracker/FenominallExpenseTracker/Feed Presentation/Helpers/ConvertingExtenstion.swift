//
//  UIView+Extenstion.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 14.05.2024.
//

import Foundation
import FenominallExpenseTracker

func currencyString(_ value: Double?, allowedDigits: Int = 2) -> String {
    guard let validAmount = value else {
            return "0.00"
        }
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = allowedDigits
    
    return formatter.string(from: .init(value: validAmount)) ?? ""
}

var currencySymbol: String {
    let locale = Locale.current
    
    return locale.currencySymbol ?? ""
}

func convertDate(with date: Date?) -> String {
    guard let validDate = date else {
        return "Unknown Date"
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: validDate)
}

func convertDateForShort(with date: Date) -> String {
    let calendar = Calendar.current
    if calendar.isDateInToday(date) {
        return "Today"
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM"
        return dateFormatter.string(from: date)
    }
}
