//
//  CollectionView+MaxCellCount+CategoryCell.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 12.06.2024.
//

import UIKit
import FenominallExpenseTracker

extension UICollectionView {
    func maxCategoryCells(for categories: [TransactionCategory], maxCount: Int = 7) -> Int {
        return min(categories.count, maxCount)
    }
    
    func isCategoryCell(for indexPath: IndexPath, categories: [TransactionCategory], maxCount: Int = 7) -> Bool {
        return indexPath.item < maxCategoryCells(for: categories, maxCount: maxCount)
    }
}
