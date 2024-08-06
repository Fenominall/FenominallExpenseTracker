//
//  SaveResourcePresentationAdapter.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 22.06.2024.
//

import Combine
import Foundation
import FenominallExpenseTracker

final class SaveResourcePresentationAdapter<Resource, PublisherResource, View: ResourceView> where PublisherResource == View.ResourceViewModel {
    private let saver: (Resource) -> AnyPublisher<PublisherResource, Error>
    private var cancellable: Cancellable?
    var presenter: ResourceOperationPresenter<PublisherResource, View>?
    private var isLoading = false
    
    init(saver: @escaping (Resource) -> AnyPublisher<PublisherResource, Error>) {
        self.saver = saver
    }
    
    func saveResource(with category: Resource) {
        guard !isLoading else { return }
        
        presenter?.didStartOperation()
        isLoading = true
        
        cancellable = saver(category)
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        self?.presenter?.didFinishOperation(with: error)
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] resource in
                    self?.presenter?.didFinishOperation(with: resource)
                }
            )
    }
}
