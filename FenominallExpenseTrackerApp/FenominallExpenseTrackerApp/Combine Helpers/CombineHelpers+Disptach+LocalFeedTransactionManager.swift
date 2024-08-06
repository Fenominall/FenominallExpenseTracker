//
//  CombineHelpers.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 22.05.2024.
//

import Combine
import Foundation
import FenominallExpenseTracker

public extension LocalFeedTransactionManager {
    typealias LoadPublisher = AnyPublisher<[Transaction], Error>
    typealias SaveCompletionPublisher = AnyPublisher<Void, Error>
    typealias SearchPublisher = AnyPublisher<[Transaction], Error>
    typealias SaveСategoryCompletionPublisher = AnyPublisher<Bool, Error>
    
    func loadPublisher() -> LoadPublisher {
        Deferred {
            Future(self.load)
        }
        .eraseToAnyPublisher()
    }
    
    func savePublisher(transaction: Transaction) -> SaveCompletionPublisher {
        performTask { completion in
            self.save(transaction, completion: completion)
        }
    }
    
    func updatePublisher(transaction: Transaction) -> SaveCompletionPublisher {
        performTask { completion in
            self.update(selected: transaction, completion: completion)
        }
    }
    
    func deletePublisher(transactions: [Transaction]) -> SaveCompletionPublisher {
        performTask { completion in
            self.delete(selected: transactions, completion: completion)
        }
    }
    
    func searchPublisher(_ argument: String, filter: FilterOption?) -> SearchPublisher {
        Deferred {
            Future { promise in
                self.searchAndLoad(with: argument, filterOption: filter, completion: promise)
            }
        }.eraseToAnyPublisher()
    }
    
    private func performTask(
        task: @escaping (@escaping (Result<Void, Error>) -> Void) -> Void
    ) -> AnyPublisher<Void, Error> {
        return Deferred {
            Future<Void, Error> { promise in
                task { result in
                    promise(result)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension LocalTransactionCategoryManager {
    typealias SaveСategoryCompletionPublisher = AnyPublisher<Bool, Error>
    typealias LoadCategoriesPublisher = AnyPublisher<[UserDefinedTransactionCategory], Error>
    
    func saveCategoryPublisher(
        category transactionCategory: TransactionCategory
    ) -> SaveСategoryCompletionPublisher {
        return performTask { completion in
            self.addNewCategory(transactionCategory, completion: completion)
        }
        .map { _ in
            return true
        }
        .eraseToAnyPublisher()
    }
    
    func loadCategoriesPublisher() -> LoadCategoriesPublisher {
        Deferred {
            Future<[UserDefinedTransactionCategory], Error> { promise in
                self.loadCategories(completion: { result in
                    switch result {
                    case .success(let categories):
                        let userDefinedCategories = categories
                            .compactMap { $0 as? UserDefinedTransactionCategory }
                        promise(.success(userDefinedCategories))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                })
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteCategoriesPublisher(_ categories: [TransactionCategory]) -> AnyPublisher<Void, Error> {
        performTask { completion in
            self.delete(selected: categories, completion: completion)
        }
    }
    
    private func performTask(
        task: @escaping (@escaping (Result<Void, Error>) -> Void) -> Void
    ) -> AnyPublisher<Void, Error> {
        return Deferred {
            Future<Void, Error> { promise in
                task { result in
                    promise(result)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Dispatcher
extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        // the receive operator always dispatch asyncronously
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
        ImmediateWhenOnMainQueueScheduler()
    }
    
    struct ImmediateWhenOnMainQueueScheduler: Scheduler {
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        var now: SchedulerTimeType {
            DispatchQueue.main.now
        }
        
        var minimumTolerance: SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }
        
        static let shared = Self()
        
        private static let key = DispatchSpecificKey<UInt8>()
        private static let value = UInt8.max
        
        public init() {
            DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
        }
        
        func schedule(options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) {
            guard Thread.isMainThread else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            action()
        }
        
        func schedule(after date: DispatchQueue.SchedulerTimeType, tolerance: DispatchQueue.SchedulerTimeType.Stride, options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) {
            // When we cannot execute immidiately we can forward the message to the main queue scehduler
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }
        
        func schedule(after date: SchedulerTimeType, interval: DispatchQueue.SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}

typealias AnyDispatchQueueScheduler = AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>

extension AnyDispatchQueueScheduler {
    static var immediateOnMainQueue: Self {
        DispatchQueue.immediateWhenOnMainQueueScheduler.eraseToAnyScheduler()
    }
}

extension Scheduler {
    func eraseToAnyScheduler() -> AnyScheduler<SchedulerTimeType, SchedulerOptions> {
        AnyScheduler(self)
    }
}

struct AnyScheduler<SchedulerTimeType: Strideable, SchedulerOptions>: Scheduler where SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    
    private let _now: () -> SchedulerTimeType
    private let _minimumTolerance: () -> SchedulerTimeType.Stride
    private let _schedule: (SchedulerOptions?,  @escaping () -> Void) -> Void
    private let _scheduleAfter: (SchedulerTimeType,  SchedulerTimeType.Stride, SchedulerOptions?,  @escaping () -> Void) -> Void
    private let _scheduleAfterInternal: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerTimeType.Stride, SchedulerOptions?,  @escaping () -> Void) -> Cancellable
    
    init<S>(_ scheduler: S) where SchedulerTimeType == S.SchedulerTimeType, SchedulerOptions == S.SchedulerOptions, S: Scheduler {
        _now = { scheduler.now }
        _minimumTolerance = { scheduler.minimumTolerance }
        _schedule = scheduler.schedule(options:_:)
        _scheduleAfter = scheduler.schedule(after:tolerance:options:_:)
        _scheduleAfterInternal = scheduler.schedule(after:interval:tolerance:options:_:)
    }
    
    var now: SchedulerTimeType { _now()  }
    
    var minimumTolerance: SchedulerTimeType.Stride { _minimumTolerance() }
    
    func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _schedule(options, action)
    }
    
    func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _scheduleAfter(date, tolerance, options, action )
    }
    
    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> any Cancellable {
        _scheduleAfterInternal(date, interval, tolerance, options, action )
    }
}
