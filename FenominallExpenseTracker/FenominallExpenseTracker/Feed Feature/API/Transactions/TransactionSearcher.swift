//
//  TransactionSearcher.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 06.06.2024.
//

import Foundation

public protocol TransactionSearcher {
    typealias Result = Swift.Result<[Transaction], Error>
    func searchAndLoad(with argument: String, filterOption: FilterOption?,completion: @escaping (Result) -> Void)
}
