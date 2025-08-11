//
//  TaskListInteractor.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//

import Foundation
import CoreData

class TaskListInteractor: TaskListInteractorInputProtocol {
    weak var presenter: TaskListInteractorOutputProtocol?
    
    func fetchTasks() {
        // First fetch from CoreData
        let localTasks = fetchLocalTasks()
        presenter?.didFetchTasks(localTasks)
        
        // Then fetch from API
        APIManager.shared.fetchTasks { [weak self] result in
            switch result {
            case .success(_):
                self?.fetchTasks()
            case .failure:
                // Don't show error if we have local tasks
                break
            }
        }
    }
    
     func fetchLocalTasks() -> [TaskObject] {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    private func removeDuplicates() {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
        
        do {
            let allTasks = try context.fetch(request)
            var uniqueTasks = [Int64: TaskObject]()
            
            for task in allTasks {
                if let existing = uniqueTasks[task.id] {
                    context.delete(task) // Delete duplicate
                } else {
                    uniqueTasks[task.id] = task
                }
            }
            
            if allTasks.count != uniqueTasks.count {
                try context.save()
            }
        } catch {
            print("Duplicate removal failed: \(error)")
        }
    }

    
    // Update syncTasks method to prevent duplicates
    private func syncTasks(_ remoteTasks: [TaskEntity]) {
 
    }

    func updateExistingTask(from entity: TaskObject) {
        CoreDataStack.shared.saveContext()
    }
    
    func deleteTask(_ task: TaskObject) {
        let context = CoreDataStack.shared.context
        context.delete(task)

        do {
            try context.save()
            let fetchRequest: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
            let tasks = try context.fetch(fetchRequest)
            presenter?.didFetchTasks(tasks)
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}
   
   






   
