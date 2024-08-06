//
//  AddButtonCollectionViewCell.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 09.06.2024.
//

import UIKit

public class AddButtonCollectionViewCell: UICollectionViewCell {
    static let identifier = "AddButtonCollectionViewCell"
    
    // MARK: - Properties
    
    open lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    open lazy var circularView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    open lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var addCategoryAction: (() -> Void)?
    
    // Constraints for dynamic adjustment
    private var circularViewTopConstraint: NSLayoutConstraint?
    private var circularViewWidthConstraint: NSLayoutConstraint?
    private var circularViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    open func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(circularView)
        circularView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addCategoryTapped))
        circularView.addGestureRecognizer(tapGesture)
    }
    
    open func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        circularViewTopConstraint = circularView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 9)
        circularViewWidthConstraint = circularView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5)
        circularViewHeightConstraint = circularView.heightAnchor.constraint(equalTo: circularView.widthAnchor)
        
        NSLayoutConstraint.activate([
            circularViewTopConstraint!,
            circularViewWidthConstraint!,
            circularViewHeightConstraint!,
            circularView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: circularView.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: circularView.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: circularView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
    }
    
    // Ensure circular shape
    override public func layoutSubviews() {
        super.layoutSubviews()
        circularView.layer.cornerRadius = circularView.bounds.width / 2
    }
    
    // MARK: - Configuration
    
    open func configure(
        withTitle title: String,
        circularViewColor: UIColor? = nil,
        image: UIImage?,
        imageTintColor: UIColor? = nil,
        titleFont: UIFont = .systemFont(ofSize: 14, weight: .regular),
        circularViewTopPadding: CGFloat = 9,
        circularViewWidthMultiplier: CGFloat = 0.5
    ) {
        titleLabel.text = title
        titleLabel.font = titleFont
        circularView.backgroundColor = circularViewColor ?? .clear
        imageView.image = image
        imageView.tintColor = imageTintColor
        
        circularViewTopConstraint?.constant = circularViewTopPadding
        circularViewWidthConstraint?.isActive = false
        circularViewWidthConstraint = circularView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: circularViewWidthMultiplier)
        circularViewWidthConstraint?.isActive = true
        
        setNeedsLayout()
    }
    
    // MARK: - Actions
    
    @objc open func addCategoryTapped() {
        addCategoryAction?()
    }
}
