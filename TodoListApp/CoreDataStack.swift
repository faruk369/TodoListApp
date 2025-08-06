//
//  CoreDataStack.swift
//  TodoListApp
//
//  Created by Faryk on 05.08.2025.
//

import Foundation
import CoreData

final class CoreDataStack {

    // Singleton
    static let shared = CoreDataStack()

    // Persistent Container
    let persistentContainer: NSPersistentContainer

    // Main Context (use on main thread)
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        // Replace "YourModelName" with your actual .xcdatamodeld filename
        persistentContainer = NSPersistentContainer(name: "CoreData")

        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Core Data load error: \(error), \(error.userInfo)")
            }
        }
    }

    // Optional: Save if there are changes
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved save error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

