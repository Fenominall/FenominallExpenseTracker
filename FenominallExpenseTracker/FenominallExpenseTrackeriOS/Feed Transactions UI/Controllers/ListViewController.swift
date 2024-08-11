//
//  ListViewController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 01.05.2024.
//

import UIKit
import FenominallExpenseTracker

public final class ListViewController: UITableViewController, ResourceLoadingView, ResourceErrorView{
    // MARK: - Properties
    public var tableModel = [TransactionCellController]() {
        didSet { applyFilter() }}
    public let cardHeaderView = CardViewHeader()
    private var filteredTransactions = [TransactionCellController]()
    private var groupedTransactions = [(date: String, transactions: [TransactionCellController])]()
    private var selectedFilter: TransactionTypeViewModel = .income
    public var onRefresh: (() -> Void)?
    public var addNewTransaction: (() -> Void)?
    public var searchTransaction: (() -> Void)?
    
    // MARK: - LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setDarkModeSupportForTheBackButton()
        setupDarkModeForBackButton()
        refresh()
    }
    
    private func setupDarkModeForBackButton() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = .label
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureRefreshControl()
        setNavigationSettings()
    }
    
    // MARK: - Actions
    @objc private func refresh() {
        onRefresh?()
    }
    
    @objc private func searchButtonTapped() {
        searchTransaction?()
    }
    
    @objc private func addButtonTapped() {
        addNewTransaction?()
    }
    
    public func display(_ viewModel: FenominallExpenseTracker.ResourceLoadingViewModel) {
        DispatchQueue.mainAsync { [weak self] in
            self?.refreshControl?.update(isRefreshing: viewModel.isLoading)
        }
    }
    
    public func display(_ viewModel: FenominallExpenseTracker.ResourceErrorViewModel) {
        // TODO
    }
    
    // MARK: - UI Setup
    private func setDarkModeSupportForTheBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = title
        backButton.tintColor = .label
        navigationItem.backBarButtonItem = backButton
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        cardHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)
        tableView.tableHeaderView = cardHeaderView
    }
    
    private func setNavigationSettings() {
        navigationItem.setLeftBarButton(
            .init(barButtonSystemItem:
                    .search,
                  target: self,
                  action: #selector(searchButtonTapped)),
            animated: true)
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.setRightBarButton(
            .init(barButtonSystemItem:
                    .add,
                  target: self,
                  action: #selector(addButtonTapped)),
            animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

// MARK: - TableView Functions
extension ListViewController {
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedTransactions.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedTransactions[section].transactions.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = groupedTransactions[indexPath.section].transactions[indexPath.row]
        return transaction.view()
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTransactions = groupedTransactions[section].transactions
        let date = groupedTransactions[section].date
        let totalAmount = SectionHeaderCalculator.calculateTotalAmount(for: sectionTransactions)
        
        let sectionHeaderView = SectionHeaderView()
        sectionHeaderView.configure(withTotalAmount: totalAmount, date: date, type: selectedFilter)
        return sectionHeaderView
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = groupedTransactions[indexPath.section].transactions[indexPath.row]
        transaction.selection()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            tableView.performBatchUpdates({
                self.deleteTransaction(at: indexPath)
                self.deleteSectionIfEmpty(at: indexPath)
            }, completion: { success in
                if success {
                    tableView.reloadData()
                }
                completionHandler(success)
            })
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    // MARK: - Helpers
    private func cellController(forRowAt indexPath: IndexPath) -> TransactionCellController {
        return groupedTransactions[indexPath.section].transactions[indexPath.row]
    }
    
    private func deleteTransaction(at indexPath: IndexPath) {
        let cellController = groupedTransactions[indexPath.section].transactions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        cellController.deleteHandler()
    }
    
    private func deleteSectionIfEmpty(at indexPath: IndexPath) {
        if groupedTransactions[indexPath.section].transactions.isEmpty {
            groupedTransactions.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
    
    private func applyFilter() {
        filteredTransactions = tableModel.filter { $0.transactionType.rawValue == selectedFilter.rawValue }.reversed()
        filteredTransactions.sort { $0.transactionDate > $1.transactionDate }
        groupedTransactions = SectionHeaderCalculator.groupTransactionsByDate(filteredTransactions)
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

extension ListViewController: CardViewHeaderDelegate {
    public func segmentedControlValueChanged(to type: TransactionTypeViewModel) {
        selectedFilter = type
        applyFilter()
    }
}
