//
//  CategoryCollectionViewCell.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 09.06.2024.
//

import UIKit
import FenominallExpenseTracker

public class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let circularView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectedColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(containerView)
        containerView.addSubview(circularView)
        circularView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            circularView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 9),
            circularView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            circularView.heightAnchor.constraint(equalTo: circularView.widthAnchor),
            circularView.widthAnchor.constraint(equalToConstant: 60),
            
            imageView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: circularView.widthAnchor, multiplier: 0.55),
            imageView.heightAnchor.constraint(equalTo: circularView.heightAnchor, multiplier: 0.55),
            
            titleLabel.topAnchor.constraint(equalTo: circularView.bottomAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
    }
    
    private func updateSelectionState() {
        UIView.animate(withDuration: 0.3) {
            if self.isSelected {
                // Update cell for selected state
                self.containerView.backgroundColor = self.circularView.backgroundColor
                self.imageView.tintColor = .systemBackground
                self.titleLabel.textColor = .label
                self.containerView.layer.cornerRadius = 10
            } else {
                // Update cell for deselected state
                self.containerView.backgroundColor = .clear
                self.imageView.tintColor = .systemBackground
                self.titleLabel.textColor = .label
                self.containerView.layer.cornerRadius = 0
            }
        }
    }
    
    func configureCell(with category: TransactionCategory) {
        titleLabel.text = category.name.capitalized
        
        if let hexColor = UIColor(hex: category.hexColor) {
            circularView.backgroundColor = hexColor
            selectedColor = hexColor  // Assign selectedColor here if needed
        }
        
        AssetsImageLoader.getAssetImage(byName: category.imageData, in: imageView)
        
        imageView.tintColor = .systemBackground
        titleLabel.textColor = .label
    }
}
