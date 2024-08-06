//
//  UIView+ApplyShadowExtension.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 14.05.2024.
//

import UIKit

extension UIView {
    func applyShadow(color: UIColor = .black,
                     opacity: Float = 0.5,
                     offset: CGSize = CGSize(width: 0, height: 2),
                     radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        clipsToBounds = false
    }
    
    func removeShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.masksToBounds = true
    }
}
