//
//  UIRefreshControl+Helpers.swift .swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 22.05.2024.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        DispatchQueue.mainAsync {
            return isRefreshing ? self.beginRefreshing() : self.endRefreshing()
        }
    }
}

extension UIActivityIndicatorView {
    func update(isAnimating: Bool) {
        DispatchQueue.mainAsync {
            return isAnimating ? self.startAnimating() : self.stopAnimating()
        }
    }
}
