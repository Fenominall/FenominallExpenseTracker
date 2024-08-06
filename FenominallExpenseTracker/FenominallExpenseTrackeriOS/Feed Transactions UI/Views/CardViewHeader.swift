//
//  TransactionsHeaderView.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 10.05.2024.
//

public protocol CardViewHeaderDelegate: AnyObject {
    func segmentedControlValueChanged(to type: TransactionTypeViewModel)
}

import UIKit
import FenominallExpenseTracker

public final class CardViewHeader: UITableViewHeaderFooterView {
    public static let identifier = "CardViewHeader"
    
    public weak var delegate: CardViewHeaderDelegate?
    
    // MARK: - Properties
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.applyShadow(color: .systemBackground, opacity: 0.3)
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: TransactionTypeViewModel.allCases.map { $0.rawValue.capitalized })
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemBackground
        control.backgroundColor = .systemBackground
        control.applyShadow(color: .systemBackground)
        control.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var trendImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var topSumTrendStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalAmountLabel, trendImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var incomeAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var expenseAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    // MARK: - Initialisation
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureTotal(forIncome income: Double, forExpense expense: Double) {
        trendImage.image = UIImage(systemName: expense > income ?
                                   "chart.line.downtrend.xyaxis" :
                                    "chart.line.uptrend.xyaxis")
        trendImage.tintColor = expense > income ? .red : .green
        totalAmountLabel.text = currencyString(income - expense)
        incomeAmountLabel.text = currencyString(income)
        expenseAmountLabel.text = currencyString(expense)
    }
    
    public func setSelectedSegmentIndex(_ index: Int) {
        segmentedControl.selectedSegmentIndex = index
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedType: TransactionTypeViewModel = sender.selectedSegmentIndex == 0 ? .income : .expense
        delegate?.segmentedControlValueChanged(to: selectedType)
    }
    
    // MARK: - Helpers
    private func setupView() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        contentView.addSubview(containerView)
        containerView.addSubview(topSumTrendStackView)
        containerView.addSubview(segmentedControl)
        
        let incomeStack = configureStackView(imageName: "arrow.down", addSubview: incomeAmountLabel, category: .income, color: .green)
        incomeStack.translatesAutoresizingMaskIntoConstraints = false
        let expenseStack = configureStackView(imageName: "arrow.up", addSubview: expenseAmountLabel, category: .expense, color: .red)
        expenseStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(incomeStack)
        containerView.addSubview(expenseStack)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            topSumTrendStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            topSumTrendStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            incomeStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            incomeStack.topAnchor.constraint(equalTo: topSumTrendStackView.bottomAnchor, constant: 20),
            
            expenseStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            expenseStack.topAnchor.constraint(equalTo: topSumTrendStackView.bottomAnchor, constant: 20),
            
            segmentedControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            segmentedControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    
    private func configureStackView(imageName: String, addSubview: UIView, category: TransactionType, color: UIColor) -> UIStackView {
        let circleStackView = createCircleStackView(color: color, imageName: imageName)
        
        let categoryLabel = UILabel()
        categoryLabel.text = category.rawValue.description.capitalized
        categoryLabel.tintColor = .secondaryLabel
        categoryLabel.font = .systemFont(ofSize: 11)
        
        let vStack = UIStackView(arrangedSubviews: [categoryLabel, addSubview])
        vStack.axis = .vertical
        vStack.spacing = 1
        
        let hStack = UIStackView(arrangedSubviews: [circleStackView, vStack])
        hStack.axis = .horizontal
        hStack.spacing = 7
        
        return hStack
    }
    
    private func createCircleStackView(color: UIColor, imageName: String) -> UIStackView {
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.layer.cornerRadius = 20
        circleView.clipsToBounds = true
        circleView.backgroundColor = color
        circleView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor).isActive = true
        circleView.applyShadow(opacity: 0.3)
        
        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: imageName)
        arrowImage.tintColor = .white
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        
        circleView.addSubview(arrowImage)
        NSLayoutConstraint.activate([
            arrowImage.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            arrowImage.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [circleView])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
