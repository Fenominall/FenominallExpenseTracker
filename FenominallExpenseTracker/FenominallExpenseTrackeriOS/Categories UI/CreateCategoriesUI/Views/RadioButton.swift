//
//  RadioButton.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 12.06.2024.
//

import Foundation
import UIKit

final class RadioButton: UIButton {
    static var currentlySelectedButton: RadioButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.setImage(UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.setImage(UIImage(systemName: "largecircle.fill.circle")?.withRenderingMode(.alwaysTemplate), for: .selected)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        if RadioButton.currentlySelectedButton != self {
            RadioButton.currentlySelectedButton?.isSelected = false
            RadioButton.currentlySelectedButton = self
            self.isSelected = true
        }
    }
}
