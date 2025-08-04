//
//  TaskListPresenter.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//
import UIKit

class TaskListPresenter: TaskListPresenterProtocol, TaskListInteractorOutputProtocol {

    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorInputProtocol?
    var router: TaskListRouterProtocol?

    var tasks: [TaskEntity] = []

    init(view: TaskListViewProtocol, interactor: TaskListInteractorInputProtocol, router: TaskListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        fetchTasks()
    }

    func fetchTasks() {
        interactor?.fetchTasks()
    }

    func toggleTaskCompletion(_ task: TaskEntity) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        interactor?.updateTaskCompletion(updatedTask)
    }

    func didFetchTasks(_ tasks: [TaskEntity]) {
        self.tasks = tasks
        view?.displayTasks(tasks)
    }

    func didUpdateTask(_ task: TaskEntity) {
        tasks = tasks.map { $0.id == task.id ? task : $0 }
        view?.displayTasks(tasks)
    }
    
    func didSelectTask(_ task: TaskEntity) {
        router?.navigateToDetail(from: view!, with: task)
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
