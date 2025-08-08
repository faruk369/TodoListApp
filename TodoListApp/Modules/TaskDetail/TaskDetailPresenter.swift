//
//  TaskDetailPresenter.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//

import Foundation

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

//    func didTapSave(title: String, description: String) {
//        guard !title.isEmpty else { return }
//        
//        if let existingTask = task {
//            existingTask.name = title
//            existingTask.descriptionText = description
//            existingTask.isEditedLocally = true
//            interactor?.updateExistingTask(from: existingTask)
//            delegate?.taskWasUpdated(existingTask)
//        } else {
//            interactor?.createTask(title: title, description: description)
//        }
//        router?.dismiss(view: view)
//    }
    func didTapSave(title: String, description: String) {
        guard !title.isEmpty else { return }
        
        if let existingTask = task {
            // Update existing task
            existingTask.name = title
            existingTask.descriptionText = description
            existingTask.isEditedLocally = true
            interactor?.updateExistingTask(from: existingTask)
            delegate?.taskWasUpdated(existingTask)
        } else {
            // Create new task
            interactor?.createTask(title: title, description: description)
            
            // Create temporary task object for UI update
            let newTask = TaskObject(context: CoreDataStack.shared.context)
            newTask.id = Int64(Date().timeIntervalSince1970)
            newTask.name = title
            newTask.descriptionText = description
            newTask.isCompleted = false
            newTask.dateCreated = Date()
            newTask.isEditedLocally = true
            
            // Notify delegate immediately
            delegate?.taskWasCreated(newTask)

        }
        
        router?.dismiss(view: view)
    }
    
    func handleViewWillDisappear() {
            guard let task = task else { return }
            delegate?.taskWasUpdated(task)
        }
}
