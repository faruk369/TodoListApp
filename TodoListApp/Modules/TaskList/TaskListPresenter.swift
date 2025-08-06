//
//  TaskListPresenter.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//
import UIKit
import CoreData

class TaskListPresenter: TaskListPresenterProtocol, TaskListInteractorOutputProtocol {
    
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorInputProtocol?
    var router: TaskListRouterProtocol?

    var tasks: [TaskObject] = []

    init(view: TaskListViewProtocol, interactor: TaskListInteractorInputProtocol, router: TaskListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }


    func fetchTasks() {
        interactor?.fetchTasks()
    }

    func toggleTaskCompletion(_ task: TaskObject) {
        let updatedTask = task
        updatedTask.isCompleted.toggle()
        interactor?.updateTaskCompletion(updatedTask)
    }

    func loadInitialTasks() {
            if let localTasks = interactor?.fetchLocalTasks(), !localTasks.isEmpty {
                tasks = localTasks
                view?.displayTasks(tasks)
            } else {
                interactor?.fetchTasks()
            }
        }
        
        func didFetchTasks(_ tasks: [TaskObject]) {
            self.tasks = tasks
            view?.displayTasks(tasks)
        }
    
    func didUpdateTask(_ task: TaskObject) {
        tasks = tasks.map { $0.id == task.id ? task : $0 }
        view?.displayTasks(tasks)
        
    }
    
    func didSelectTask(_ task: TaskObject) {
        router?.navigateToDetail(from: view!, with: task)
    }
    
    func didTapAddNewTask() {
        router?.presentCreateTask(from: view! as! TaskListViewController)
    }
    
    // 3d touch
    func didLongPressEdit(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]
            guard let view = view else { return }
            router?.navigateToDetail(from: view, with: task)
    }

    func didLongPressDelete(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        interactor?.deleteTask(task)
    }
   
    
}
