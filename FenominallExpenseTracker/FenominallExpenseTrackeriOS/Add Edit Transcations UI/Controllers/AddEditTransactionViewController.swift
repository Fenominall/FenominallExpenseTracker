//
//  AddTransactionViewController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 16.05.2024.
//

import UIKit
import FenominallExpenseTracker

public final class AddEditTransactionViewController: UIViewController {
    public let viewModel: AddEditTransactionViewModel
    
    // MARK: - UI
    private let titleLabel = makeLabel(withTitle: "Title")
    private let titleTextField = makeTextField()
    private let remarksLabel = makeLabel(withTitle: "Remarks")
    private let remarksTextField = makeTextField()
    private let amountLabel = makeLabel(withTitle: "Amount")
    private let amountTextField = makeTextField()
    private let dateLabel = makeLabel(withTitle: "Date")
    private let datePicker = UIDatePicker()
    private let typeLabel = makeLabel(withTitle: "Type")
    private let categoryLabel = makeLabel(withTitle: "Category")
    private let typeSegmentedControl = UISegmentedControl(items: TransactionTypeViewModel.allCases.map { $0.rawValue.capitalized })
    private let deleteTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.isHidden = true
        button.applyShadow()
        return button
    }()
    private let categoryCollectionView: UICollectionView
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - Initialisation
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardNotifications()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        teardownKeyboardNotifications()
    }
    
    public init(viewModel: AddEditTransactionViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (UIScreen.main.bounds.width - 50) / 4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        categoryCollectionView.register(AddButtonCollectionViewCell.self, forCellWithReuseIdentifier: AddButtonCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkIfTransactionToEdit() {
        if let transaction = viewModel.transactionToEdit {
            editTransaction(transaction)
        }
    }
    
    private func editTransaction(_ transaction: TransactionViewModel?) {
        deleteTransactionButton.isHidden = false
        if let transaction = transaction {
            titleTextField.text = transaction.transactionTitle
            amountTextField.text = String(transaction.transactionAmount)
            remarksTextField.text = transaction.transactionRemars
            datePicker.date = transaction.rawDateAdded
            typeSegmentedControl.selectedSegmentIndex = TransactionTypeViewModel.allCases.firstIndex(of: transaction.type) ?? 0
            categoryCollectionView.reloadData()
        }
    }
    
    private func setupBindings() {
        viewModel.categoriesDidUpdate = { [weak self] in
            self?.categoryCollectionView.reloadData()
        }
    }
    
    private func setupUI() {
        title = "Add Transaction"
        view.backgroundColor = .systemBackground
        
        titleTextField.delegate = self
        titleTextField.textColor = .label
        titleTextField.backgroundColor = .systemBackground
        titleLabel.textColor = .label
        
        remarksTextField.delegate = self
        remarksTextField.textColor = .label
        remarksTextField.backgroundColor = .systemBackground
        remarksLabel.textColor = .label
        
        amountTextField.delegate = self
        amountTextField.placeholder = currencyString(0)
        amountTextField.textColor = .label
        amountTextField.backgroundColor = .systemBackground
        amountLabel.textColor = .label
        
        datePicker.datePickerMode = .date
        datePicker.tintColor = .systemBackground
        datePicker.backgroundColor = .systemBackground
        dateLabel.textColor = .label
        
        typeLabel.textColor = .label
        categoryLabel.textColor = .label
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        typeSegmentedControl.backgroundColor = .systemBackground
        typeSegmentedControl.selectedSegmentTintColor = .systemBackground
        typeSegmentedControl.tintColor = .systemBackground
        typeSegmentedControl.selectedSegmentIndex = 0
        typeSegmentedControl.addTarget(self, action: #selector(typeSegmentChanged), for: .valueChanged)
        
        deleteTransactionButton.addTarget(self, action: #selector(didTapDeleteTransaction), for: .touchUpInside)
        
        navigationController?.navigationItem.backButtonTitle = "Back"
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped)), animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        categoryCollectionView.backgroundColor = .systemBackground
        categoryCollectionView.allowsSelection = true
        categoryCollectionView.allowsMultipleSelection = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [titleLabel, titleTextField, remarksLabel, remarksTextField, amountLabel, amountTextField, datePicker, dateLabel, typeLabel, typeSegmentedControl, categoryLabel, categoryCollectionView, deleteTransactionButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        typeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        deleteTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            remarksLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            remarksLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            remarksTextField.topAnchor.constraint(equalTo: remarksLabel.bottomAnchor, constant: 10),
            remarksTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            remarksTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            amountLabel.topAnchor.constraint(equalTo: remarksTextField.bottomAnchor, constant: 10),
            amountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: -20),
            amountTextField.widthAnchor.constraint(equalToConstant: 220),
            
            dateLabel.topAnchor.constraint(equalTo: remarksTextField.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: 16),
            
            datePicker.centerYAnchor.constraint(equalTo: amountTextField.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            typeLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            typeSegmentedControl.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 16),
            typeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            typeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryLabel.topAnchor.constraint(equalTo: typeSegmentedControl.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            categoryCollectionView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            categoryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 240),  // Adjust as needed
            
            deleteTransactionButton.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 16),
            deleteTransactionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deleteTransactionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteTransactionButton.heightAnchor.constraint(equalToConstant: 40),
            deleteTransactionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    public func updateSelectedCategory(_ category: any FenominallExpenseTracker.TransactionCategory) {
        viewModel.selectedCategory = category
    }
    
    @objc private func didTapDeleteTransaction() {
        let alert = UIAlertController(
            title: "Delete Transaction",
            message: "Are you sure you want to delete this transaction?",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Delete",
                          style: .destructive,
                          handler: {
                              [weak self] _ in
                              self?.viewModel.deleteTransaction()
                              self?.navigationController?.popViewController(animated: true)
                          })
        )
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        present(alert, animated: true)
    }
    
    @objc private func typeSegmentChanged() {
        viewModel.selectedType = TransactionTypeViewModel
            .allCases[typeSegmentedControl.selectedSegmentIndex]
        categoryCollectionView.reloadData()
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let remarks = remarksTextField.text, !remarks.isEmpty,
              let amountText = amountTextField.text,
              let amount = Double(amountText) else {
            // show error
            return
        }
        
        viewModel.saveTransaction(
            title: title,
            remarks: remarks,
            amount: amount,
            date: datePicker.date
        )
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CollectionView
extension AddEditTransactionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.maxCategoryCells(for: viewModel.allCategories) + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isCategoryCell(for: indexPath, categories: viewModel.categories) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            let category = viewModel.categories[indexPath.item]
            cell.configureCell(with: category)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddButtonCollectionViewCell.identifier, for: indexPath) as! AddButtonCollectionViewCell
            cell.configure(
                withTitle: "Add",
                circularViewColor: UIColor(hex: "#9bb58e"),
                image: UIImage(systemName: "plus"),
                imageTintColor: .black,
                titleFont: UIFont.preferredFont(forTextStyle: .headline),
                circularViewTopPadding: 10,
                circularViewWidthMultiplier: 0.6
            )
            cell.addCategoryAction = { [weak self] in
                self?.showCategorySelectionViewController()
            }
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < viewModel.categories.count {
            viewModel.selectedCategory = viewModel.categories[indexPath.item]
        } else {
            showCategorySelectionViewController()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let availableWidth = collectionView.frame.width - (padding * 4)
        let itemWidth = availableWidth / 4
        return CGSize(width: itemWidth, height: itemWidth + 20)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - Helpers
    private static func makeLabel(withTitle title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }
    
    private static func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 12
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.borderStyle = .roundedRect
        textField.applyShadow(opacity: 0.1)
        return textField
    }
}

// MARK: - Keyboard Notifications
extension AddEditTransactionViewController: UITextFieldDelegate {
    //    # Function to return false if the input in UITextFiled is " " or "    ".
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " " || string == "    ") {
            return false
        }
        return true
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:
                                                UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func teardownKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

extension AddEditTransactionViewController {
    private func showCategorySelectionViewController() {
        viewModel.onCategorySelected?(viewModel.selectedType)
    }
}
