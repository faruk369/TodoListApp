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
            case .failure(let error):
                print("API Error: \(error.localizedDescription)")
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
    
    private func syncTasks(_ remoteTasks: [TaskEntity]) {
        let context = CoreDataStack.shared.context
        context.perform {
            // Get existing tasks
            let localTasks = self.fetchLocalTasks()
            let localTaskDict = Dictionary(uniqueKeysWithValues: localTasks.map { (Int($0.id), $0) })
            
            // Process API todos
            for remoteTask in remoteTasks {
                let taskId = remoteTask.id
                
                if let existingTask = localTaskDict[taskId] {
                    // Only update if not locally modified
                    if !existingTask.isEditedLocally {
                        existingTask.name = remoteTask.name
                        existingTask.isCompleted = remoteTask.isCompleted
                    }
                } else {
                    // Create new task
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
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(self.fetchLocalTasks())
                }
            } catch {
                print("Sync failed: \(error)")
            }
        }
    }
    
    func createTask(title: String, description: String) {
        let context = CoreDataStack.shared.context
        let newTask = TaskObject(context: context)
        newTask.name = title
        newTask.descriptionText = description
        newTask.isCompleted = false
        newTask.dateCreated = Date()
        newTask.id = Int64(Date().timeIntervalSince1970) // Unique ID

        do {
            try context.save()
            presenter?.didUpdateTask(newTask)
        } catch {
            print("Failed to save new task: \(error)")
        }
    }

    func updateExistingTask(_ task: TaskObject) {
        let context = CoreDataStack.shared.context
        do {
            try context.save()
            presenter?.didUpdateTask(task)
        } catch {
            print("Failed to update task: \(error)")
        }
    }

    func updateTaskCompletion(_ task: TaskObject) {
        task.isCompleted.toggle()
        updateExistingTask(task)
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
   
   






   
