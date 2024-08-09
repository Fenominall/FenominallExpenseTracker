//
//  CreateCategoryViewController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 12.06.2024.
//

import Foundation
import UIKit
import FenominallExpenseTracker

public final class CreateCategoryViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: CategoryCreationViewModel
    private var selectedColorIndexPath: IndexPath?
    private var selectedIconIndexPath: IndexPath?
    
    public init(viewModel: CategoryCreationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var previewCircularView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var previewImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "infinity")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        return image
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Category Name"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 12
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        return textField
    }()
    
    private lazy var expenseTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Expenses".capitalized
        label.textColor = .label
        return label
    }()
    
    private lazy var incomeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Income".capitalized
        label.textColor = .label
        return label
    }()
    
    private lazy var iconsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Icons".capitalized
        label.textColor = .label
        return label
    }()
    
    private lazy var colorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Color".capitalized
        label.textColor = .label
        return label
    }()
    
    private lazy var expenseRadioButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.tag = 0
        button.addTarget(
            self,
            action: #selector(radioButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var incomeRadioButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.tag = 1
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var expensesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [expenseRadioButton, expenseTitleLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.backgroundColor = .systemBackground
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var incomeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [incomeRadioButton, incomeTitleLabel])
        stack.axis = .horizontal
        stack.backgroundColor = .systemBackground
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var transactionTypesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [expensesStackView, incomeStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemBackground
        stack.axis = .horizontal
        stack.spacing = 30
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 20 - 30) / 8
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            IconCollectionViewCell.self,
            forCellWithReuseIdentifier: IconCollectionViewCell.identifier
        )
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.identifier
        )
        collectionView.register(
            AddButtonCollectionViewCell.self,
            forCellWithReuseIdentifier: AddButtonCollectionViewCell.identifier
        )
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        return collectionView
    }()
    
    private lazy var addNewCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .orange
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(
            self,
            action: #selector(addNewCategoryButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Init
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setUpDefaultChoiceForRadioButton()
    }
    
    // MARK: - Helpers
    private func setupBindings() {
        viewModel.canAddCategory = { [weak self] isEnabled in
            self?.addNewCategoryButton.isEnabled = true
            self?.addNewCategoryButton.alpha = isEnabled ? 1 : 0.5
        }
    }
    
    private func setUpDefaultChoiceForRadioButton() {
        expenseRadioButton.isSelected = true
        RadioButton.currentlySelectedButton = expenseRadioButton
    }
    
    private func setupUI() {
        title = "Create Category"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(previewCircularView)
        containerView.addSubview(previewImageView)
        containerView.addSubview(transactionTypesStackView)
        containerView.addSubview(categoryNameTextField)
        containerView.addSubview(collectionView)
        containerView.addSubview(addNewCategoryButton)
        
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
            
            previewCircularView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 10),
            previewCircularView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            previewCircularView.widthAnchor.constraint(equalToConstant: 40),
            previewCircularView.heightAnchor.constraint(equalToConstant: 40),
            
            previewImageView.centerXAnchor.constraint(equalTo: previewCircularView.centerXAnchor),
            previewImageView.centerYAnchor.constraint(equalTo: previewCircularView.centerYAnchor),
            previewImageView.widthAnchor.constraint(equalToConstant: 25),
            previewImageView.heightAnchor.constraint(equalToConstant: 25),
            
            categoryNameTextField.leadingAnchor.constraint(equalTo: previewCircularView.trailingAnchor, constant: 10),
            categoryNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10),
            categoryNameTextField.centerYAnchor.constraint(equalTo: previewCircularView.centerYAnchor),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            transactionTypesStackView.topAnchor.constraint(equalTo: previewCircularView.bottomAnchor, constant: 30),
            transactionTypesStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            
            collectionView.topAnchor.constraint(equalTo: transactionTypesStackView.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 400),
            
            addNewCategoryButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            addNewCategoryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            addNewCategoryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            addNewCategoryButton.heightAnchor.constraint(equalToConstant: 40),
            addNewCategoryButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func radioButtonTapped(_ sender: RadioButton) {
        switch sender.tag {
        case 0:
            viewModel.updateTransactionType(to: .expense)
        case 1:
            viewModel.updateTransactionType(to: .income)
        default:
            break
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.categoryName = categoryNameTextField.text ?? ""
    }
    
    @objc private func addNewCategoryButtonTapped() {
        viewModel.addNewCategory()
        viewModel.didNotifyNewCategoryAdded()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionView setup
extension CreateCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return IconSection.finances.assetNames.count + 1
        case 1:
            let randomColorsCount = ColorPallets.colors.shuffled().prefix(7).count
            return randomColorsCount + 1
        default:
            return 0
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: // Icons
            if indexPath.item < IconSection.finances.assetNames.count {
                let iconName = IconSection.finances.assetNames[indexPath.item]
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: IconCollectionViewCell.identifier,
                    for: indexPath
                ) as! IconCollectionViewCell
                cell.configure(with: iconName)
                return cell
            } else {
                return configureCell(
                    collectionView: collectionView,
                    indexPath: indexPath,
                    addButtonTitle: "Add Icon",
                    addButtonItemIndex: IconSection.finances.assetNames.count,
                    circularViewTopPadding: 10,
                    circularViewWidthMultiplier: 0.5,
                    addButtonAction: { [weak self] in
                        self?.showIconsCatalogViewController()
                    },
                    configureRegularCell: { _ in }
                )
            }
        case 1: // Colors
            return configureCell(
                collectionView: collectionView,
                indexPath: indexPath,
                addButtonTitle: "Add Color",
                addButtonItemIndex: 6,
                circularViewTopPadding: 0,
                circularViewWidthMultiplier: 0.5,
                addButtonAction: { [weak self] in
                    self?.testShowColorPalletsViewController()
                },
                configureRegularCell: { cell in
                    let color = ColorPallets.colors[indexPath.item]
                    (cell as! ColorCollectionViewCell).configure(with: color)
                }
            )
        default:
            fatalError("Unexpected section")
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 {
            // Deselect previous icon cell if any
            if let previousIconIndexPath = selectedIconIndexPath {
                if let previousIconCell = collectionView
                    .cellForItem(at: previousIconIndexPath) as? IconCollectionViewCell {
                    previousIconCell.setSelected(false)
                }
            }
            
            // Select the new icon cell
            selectedIconIndexPath = indexPath
            if let cell = collectionView.cellForItem(at: indexPath) as? IconCollectionViewCell {
                cell.setSelected(true)
                let iconName = IconSection.finances.assetNames[indexPath.item]
                viewModel.selectIcon(iconName.description)
                setAssetsImage(with: iconName, imageView: previewImageView)
            }
        } else if indexPath.section == 1 {
            // Deselect previous color cell if any
            if let previousColorIndexPath = selectedColorIndexPath {
                if let previousColorCell = collectionView
                    .cellForItem(at: previousColorIndexPath) as? ColorCollectionViewCell {
                    previousColorCell.showCheckmark(false, animated: true)
                }
            }
            
            // Select the new color cell
            selectedColorIndexPath = indexPath
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                let color = ColorPallets.colors[indexPath.item]
                viewModel.selectColor(color.description)
                previewCircularView.backgroundColor = UIColor(hex: color)
                cell.showCheckmark(true, animated: true)
            }
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    private func showIconsCatalogViewController() {
        let vc = IconsCatalogViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func testShowColorPalletsViewController() {
        let vc = ColorPalletsViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sectionInsets: CGFloat = 10
        let interItemSpacing: CGFloat = 10
        let itemsPerRow: CGFloat = (indexPath.section == 0) ? 4 : 8
        let availableWidth = collectionView.frame.width - sectionInsets * 2 - interItemSpacing * (itemsPerRow - 1)
        let regularCellWidth = (availableWidth / itemsPerRow) - 1
        
        if indexPath.section == 0 && indexPath.item ==
            IconSection.finances.assetNames.count || indexPath.section == 1 && indexPath.item == 6 {
            
            let addButtonWidth = availableWidth / itemsPerRow
            return CGSize(width: addButtonWidth, height: addButtonWidth)
        } else {
            return CGSize(width: regularCellWidth, height: regularCellWidth)
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath
        )
        
        configureHeaderLabel(header, forSection: indexPath.section)
        
        return header
    }
    
    private func configureHeaderLabel(_ header: UICollectionReusableView, forSection section: Int) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        header.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        
        switch section {
        case 0:
            label.text = "Icons"
        case 1:
            label.text = "Colors"
        default:
            label.text = ""
        }
    }
    
    
    private func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        addButtonTitle: String,
        addButtonItemIndex: Int,
        circularViewTopPadding: CGFloat,
        circularViewWidthMultiplier: CGFloat,
        addButtonAction: @escaping () -> Void,
        configureRegularCell: (UICollectionViewCell) -> Void
    ) -> UICollectionViewCell {
        if indexPath.item == addButtonItemIndex {
            let sectionInsets: CGFloat = 10
            let interItemSpacing: CGFloat = 10
            let itemsPerRow: CGFloat = (indexPath.section == 0) ? 4 : 8
            let availableWidth = collectionView.frame.width - sectionInsets * 2 - interItemSpacing * (itemsPerRow - 1)
            let itemWidth = (availableWidth / itemsPerRow) - 1
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddButtonCollectionViewCell.identifier,
                for: indexPath
            ) as! AddButtonCollectionViewCell
            
            cell.configure(
                withTitle: addButtonTitle,
                circularViewColor: UIColor(hex: "#9bb58e"),
                image: UIImage(systemName: "plus"),
                imageTintColor: .black,
                titleFont: .systemFont(ofSize: 12),
                circularViewTopPadding: circularViewTopPadding,
                circularViewWidthMultiplier: circularViewWidthMultiplier
            )
            cell.addCategoryAction = addButtonAction
            cell.contentView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                cell.contentView.widthAnchor.constraint(equalToConstant: itemWidth),
                cell.contentView.heightAnchor.constraint(equalToConstant: itemWidth)
            ])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: indexPath.section == 0 ?
                IconCollectionViewCell.identifier : ColorCollectionViewCell.identifier,
                for: indexPath
            )
            configureRegularCell(cell)
            
            return cell
        }
    }
}

// MARK: - ColorPalletsViewControllerDelegate
extension CreateCategoryViewController: ColorPalletsViewControllerDelegate {
    func didSelectColor(_ color: String) {
        deselectPreviousSelection(
            in: collectionView,
            at: selectedColorIndexPath,
            cellType: .color
        )
        viewModel.selectColor(color)
        previewCircularView.backgroundColor = UIColor(hex: color)
    }
}

// MARK: - IconsCatalogViewControllerDelegate
extension CreateCategoryViewController: IconsCatalogViewControllerDelegate {
    func didSelectIcon(_ iconName: String) {
        deselectPreviousSelection(
            in: collectionView,
            at: selectedIconIndexPath,
            cellType: .icon
        )
        viewModel.selectIcon(iconName)
        setAssetsImage(with: iconName, imageView: previewImageView)
    }
}

extension CreateCategoryViewController {
    private func setAssetsImage(with name: String, imageView: UIImageView) {
        AssetsImageLoader.getAssetImage(byName: name, in: imageView)
    }
}

extension CreateCategoryViewController {
    enum CellType {
        case icon
        case color
    }
    
    func deselectPreviousSelection(
        in collectionView: UICollectionView,
        at indexPath: IndexPath?,
        cellType: CellType
    ) {
        guard let indexPath = indexPath else { return }
        
        switch cellType {
        case .icon:
            (collectionView.cellForItem(at: indexPath) as?
             IconCollectionViewCell)?.setSelected(false)
        case .color:
            (collectionView.cellForItem(at: indexPath) as?
             ColorCollectionViewCell)?.showCheckmark(false, animated: true)
        }
    }
}

