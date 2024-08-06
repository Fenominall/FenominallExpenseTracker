//
//  TransactionManager.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 29.04.2024.
//

import Foundation

public typealias TransactionManager = TransactionLoader & TransactionCache & TransactionUpdater & TransactionRemover & TransactionSearcher
