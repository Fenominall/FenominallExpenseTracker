//
//  LoadResourcePresentationAdapter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 22.05.2024.
//

import Combine
import FenominallExpenseTracker

final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var presenter: ResourceOperationPresenter<Resource, View>?
    private var isLoading = false
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        guard !isLoading else { return }
        
        presenter?.didStartOperation()
        isLoading = true
        
        cancellable = loader()
            // Evrything down will be dispatched on the main queue regardless of what happening in the upstrem
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
