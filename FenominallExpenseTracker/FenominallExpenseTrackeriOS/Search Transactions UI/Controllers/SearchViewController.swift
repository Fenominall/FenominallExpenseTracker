//
//  SearchViewController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 21.05.2024.
//

import UIKit
import Combine
import FenominallExpenseTracker

public final class SearchViewController: UIViewController {
    
    public var selectedFilter: FilterOption = .all {
        didSet { refreshSearchResults() }
    }
    public var searchHandler: ((String, FilterOption?) -> Void)?
    public var searchResults = [TransactionCellController]() {
        didSet {
            DispatchQueue.mainAsync {
                self.tableView.reloadData()
                self.nothingFoundLabel.isHidden = !self.searchResults.isEmpty
            }
        }
    }
    
    private lazy var nothingFoundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.isHidden = true
        label.text = "Nothing was found!"
        label.textAlignment = .center
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.global(qos: .background).async {
            let localizedPlaceholder = NSLocalizedString(
                "Search transactions...",
                comment: "Search bar placeholder")
            DispatchQueue.main.async {
                searchBar.placeholder = localizedPlaceholder
            }
        }
        searchBar.customizeAppearance()
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupSearchHandling()
        
        tableView.separatorStyle = .none
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        let filterImage = UIImage(systemName: "line.3.horizontal.decrease.circle")
        let filterButton = UIBarButtonItem(
            image: filterImage,
            style: .plain,
            target: self,
            action: #selector(showFilterOptions)
        )
        filterButton.tintColor = .black
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(nothingFoundLabel)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nothingFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showFilterOptions() {
        let alert = UIAlertController(title: "Filter Options", message: nil, preferredStyle: .actionSheet)
        
        for option in FilterOption.allCases {
            let action = UIAlertAction(title: option.rawValue, style: .default) { [weak self] _ in
                self?.setFilter(option)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setFilter(_ filter: FilterOption) {
        selectedFilter = filter
        refreshSearchResults()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    private func setupSearchHandling() {
        searchBar.searchTextField.addTarget(
            self,
            action: #selector(textDidChange(_:)),
            for: .editingChanged
        )
    }
    
    private func refreshSearchResults() {
        guard let query = searchBar.text else { return }
        
        if query.isEmpty {
            searchResults = []
            nothingFoundLabel.isHidden = true
            return
        }
        let filterToApply: FilterOption? = selectedFilter != .all ? selectedFilter : nil
        searchHandler?(query, filterToApply)
    }
    
    @objc private func textDidChange(_ textField: UISearchTextField) {
        refreshSearchResults()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellController = searchResults[indexPath.row]
        return cellController.view()
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = searchResults[indexPath.row]
        transaction.selection()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceLoadingViewModel) {
        loadingIndicator.update(isAnimating: viewModel.isLoading)
    }
    
    public func display(_ viewModel: FenominallExpenseTracker.ResourceErrorViewModel) {
        // Handle error display
    }
}
