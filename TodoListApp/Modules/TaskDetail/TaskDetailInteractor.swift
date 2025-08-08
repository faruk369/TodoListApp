//
//  TaskDetailInteractor.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//

import UIKit
import CoreData

class TaskDetailInteractor: TaskDetailInteractorInputProtocol {
    
    func updateExistingTask(from entity: TaskObject) {
        CoreDataStack.shared.saveContext()
    }
    
    func createTask(title: String, description: String) {
        let context = CoreDataStack.shared.context
        let newTask = TaskObject(context: context)
        newTask.id = Int64(Date().timeIntervalSince1970)
        newTask.name = title
        newTask.descriptionText = description
        newTask.isCompleted = false
        newTask.dateCreated = Date()
        newTask.isEditedLocally = true
        
        CoreDataStack.shared.saveContext()
    }
}

