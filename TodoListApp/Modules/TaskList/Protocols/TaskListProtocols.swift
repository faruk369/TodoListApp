//
//  TaskListProtocols.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//

import Foundation
import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorInputProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }

    func viewDidLoad()
    func fetchTasks()
    func toggleTaskCompletion(_ task: TaskEntity)
    func didSelectTask(_ task: TaskEntity)
    func didLongPressEdit(at indexPath: IndexPath)
        func didLongPressDelete(at indexPath: IndexPath)
}

protocol TaskListViewProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func displayTasks(_ tasks: [TaskEntity])
}

protocol TaskListInteractorInputProtocol: AnyObject {
    var presenter: TaskListInteractorOutputProtocol? { get set }
    func fetchTasks()
    func updateTaskCompletion(_ task: TaskEntity)
    func deleteTask(_ task: TaskEntity)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [TaskEntity])
    func didUpdateTask(_ task: TaskEntity)
}

protocol TaskListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToDetail(from view: TaskListViewProtocol, with task: TaskEntity)
}

protocol TaskTableViewCellDelegate: AnyObject {
    func didToggleCompletion(for task: TaskEntity)
}
