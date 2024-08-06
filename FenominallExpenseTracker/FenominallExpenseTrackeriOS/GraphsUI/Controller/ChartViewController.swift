//
//  ChartViewController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 03.06.2024.
//

import UIKit
import SwiftUI
import FenominallExpenseTracker

public final class ChartViewController: UIViewController {
    
    public var onRefresh: (() -> Void)?
    public var viewModel: ChartTransactionsViewModel
    
    private lazy var chartRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    public init(viewModel: ChartTransactionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        onRefresh?()
    }
    
    @objc private func refresh() {
        onRefresh?()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let graphsView = Graphs(viewModel: self.viewModel)
        
        let hostingController = UIHostingController(rootView: graphsView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ChartViewController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceLoadingViewModel) {
        DispatchQueue.mainAsync { [weak self] in
            self?.chartRefreshControl.update(isRefreshing: viewModel.isLoading)
        }
    }
    
    public func display(_ viewModel: FenominallExpenseTracker.ResourceErrorViewModel) {
        // Implement error view update
    }
}
