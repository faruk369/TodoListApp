//
//  TaskListPresenter.swift
//  TodoListApp
//
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
    
    func toggleTaskCompletion(at indexPath: IndexPath) {
        guard indexPath.row < tasks.count else { return }
        
        // Get the task and toggle completion
        let task = tasks[indexPath.row]
        task.isCompleted.toggle()
        
        print("Toggling task \(task.id) to isCompleted: \(task.isCompleted)")
        
        // Update in CoreData
        interactor?.updateExistingTask(from: task)
        
        // Update the task in our local array
        tasks[indexPath.row] = task
        
        // Notify view to update UI
        view?.updateTask(task, at: indexPath)
    }
    
    func didSelectTask(_ task: TaskObject) {
        router?.navigateToDetail(from: view!, with: task)
    }
    
    func didTapAddNewTask() {
        router?.presentCreateTask(from: view! as! TaskListViewController)
    }
    
    func didLongPressEdit(at indexPath: IndexPath) {
        guard indexPath.row < tasks.count else { return }
        let task = tasks[indexPath.row]
        guard let view = view else { return }
        router?.navigateToDetail(from: view, with: task)
    }
    
    func didLongPressDelete(at indexPath: IndexPath) {
        guard indexPath.row < tasks.count else { return }
        let task = tasks[indexPath.row]
        interactor?.deleteTask(task)
    }
    
    func taskWasUpdated(_ task: TaskObject) {
        // Find and update the task
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            let indexPath = IndexPath(row: index, section: 0)
            view?.updateTask(task, at: indexPath)
        }
    }
    
    func taskWasCreated(_ task: TaskObject) {
        // Insert at the beginning
        tasks.insert(task, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        view?.insertTask(task, at: indexPath)
    }
}
