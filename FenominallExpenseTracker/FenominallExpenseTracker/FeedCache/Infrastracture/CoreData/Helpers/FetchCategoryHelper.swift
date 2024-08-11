//
//  FetchCategoryHelper.swift
//  FenominallExpenseTracker
//
//  Created by Fenominall on 8/10/24.
//

import CoreData

// Helper method to fetch a category by its ID
func fetchCategory(byId id: String, from context: NSManagedObjectContext) -> ManagedTransactionCategory? {
    let fetchRequest: NSFetchRequest<ManagedTransactionCategory> = NSFetchRequest(entityName: "ManagedTransactionCategory")
    fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedTransactionCategory.id), id)
    
    do {
        let categories = try context.fetch(fetchRequest)
        return categories.first
    } catch {
        print("Failed to fetch category: \(error)")
        return nil
    }
}
