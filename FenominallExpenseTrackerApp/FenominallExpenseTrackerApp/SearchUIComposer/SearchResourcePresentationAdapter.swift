//
//  SearchResourcePresentationAdapter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 06.06.2024.
//

import Foundation
import Combine
import FenominallExpenseTracker

final class SearchResourcePresentationAdapter<Resource, View: ResourceView> {
    private let searcher: (String, FilterOption?) -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var presenter: ResourceOperationPresenter<Resource, View>?
    private var isLoading = false
    
    init(searcher: @escaping (String, FilterOption?) -> AnyPublisher<Resource, Error>) {
        self.searcher = searcher
    }
    
    func searchResource(_ withArgument: String, filterOption: FilterOption?) {
        guard !isLoading else { return }
        
        presenter?.didStartOperation()
        isLoading = true
        
        cancellable = searcher(withArgument, filterOption)
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishOperation(with: error)
                    }
                    self?.isLoading = false
                }, receiveValue: { [weak self] resource in
                    self?.presenter?.didFinishOperation(with: resource)
                })
    }
}
