//
//  TaskListRouter.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//
import UIKit

class TaskListRouter: TaskListRouterProtocol {
    static func createModule() -> UIViewController {
        let view = TaskListViewController()
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        let presenter = TaskListPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        presenter.interactor = interactor
            presenter.router = router
        
        return view
    }
    func navigateToDetail(from view: TaskListViewProtocol, with task: TaskEntity) {
            let detailVC = TaskDetailRouter.createModule(with: task)
            if let sourceVC = view as? UIViewController {
                sourceVC.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
}


