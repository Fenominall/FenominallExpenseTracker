//
//  ManagedCache+CoreDataProperties.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 28.04.2024.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
public class ManagedCache: NSManagedObject {
    @NSManaged public var cache: NSOrderedSet
}

extension ManagedCache {
    var localTransactionFeed: [LocalTransaction] {
        // Ensure cache is not nil and contains valid objects
        guard let cache = cache.array as? [ManagedTransaction] else {
            return []
        }
        
        return cache.compactMap { $0.local }
    }
    
    static func fetchOrCreateCache(in context: NSManagedObjectContext) throws -> ManagedCache {
        guard let cache = try ManagedCache.find(in: context) else {
            return ManagedCache(context: context)
        }
        return cache
    }
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    func updateCache(with transaction: LocalTransaction, in context: NSManagedObjectContext) throws {
        let existingTransactions = cache.mutableCopy() as? NSMutableOrderedSet ?? NSMutableOrderedSet()
        let newTransactions = ManagedTransaction.transactions(from: transaction, in: context)
        existingTransactions.addObjects(from: newTransactions.array)
        
        if let updatedCache = existingTransactions.copy() as? NSOrderedSet {
            cache = updatedCache
        } else {
            throw CacheError.unableToCreateMutableCopy
        }
    }
}

// Delete Logic
extension ManagedCache {
    static func deleteTransactions(
        _ transactions: [ManagedTransaction],
        in cache: NSOrderedSet,
        _ context: NSManagedObjectContext) throws {
            
            guard let mutableCache = cache.mutableCopy() as? NSMutableOrderedSet else {
                throw CacheError.unableToCreateMutableCopy
            }
            
            findAndDelete(transactions, mutableCache, context)
            
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    
    private static func findAndDelete(
        _ transactions: [ManagedTransaction],
        _ mutableCache: NSMutableOrderedSet,
        _ context: NSManagedObjectContext) {
            
            transactions.forEach { transaction in
                if let index = mutableCache.array.firstIndex(where: {
                    ($0 as? ManagedTransaction)?.objectID == transaction.objectID
                }) {
                    mutableCache.removeObject(at: index)
                    context.delete(transaction)
                }
            }
        }
}

extension ManagedCache {
    static func update(_ transaction: LocalTransaction, context: NSManagedObjectContext) throws {
        guard let managedTransaction = try ManagedTransaction.first(with: transaction, in: context) else {
            throw CacheError.transactionNotFound
        }
        guard managedTransaction.id == transaction.id else {
            throw CacheError.transactionIDMismatch
        }
        
        ManagedTransaction.update(managedTransaction, with: transaction)
        do {
            try context.save()
        } catch {
            throw error
        }
    }
}

private extension ManagedTransaction {
    static func update(_ managedTransaction: ManagedTransaction, with transaction: LocalTransaction) {
        managedTransaction.id = transaction.id
        managedTransaction.title = transaction.title
        managedTransaction.remarks = transaction.remarks
        managedTransaction.amount = transaction.amount
        managedTransaction.dateAdded = transaction.dateAdded
        managedTransaction.type = transaction.transactionTypeRawValue
        managedTransaction.transactionCategory?.name = transaction.category.name
        managedTransaction.transactionCategory?.hexColor = transaction.category.hexColor
        managedTransaction.transactionCategory?.imageData = transaction.category.imageData
    }
}
