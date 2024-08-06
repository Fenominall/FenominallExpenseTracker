//
//  TransactionsCellController.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 16.05.2024.
//

import UIKit
import FenominallExpenseTracker

public final class TransactionCellController {
    private let viewModel: TransactionViewModel
    private var cell: TransactionTableViewCell?
    private(set) var selection: () -> Void
    private(set) var deleteHandler: () -> Void
    
    public init(viewModel: TransactionViewModel, 
                selection: @escaping () -> Void,
                deleteHandler: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.selection = selection
        self.deleteHandler = deleteHandler
    }
        
    public func view() -> UITableViewCell {
        cell = binded(TransactionTableViewCell())
        return cell!
    }
    
    var title: String {
        viewModel.transactionTitle
    }
    
    var transactionType: TransactionTypeViewModel {
        return viewModel.type
    }
    
    var transactionDate: Date {
        return viewModel.rawDateAdded
    }
    
    var amount: Double {
        viewModel.transactionAmount
    }
    
    private func binded(_ cell: TransactionTableViewCell) -> TransactionTableViewCell {
        cell.setupConstraints()
        cell.sumPriceLabel.text = viewModel.convertedAmount
        cell.sumPriceLabel.textColor =
        viewModel.type == .income ? .systemGreen : .systemRed
        cell.transactionNameLabel.text = viewModel.transactionTitle
        cell.transactionCategoryLabel.text = viewModel.transactionCategoryName
        cell.dateAddedLabel.text =  viewModel.convertedDate
        cell.categoryImageBackgroundView.backgroundColor = UIColor(hex: viewModel.categoryColor)
        AssetsImageLoader.getAssetImage(byName: viewModel.categoryImage, in: cell.categoryImageView)
        return cell
    }
}

extension TransactionCellController: ResourceLoadingView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceLoadingViewModel) {
        cell?.containerView.isShimmering = viewModel.isLoading
    }
}

extension TransactionCellController: ResourceErrorView {
    public func display(_ viewModel: FenominallExpenseTracker.ResourceErrorViewModel) {
        cell?.transactionNameLabel.text = viewModel.message
    }
}
