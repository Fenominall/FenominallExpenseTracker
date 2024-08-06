//
//  Extension+DispatchQueue.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 02.06.2024.
//

import Foundation

extension DispatchQueue {
    static func mainAsync(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
