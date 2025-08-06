//
//  TaskDetailProtocols.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//

import UIKit

protocol TaskDetailViewProtocol: AnyObject {
    var presenter: TaskDetailPresenterProtocol? { get set }
    func showTaskDetails(_ task: TaskObject)
//    func showTaskDetails(_ tasks: [TaskObject])
}

protocol TaskDetailPresenterProtocol: AnyObject {
    var view: TaskDetailViewProtocol? { get set }
    var interactor: TaskDetailInteractorInputProtocol? { get set }
    var router: TaskDetailRouterProtocol? { get set }
    var task: TaskObject? { get set }

    func viewDidLoad()
    func didTapSave(title: String, description: String)
}

protocol TaskDetailInteractorInputProtocol: AnyObject {
    func createTask(title: String, description: String)
//func updateExistingTask(from entity: TaskObject)
//    func updateExistingTask(_ task: TaskObject, title: String, description: String)
    func updateExistingTask(from entity: TaskObject)
    
    
}

protocol TaskDetailInteractorOutputProtocol: AnyObject{
    func didCreateOrUpdateTask(_ task: TaskObject)
}

protocol TaskDetailRouterProtocol: AnyObject {
    static func createModule(with task: TaskObject?) -> UIViewController
    func dismiss(view: TaskDetailViewProtocol?)
}

protocol TaskDetailViewToListDelegate: AnyObject {
    func refreshCellAfterEdit(_ updatedTask: TaskObject)
}
