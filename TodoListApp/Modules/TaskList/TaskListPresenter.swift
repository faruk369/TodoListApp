//
//  TaskListPresenter.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//
import UIKit
import CoreData

class TaskListPresenter: TaskListPresenterProtocol, TaskListInteractorOutputProtocol, TaskDetailToTaskListDelegate {
    
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

    func didFetchTasks(_ tasks: [TaskObject]) {
        self.tasks = tasks
        view?.displayTasks(tasks)
    }
    
    func toggleTaskCompletion(_ task: TaskObject) {
        let updatedTask = task
            updatedTask.isCompleted.toggle()
            interactor?.updateExistingTask(from: updatedTask)
            
            // Also update the tasks array immediately so the UI reflects it without refetch
            if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                tasks[index] = updatedTask
                view?.updateTask(updatedTask, at: index)
            }
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
        // Implement delegate methods for the task to cell immediate update
        func taskWasUpdated(_ task: TaskObject) {
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index] = task
                view?.updateTask(task, at: index)
            }
        }
        
        func taskWasCreated(_ task: TaskObject) {
            tasks.insert(task, at: 0)
            view?.insertTask(task, at: 0)
        }
        
    }
