//
//  CreateCategorySectionHeaderCollectionView.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 12.06.2024.
//

import UIKit

class SectionHeaderCollectionView: UICollectionReusableView {
    static let identifier = "SectionHeaderCollectionView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
