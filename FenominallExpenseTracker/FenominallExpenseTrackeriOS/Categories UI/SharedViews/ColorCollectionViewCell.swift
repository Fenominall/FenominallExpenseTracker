//
//  ColorCollectionViewCell.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 13.06.2024.
//

import UIKit

public class ColorCollectionViewCell: UICollectionViewCell {
    static let identifier = "ColorCollectionViewCell"
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = contentView.bounds.width / 2
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(systemName: "checkmark")?
                .withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.isHidden = true
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
        contentView.addSubview(colorView)
        contentView.addSubview(checkMarkImageView)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkMarkImageView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            checkMarkImageView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            checkMarkImageView.widthAnchor.constraint(equalToConstant: 30),
            checkMarkImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configure(with hexColor: String) {
        colorView.backgroundColor = UIColor(hex: hexColor)
    }
    
    func showCheckmark(_ show: Bool, animated: Bool) {
        if animated {
            UIView.transition(with: checkMarkImageView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                self.checkMarkImageView.isHidden = !show
            })
        } else {
            checkMarkImageView.isHidden = !show
        }
        
        show == true ? colorView.applyShadow() : colorView.removeShadow()
    }
}
