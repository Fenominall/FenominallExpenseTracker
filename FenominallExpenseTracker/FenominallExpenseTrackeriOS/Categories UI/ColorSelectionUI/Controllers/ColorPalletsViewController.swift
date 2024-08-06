//
//  ColorPalletsViewController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 13.06.2024.
//

import UIKit

protocol ColorPalletsViewControllerDelegate: AnyObject {
    func didSelectColor(_ color: String)
}

class ColorPalletsViewController: UIViewController {
    weak var delegate: ColorPalletsViewControllerDelegate?
    private let itemsPerRow = 6
    private let collectionViewHeight: CGFloat = 500
    private var selectedIndexPath: IndexPath?
    private var selectedColor: String?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - (CGFloat(itemsPerRow + 1) * 10)) / CGFloat(itemsPerRow)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = calculateNumberOfPages()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    private lazy var selectColorButton: UIButton = {
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
    }
    
    private func setupUI() {
        title = "Select Color"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(collectionView)
        containerView.addSubview(pageControl)
        containerView.addSubview(selectColorButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            selectColorButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            selectColorButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            selectColorButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            selectColorButton.heightAnchor.constraint(equalToConstant: 40),
            selectColorButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    private func calculateNumberOfPages() -> Int {
        let itemWidth = (UIScreen.main.bounds.width - (CGFloat(itemsPerRow + 1) * 10)) / CGFloat(itemsPerRow)
        let itemsPerColumn = Int(collectionViewHeight / itemWidth)
        let itemsPerPage = itemsPerRow * itemsPerColumn
        return (ColorPallets.colors.count + itemsPerPage - 1) / itemsPerPage
    }
    
    private func calculateItemsPerPage() -> Int {
        let itemWidth = (UIScreen.main.bounds.width - (CGFloat(itemsPerRow + 1) * 10)) / CGFloat(itemsPerRow)
        let itemsPerColumn = Int(collectionViewHeight / itemWidth)
        return itemsPerRow * itemsPerColumn
    }
    
    @objc private func didTapSelectButton() {
        guard let selectedColor = selectedColor else { return }
        delegate?.didSelectColor(selectedColor)
        navigationController?.popViewController(animated: true)
    }
}

extension ColorPalletsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calculateNumberOfPages()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsPerPage = calculateItemsPerPage()
        let startIndex = section * itemsPerPage
        let remainingItems = ColorPallets.colors.count - startIndex
        return min(remainingItems, itemsPerPage)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
        let itemsPerPage = calculateItemsPerPage()
        let itemIndex = indexPath.section * itemsPerPage + indexPath.item
        if itemIndex < ColorPallets.colors.count {
            let color = ColorPallets.colors[itemIndex]
            cell.configure(with: color)
            cell.showCheckmark(false, animated: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - (CGFloat(itemsPerRow + 1) * 10)) / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectAndMarkTheColor(collectionView, indexPath)
    }
    
    fileprivate func selectAndMarkTheColor(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        deselectPreviousCell(in: collectionView)
        
        let itemsPerPage = calculateItemsPerPage()
        let itemIndex = indexPath.section * itemsPerPage + indexPath.item
        
        guard itemIndex < ColorPallets.colors.count else { return }
        
        selectedColor = ColorPallets.colors[itemIndex]
        selectCell(at: indexPath, in: collectionView)
        
        selectedIndexPath = indexPath
        selectColorButton.isEnabled = true
        selectColorButton.alpha = 1
    }
    
    fileprivate func deselectPreviousCell(in collectionView: UICollectionView) {
        if let previousIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousIndexPath) as? ColorCollectionViewCell {
            previousCell.showCheckmark(false, animated: true)
        }
    }
    
    fileprivate func selectCell(at indexPath: IndexPath, in collectionView: UICollectionView) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
            selectedCell.showCheckmark(true, animated: true)
        }
    }
    
}
