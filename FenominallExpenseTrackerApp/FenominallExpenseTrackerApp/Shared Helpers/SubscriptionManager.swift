//
//  SubscriptionManager.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 30.05.2024.
//

import Combine

public final class SubscriptionManager {
    public  var cancellables = Set<AnyCancellable>()
    
    func store(_ cancellable: AnyCancellable) {
        cancellable.store(in: &cancellables)
    }
}

