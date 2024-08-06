//
//  CategorySaver.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 21.06.2024.
//

import Foundation

public protocol CategorySaver {
    typealias SaveResult = Swift.Result<Void, Error>
    func addNewCategory(_ category: TransactionCategory, completion: @escaping (SaveResult) -> Void)
}
