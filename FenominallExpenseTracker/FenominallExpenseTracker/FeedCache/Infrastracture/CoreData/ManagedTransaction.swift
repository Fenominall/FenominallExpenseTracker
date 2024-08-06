//
//  ManagedTransaction+CoreDataProperties.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 28.04.2024.
//
//

import Foundation
import CoreData

@objc(ManagedTransaction)
public class ManagedTransaction: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var remarks: String?
    @NSManaged public var amount: Double
    @NSManaged public var dateAdded: Date
    @NSManaged public var type: String
    @NSManaged public var transactionCategory: ManagedTransactionCategory?
    @NSManaged public var feed: ManagedCache
}

extension ManagedTransaction {
    var local: LocalTransaction? {
        // Check if `transactionCategory` is nil and handle it gracefully
        guard let transactionCategory = transactionCategory else {
            return nil
        }
        
        return LocalTransaction(
            id: id,
            title: title,
            remarks: remarks ?? "",
            amount: amount,
            dateAdded: dateAdded,
            type: LocalTransactionType(rawValue: self.type) ?? .expense,
            category: transactionCategory.local
        )
    }
    
    static func first(
        with localTransaction: LocalTransaction,
        in context: NSManagedObjectContext
    ) throws -> ManagedTransaction? {
        let request = NSFetchRequest<ManagedTransaction>(
            entityName: ManagedTransaction.entity().name!
        )
        
        // Predicate for matching UUID
        let uuidPredicate = NSPredicate(
            format: "%K == %@",
            #keyPath(ManagedTransaction.id),
            localTransaction.id as CVarArg
        )
        request.predicate = uuidPredicate
        
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }
    
    static func transactions(
        from localTransaction: LocalTransaction,
        in context: NSManagedObjectContext
    ) -> NSOrderedSet {
        let managed = ManagedTransaction(context: context)
        managed.id = localTransaction.id
        managed.title = localTransaction.title
        managed.remarks = localTransaction.remarks
        managed.amount = localTransaction.amount
        managed.dateAdded = localTransaction.dateAdded
        managed.type = localTransaction.transactionTypeRawValue
        let category = ManagedTransactionCategory(context: context)
        category.id = localTransaction.category.id
        category.name = localTransaction.category.name
        category.type = localTransaction.category.transactionType.rawValue
        category.hexColor = localTransaction.category.hexColor
        category.imageData = localTransaction.category.imageData
        managed.transactionCategory = category
        
        return NSOrderedSet(object: managed)
    }
}

extension ManagedTransaction {
    static func fetchTransactions(
        with argument: String,
        filterOption: FilterOption?,
        in context: NSManagedObjectContext
    ) throws -> [LocalTransaction] {
        let request: NSFetchRequest<ManagedTransaction> = fetchRequest()
        request.predicate = createPredicate(
            with: argument,
            filterOption: filterOption
        )
        
        let results = try context.fetch(request)
        return results.compactMap { $0.local }
    }
    
    private static func fetchRequest() -> NSFetchRequest<ManagedTransaction> {
        return NSFetchRequest<ManagedTransaction>(entityName: "ManagedTransaction")
    }
    
    private static func createPredicate(
        with argument: String,
        filterOption: FilterOption?
    ) -> NSPredicate? {
        var predicates: [NSPredicate] = []
        
        if !argument.isEmpty {
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", argument)
            if let amount = Double(argument) {
                let amountPredicate = NSPredicate(format: "amount == %f", amount)
                predicates.append(
                    NSCompoundPredicate(
                        orPredicateWithSubpredicates: [titlePredicate, amountPredicate]
                    )
                )
            } else {
                predicates.append(titlePredicate)
            }
        }
        
        if let filterOption = filterOption, filterOption != .all {
            let dateRange = filterOption.dateRange()
            if let startDate = dateRange.startDate, let endDate = dateRange.endDate {
                let datePredicate = NSPredicate(
                    format: "(dateAdded >= %@) AND (dateAdded <= %@)",
                    startDate as NSDate,
                    endDate as NSDate
                )
                predicates.append(datePredicate)
            }
        }
        
        return predicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}
