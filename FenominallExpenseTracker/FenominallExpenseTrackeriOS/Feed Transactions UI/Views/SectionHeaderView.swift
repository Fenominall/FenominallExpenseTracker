//
//  SectionHeaderView.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 19.05.2024.
//

import Foundation
import UIKit

public final class SectionHeaderView: UIView {

    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(totalAmountLabel)
        addSubview(dateLabel)
        
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            totalAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withTotalAmount totalAmount: Double, date: String, type: TransactionTypeViewModel) {
        totalAmountLabel.text = type == .income ?
        "+ \(currencyString(totalAmount))" :
        "- \(currencyString(totalAmount))"
        
        dateLabel.text = date
    }
}
