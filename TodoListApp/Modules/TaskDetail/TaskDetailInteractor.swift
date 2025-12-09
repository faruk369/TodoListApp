//
//  TaskDetailInteractor.swift
//  TodoListApp
//

//

import UIKit
import CoreData

class TaskDetailInteractor: TaskDetailInteractorInputProtocol {
    
    func updateExistingTask(from entity: TaskObject) {
        // Use the main context to save
        let context = CoreDataStack.shared.context
        
        do {
            // Check if the entity is in the context
            if entity.managedObjectContext == context {
                try context.save()
            } else {
                print("Entity is not in the main context")
                // Try to fetch and update
                let fetchRequest: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", entity.id)
                
                if let existingTask = try context.fetch(fetchRequest).first {
                    existingTask.name = entity.name
                    existingTask.descriptionText = entity.descriptionText
                    existingTask.isCompleted = entity.isCompleted
                    try context.save()
                }
            }
        } catch {
            print("Failed to save updated task: \(error)")
        }
    }
    
    func createTask(title: String, description: String) {
        // Use the main context for consistency
        let context = CoreDataStack.shared.context
        let newTask = TaskObject(context: context)
        newTask.id = Int64(Date().timeIntervalSince1970)
        newTask.name = title
        newTask.descriptionText = description
        newTask.isCompleted = false
        newTask.dateCreated = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save new task: \(error)")
        }
    }
}
