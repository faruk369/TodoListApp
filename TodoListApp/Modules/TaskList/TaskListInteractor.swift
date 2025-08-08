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
            case .success(let remoteTasks):
                self?.syncTasks(remoteTasks)
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
        let context = CoreDataStack.shared.context
        context.perform {
            // Remove duplicates first
            self.removeDuplicates()
            
            // Existing sync logic
            let localTasks = self.fetchLocalTasks()
            let localTaskDict = Dictionary(uniqueKeysWithValues: localTasks.map { (Int($0.id), $0) })
            
            for remoteTask in remoteTasks {
                let taskId = remoteTask.id
                
                if let existingTask = localTaskDict[taskId] {
                    if !existingTask.isEditedLocally {
                        existingTask.name = remoteTask.name
                        existingTask.isCompleted = remoteTask.isCompleted
                    }
                } else {
                    let newTask = TaskObject(context: context)
                    newTask.id = Int64(remoteTask.id)
                    newTask.name = remoteTask.name
                    newTask.isCompleted = remoteTask.isCompleted
                    newTask.dateCreated = Date()
                    newTask.isEditedLocally = false
                }
            }
            
            // Save changes
            do {
                try context.save()
                let updatedTasks = self.fetchLocalTasks()
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(updatedTasks)
                }
            } catch {
                print("Sync failed: \(error)")
            }
        }
    }
    
  

    func updateExistingTask(from entity: TaskObject) {
        CoreDataStack.shared.saveContext()
    }

    func updateTaskCompletion(_ task: TaskObject) {
        task.isCompleted.toggle()
//        updateExistingTask(taskob)
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
   
   






   
