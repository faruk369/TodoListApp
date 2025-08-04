//
//  TaskDetailRouter.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//

import UIKit

class TaskDetailRouter: TaskDetailRouterProtocol {
    static func createModule(with task: TaskEntity) -> UIViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter()
        let interactor = TaskDetailInteractor()
        let router = TaskDetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.task = task

        return view
    }
}
