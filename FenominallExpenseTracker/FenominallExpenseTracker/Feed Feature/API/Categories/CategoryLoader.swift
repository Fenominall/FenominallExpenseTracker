//
//  CategoryLoader.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 24.06.2024.
//

import Foundation

public protocol CategoryLoader {
    typealias Result = Swift.Result<[TransactionCategory], Error>
    func loadCategories(completion: @escaping (Result) -> Void)
}
