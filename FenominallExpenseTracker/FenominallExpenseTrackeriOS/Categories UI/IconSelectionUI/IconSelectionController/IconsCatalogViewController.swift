//
//  IconsCatalogViewController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 18.06.2024.
//

import UIKit

protocol IconsCatalogViewControllerDelegate: AnyObject {
    func didSelectIcon(_ iconName: String)
}

class IconsCatalogViewController: UIViewController {
    weak var delegate: IconsCatalogViewControllerDelegate?
    private let itemsPerRow = 3
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private var selectedIcon: String?
    private var selectedIndexPath: IndexPath?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        collectionView.register(IconSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IconSectionHeaderView.identifier)
        return collectionView
    }()
    
    private lazy var selectIconButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(hex: "#f1e048")
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionView.reloadData()
    }
    
    @objc private func didTapSelectButton() {
        guard let selectedIcon = selectedIcon else { return }
        delegate?.didSelectIcon(selectedIcon)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        title = "Select Icon"
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(selectIconButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: selectIconButton.topAnchor, constant: -20),
            
            selectIconButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            selectIconButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            selectIconButton.heightAnchor.constraint(equalToConstant: 40),
            selectIconButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension IconsCatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return IconSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IconSection.allCases[section].assetNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as! IconCollectionViewCell
        let iconSection = IconSection.allCases[indexPath.section]
        let iconName = iconSection.assetNames[indexPath.item]
        print("Configuring cell with icon: \(iconName)")
        cell.configure(with: iconName)
        cell.setSelected(indexPath == selectedIndexPath)
        return cell    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath) as? IconCollectionViewCell
            previousCell?.setSelected(false)
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! IconCollectionViewCell
        cell.setSelected(true)
        selectedIndexPath = indexPath
        
        let iconSection = IconSection.allCases[indexPath.section]
        let iconName = iconSection.assetNames[indexPath.item]
        selectedIcon = iconName
        
        selectIconButton.alpha = 1
        selectIconButton.isEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IconSectionHeaderView.identifier, for: indexPath) as! IconSectionHeaderView
            let section = IconSection.allCases[indexPath.section]
            print("Configuring header for section: \(section.rawValue)")
            headerView.configure(with: section.rawValue)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}
