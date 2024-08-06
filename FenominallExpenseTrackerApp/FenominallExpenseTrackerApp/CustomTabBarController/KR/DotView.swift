//
//  DotView.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 03.06.2024.
//

import UIKit

// DotView class
class DotView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.backgroundColor = .red
    }
}
