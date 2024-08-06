//
//  SearchUIComposer.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 05.06.2024.
//

import UIKit
import Combine
import FenominallExpenseTrackeriOS
import FenominallExpenseTracker

public final class SearchUIComposer {
    private init() {}
    
    private typealias SearchPresentationAdapter = SearchResourcePresentationAdapter<[Transaction], SearchViewAdapter>
    
    public static func searchComposedWith(
        searchHandler: @escaping (String, FilterOption?) -> AnyPublisher<[Transaction], Error>,
        selection: @escaping (Transaction) -> Void) -> SearchViewController {
            let presentationAdapter = SearchPresentationAdapter(searcher: searchHandler)
            let searchController = SearchViewController()
            searchController.searchHandler = presentationAdapter.searchResource
            
            presentationAdapter.presenter = ResourceOperationPresenter(
                resourceView: SearchViewAdapter(
                    controller: searchController,
                    selection: selection),
                loadingView: WeakReVirtualProxy(searchController),
                errorView: WeakReVirtualProxy(searchController))
            
            return searchController
        }
}
