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
   
    func fetchTasks()
    func didSelectTask(_ task: TaskObject)
    func didLongPressEdit(at indexPath: IndexPath)
    func didLongPressDelete(at indexPath: IndexPath)
    func didTapAddNewTask()
    func taskWasUpdated(_ task: TaskObject)
}

protocol TaskListViewProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func displayTasks(_ tasks: [TaskObject])
    func updateTask(_ task: TaskObject, at index: Int)
    func insertTask(_ task: TaskObject, at index: Int)
}

protocol TaskListInteractorInputProtocol: AnyObject {
    var presenter: TaskListInteractorOutputProtocol? { get set }
    
    func fetchLocalTasks() -> [TaskObject]
    func fetchTasks()
    func updateExistingTask(from entity: TaskObject)
    func deleteTask(_ task: TaskObject)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [TaskObject])
    
}

protocol TaskListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToDetail(from view: TaskListViewProtocol, with task: TaskObject?)
    func presentCreateTask(from: TaskListViewProtocol)
}

protocol TaskDetailToTaskListDelegate: AnyObject {
    func taskWasUpdated(_ task: TaskObject)
    func taskWasCreated(_ task: TaskObject)
}
