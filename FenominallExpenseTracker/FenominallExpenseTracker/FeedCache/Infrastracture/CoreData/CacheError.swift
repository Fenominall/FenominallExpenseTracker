//
//  CacheError.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 30.04.2024.
//

import Foundation

enum CacheError: Error {
    case transactionIDMismatch
    case unableToCreateMutableCopy
    case unableToSaveContext
    case missingManagedObjectContext
    case transactionNotFound
    case categoryNotFound
}
