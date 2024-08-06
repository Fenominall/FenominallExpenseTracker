//
//  CoreDataFeedStore.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 28.04.2024.
//

import Foundation
import CoreData

public final class CoreDataTransactionStore {
    //MARK: - Properties
    public static let storeURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appending(path: "feed-store.sqlite")
    
    private static let modelName = "TransactionStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataTransactionStore.self))
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    //MARK: - Initialisation
    public init(storeURL: URL) throws {
        guard let model = CoreDataTransactionStore.model else {
            throw StoreError.modelNotFound
        }
        do {
            container = try NSPersistentContainer.load(name: CoreDataTransactionStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func performAsync(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
