//
//  CategorySelectionViewController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 12.06.2024.
//

import UIKit

public final class CategorySelectionViewController: UIViewController {
    
    private let collectionView: UICollectionView
    public let viewModel: CategorySelectionViewModel
    public var onLoad: (() -> Void)?
    
    public init(viewModel: CategorySelectionViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 50) / 4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupBindings()
        onLoad?()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onLoad?()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(
            AddButtonCollectionViewCell.self,
            forCellWithReuseIdentifier: AddButtonCollectionViewCell.identifier)
        
        // Add long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:))
        )
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    private func setupBindings() {
        viewModel.categoriesDidUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        title = "Select Category"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point),
              indexPath.item < viewModel.categories.count,
              indexPath.item >= viewModel.predefinedCategories.count else { return }
        
        presentDeleteAlert(for: indexPath)
    }
}

extension CategorySelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < viewModel.categories.count {
            return makeCategoryCollectionViewCell(collectionView, indexPath)
        } else {
            return makeCrateCategoryButton(collectionView, indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.handleSelection(at: indexPath)
    }
    
    // MARK: - Helpers
    
    fileprivate func makeCategoryCollectionViewCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        let category = viewModel.categories[indexPath.item]
        cell.configureCell(with: category)
        return cell
    }
    
    fileprivate func makeCrateCategoryButton(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddButtonCollectionViewCell.identifier, for: indexPath) as! AddButtonCollectionViewCell
        cell.configure(
            withTitle: "Create",
            circularViewColor: UIColor(hex: "#9bb58e"),
            image: UIImage(systemName: "plus"),
            imageTintColor: .black,
            titleFont: .systemFont(ofSize: 14, weight: .bold),
            circularViewTopPadding: 10,
            circularViewWidthMultiplier: 0.6
        )
        cell.addCategoryAction = { [weak self] in
            self?.viewModel.onAddCategorySelected?()
        }
        return cell
    }
}

// MARK: - Helper code for the user defined categories deletion
extension CategorySelectionViewController {
    
    private func presentDeleteAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = createDeleteAction(for: indexPath)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func createDeleteAction(for indexPath: IndexPath) -> UIAlertAction {
        return UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            let predefinedCategoriesCount = self.viewModel.predefinedCategories.count
            let userDefinedIndex = indexPath.item - predefinedCategoriesCount
            self.viewModel.deleteUserDefinedCategory(at: userDefinedIndex)
        }
    }
}
