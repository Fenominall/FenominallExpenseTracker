//
//  UITableView.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 11.05.2024.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        self.register(T.self, forCellReuseIdentifier: identifier)        
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type) -> T {
        let identifier = String(describing: cellType)
        if self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) is T == false {
            self.register(cellType, forCellWithReuseIdentifier: identifier)
        }
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}

