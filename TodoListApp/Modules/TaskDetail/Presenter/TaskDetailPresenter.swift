//
//  TaskDetailPresenter.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//

class TaskDetailPresenter: TaskDetailPresenterProtocol {
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorInputProtocol?
    var router: TaskDetailRouterProtocol?
    var task: TaskEntity?

    func viewDidLoad() {
        if let task = task {
            view?.showTaskDetails(task)
        }
    }
}
