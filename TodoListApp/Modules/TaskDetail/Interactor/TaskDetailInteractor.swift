//
//  TaskDetailInteractor.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//

import UIKit
import CoreData

class TaskDetailInteractor: TaskDetailInteractorInputProtocol {
    weak var presenter: TaskDetailInteractorOutputProtocol?
    
    func updateExistingTask(from entity: TaskObject) {
        let context = CoreDataStack.shared.context

        // Fetch the existing task from Core Data by ID
        let fetchRequest: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", entity.id)

        do {
            if let existingObject = try context.fetch(fetchRequest).first {
                existingObject.name = entity.name
                existingObject.descriptionText = entity.descriptionText
                existingObject.isCompleted = entity.isCompleted
                existingObject.dateCreated = entity.dateCreated

                try context.save()
            }
        } catch {
            print("Failed to update Core Data task: \(error)")
        }
    }

        func createTask(title: String, description: String) {
            let context = CoreDataStack.shared.context

            let newTask = TaskObject(context: context)
            newTask.name = title
            newTask.descriptionText = description
            newTask.dateCreated = Date()

            do {
                try context.save()
            } catch {
                print("Failed to create task: \(error)")
            }
        }
}

