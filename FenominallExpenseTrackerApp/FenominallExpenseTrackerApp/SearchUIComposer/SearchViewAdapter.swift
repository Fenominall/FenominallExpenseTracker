//
//  SearchViewAdapter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 06.06.2024.
//

import Foundation
import FenominallExpenseTracker
import FenominallExpenseTrackeriOS

final class SearchViewAdapter: ResourceView {
    private weak var controller: SearchViewController?
    private let selection: (Transaction) -> Void
    
    init(controller: SearchViewController,
         selection: @escaping (Transaction) -> Void
    ) {
        self.controller = controller
        self.selection = selection
    }
    
    func display(_ viewModel: [Transaction]) {
        controller?.searchResults = viewModel.map { model in
            TransactionCellController(
                viewModel: TransactionViewModel(model: model),
                selection: {
                    self.selection(model)
                },
                deleteHandler: {})
        }
    }
}
