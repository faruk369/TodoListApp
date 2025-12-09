//
//  TaskDetailRouter.swift
//  TodoListApp
//
//

import UIKit

class TaskDetailRouter: TaskDetailRouterProtocol {
    static func createModule(with task: TaskObject?) -> UIViewController {
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

    func dismiss(view: TaskDetailViewProtocol?) {
        if let vc = view as? UIViewController {
            vc.navigationController?.popViewController(animated: true)
        }
    }
}
