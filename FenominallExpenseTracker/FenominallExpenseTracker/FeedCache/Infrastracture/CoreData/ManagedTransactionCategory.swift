//
//  ManagedTransactionCategory+CoreDataProperties.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 28.04.2024.
//
//

import Foundation
import CoreData

@objc(ManagedTransactionCategory)
public class ManagedTransactionCategory: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var hexColor: String
    @NSManaged public var imageData: String?
    @NSManaged public var type: String
    @NSManaged public var transaction: ManagedTransaction
    
    var local: LocalTransactionCategory {
        LocalTransactionCategory(
            id: id,
            name: name,
            hexColor: hexColor,
            imageData: imageData,
            transactionType: LocalTransactionType(rawValue: type) ?? .expense)
    }
}

extension ManagedTransactionCategory {
    static func saveCategory(_ category: LocalTransactionCategory, in context: NSManagedObjectContext) throws {
        let managedCategory = ManagedTransactionCategory(context: context)
        managedCategory.id = category.id
        managedCategory.name = category.name
        managedCategory.hexColor = category.hexColor
        managedCategory.imageData = category.imageData
        managedCategory.type = category.transactionType.rawValue
    }
}

extension ManagedTransactionCategory {
    static func fetchCategories(in context: NSManagedObjectContext) throws -> [LocalTransactionCategory] {
        let request = NSFetchRequest<ManagedTransactionCategory>(entityName: "ManagedTransactionCategory")
        let managedCategories = try context.fetch(request)
        return managedCategories.map { $0.local }
    }
    
    static func first(with localCategory: LocalTransactionCategory, in context: NSManagedObjectContext) throws -> ManagedTransactionCategory? {
        let request = NSFetchRequest<ManagedTransactionCategory>(entityName: ManagedTransactionCategory.entity().name!)
        let uuidPredicate = NSPredicate(format: "%K == %@", #keyPath(ManagedTransactionCategory.id), localCategory.id as CVarArg)
        request.predicate = uuidPredicate
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}

extension ManagedTransactionCategory {
    static func deleteCategories(
        _ categories: [ManagedTransactionCategory],
        in context: NSManagedObjectContext
    ) throws {
        for category in categories {
            context.delete(category)
        }
        try context.saveIfNeeded()
    }
}

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        if self.hasChanges {
            try self.save()
        }
    }
}
