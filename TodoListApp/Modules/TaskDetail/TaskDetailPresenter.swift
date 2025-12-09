//
//  TaskDetailPresenter.swift
//  TodoListApp
//
//

import Foundation
import CoreData

class TaskDetailPresenter: TaskDetailPresenterProtocol {
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorInputProtocol?
    var router: TaskDetailRouterProtocol?
    var task: TaskObject?
    weak var delegate: TaskDetailToTaskListDelegate?
    
    func viewDidLoad() {
        if let task = task {
            view?.showTaskDetails(task)
        }
    }
    
    func didTapSave(title: String, description: String) {
        guard !title.isEmpty else { return }
        
        let context = CoreDataStack.shared.context
        
        if let existingTask = task {
            // Update existing task
            existingTask.name = title
            existingTask.descriptionText = description
            
            interactor?.updateExistingTask(from: existingTask)
            delegate?.taskWasUpdated(existingTask)
        } else {
            // Create new task in the same context
            let newTask = TaskObject(context: context)
            newTask.id = Int64(Date().timeIntervalSince1970)
            newTask.name = title
            newTask.descriptionText = description
            newTask.isCompleted = false
            newTask.dateCreated = Date()
            
            do {
                try context.save()
                print("Task created successfully with ID: \(newTask.id)")
                delegate?.taskWasCreated(newTask)
            } catch {
                print("Failed to save new task: \(error)")
            }
        }
        
        router?.dismiss(view: view)
    }
    
    func handleViewWillDisappear() {
        guard let task = task else { return }
        delegate?.taskWasUpdated(task)
    }
}
