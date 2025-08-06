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
    var task: TaskObject?
    

    func viewDidLoad() {
        if let task = task {
            view?.showTaskDetails(task)
        }
    }

    func didTapSave(title: String, description: String) {
        guard !title.isEmpty else { return }

        if let existingTask = task {
            existingTask.name = title
            existingTask.descriptionText = description.isEmpty ? "No description" : description
            interactor?.updateExistingTask(from: existingTask)
        } else {
            interactor?.createTask(title: title, description: description)
        }

        router?.dismiss(view: view)
    }
}
