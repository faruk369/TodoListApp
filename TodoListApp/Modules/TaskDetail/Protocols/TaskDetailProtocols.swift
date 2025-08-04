//
//  TaskDetailProtocols.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//

import UIKit

protocol TaskDetailViewProtocol: AnyObject {
    var presenter: TaskDetailPresenterProtocol? { get set }
    func showTaskDetails(_ task: TaskEntity)
}

protocol TaskDetailPresenterProtocol: AnyObject {
    var view: TaskDetailViewProtocol? { get set }
    var interactor: TaskDetailInteractorInputProtocol? { get set }
    var router: TaskDetailRouterProtocol? { get set }
    var task: TaskEntity? { get set }

    func viewDidLoad()
}

protocol TaskDetailInteractorInputProtocol: AnyObject {
    
}

protocol TaskDetailRouterProtocol: AnyObject {
    static func createModule(with task: TaskEntity) -> UIViewController
}
