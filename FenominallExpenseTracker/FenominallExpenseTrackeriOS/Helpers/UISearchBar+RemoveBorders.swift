//
//  UISearchBar+RemoveBorders.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 21.05.2024.
//

import UIKit

extension UISearchBar {
    func customizeAppearance() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .any, barMetrics: .default)

        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.borderStyle = .none
            textField.backgroundColor = .white
        }
    }
}

