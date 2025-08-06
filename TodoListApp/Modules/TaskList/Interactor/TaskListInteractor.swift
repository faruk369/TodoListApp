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
        TaskAPIManager.shared.fetchTasks { [weak self] result in
            switch result {
            case .success(let fetchedTasks):
                let context = CoreDataStack.shared.context

                for entity in fetchedTasks {
                    let task = TaskObject(context: context)
                    task.id = Int64(entity.id)
                    task.name = entity.name
                    task.isCompleted = entity.isCompleted
                    task.dateCreated = Date()
                }

                do {
                    try context.save()
                    let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
                    let tasks = try context.fetch(request)
                    DispatchQueue.main.async {
                        self?.presenter?.didFetchTasks(tasks)
                    }
                } catch {
                    print("Error saving or fetching tasks from Core Data: \(error)")
                }

            case .failure(let error):
                print("Failed to fetch tasks from API: \(error.localizedDescription)")
            }
        }
    }
    func fetchTasksFromDatabase() -> [TaskObject] {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
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





   
