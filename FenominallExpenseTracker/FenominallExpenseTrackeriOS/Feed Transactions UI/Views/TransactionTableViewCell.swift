//
//  TransactionTableViewCell.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 10.05.2024.
//

import UIKit
import FenominallExpenseTracker

class TransactionTableViewCell: UITableViewCell {    
    // MARK: - UI
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.applyShadow(color: .label ,opacity: 0.3)
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var categoryImageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50 / 2
        return view
    }()
    
    lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        return imageView
    }()
    
    lazy var sumPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    lazy var transactionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    lazy var transactionCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    lazy var dateAddedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .label
        return label
    }()
    
    // MARK: -LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.subviews.forEach{
            $0.removeFromSuperview()
        }
    }
    
    func setupConstraints() {
        self.contentView.addSubview(containerView)
        
        containerView.addSubview(contentStackView)
        containerView.addSubview(categoryImageBackgroundView)
        containerView.addSubview(categoryImageView)
        containerView.addSubview(sumPriceLabel)
        
        contentStackView.addArrangedSubview(transactionNameLabel)
        contentStackView.addArrangedSubview(transactionCategoryLabel)
        contentStackView.addArrangedSubview(dateAddedLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:  -8),
            
            categoryImageBackgroundView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            categoryImageBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            categoryImageBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            categoryImageBackgroundView.widthAnchor.constraint(equalToConstant: 50),
            
            categoryImageView.heightAnchor.constraint(equalToConstant: 30),
            categoryImageView.widthAnchor.constraint(equalToConstant: 30),
            categoryImageView.centerXAnchor.constraint(equalTo: categoryImageBackgroundView.centerXAnchor),
            categoryImageView.centerYAnchor.constraint(equalTo: categoryImageBackgroundView.centerYAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            contentStackView.leadingAnchor.constraint(equalTo: categoryImageBackgroundView.trailingAnchor, constant: 8),
            sumPriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            sumPriceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
