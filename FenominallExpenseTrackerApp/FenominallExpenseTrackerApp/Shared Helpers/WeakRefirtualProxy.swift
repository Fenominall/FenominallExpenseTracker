//
//  WeakRefirtualProxy.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 22.05.2024.
//

import FenominallExpenseTracker

final class WeakReVirtualProxy<T: AnyObject> {
    
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakReVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: FenominallExpenseTracker.ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakReVirtualProxy: ResourceErrorView where T: ResourceErrorView {
    func display(_ viewModel: FenominallExpenseTracker.ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}

