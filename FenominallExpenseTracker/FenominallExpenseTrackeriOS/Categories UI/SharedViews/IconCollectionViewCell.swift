//
//  IconCollectionViewCell.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 13.06.2024.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    static let identifier = "IconCollectionViewCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let circularView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(circularView)
        circularView.addSubview(imageView)
        
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
        ])
    }
    
    func configure(with name: String?) {
        AssetsImageLoader.getAssetImage(byName: name, in: imageView)
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            circularView.backgroundColor = .darkGray
            circularView.applyShadow()
        } else {
            circularView.backgroundColor = .lightGray
            circularView.removeShadow()
        }
    }
}

