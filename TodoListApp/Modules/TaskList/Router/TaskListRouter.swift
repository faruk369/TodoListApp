//
//  TaskListRouter.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//
import Foundation
import UIKit
import CoreData

class TaskListRouter: TaskListRouterProtocol {
    var presenter:TaskListInteractorInputProtocol?
    
    static func createModule() -> UIViewController {
        let view = TaskListViewController()
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        let presenter = TaskListPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        return view
    }

    func navigateToDetail(from view: TaskListViewProtocol, with task: TaskObject) {
        let detailVC = TaskDetailRouter.createModule(with: task)
        if let sourceVC = view as? UIViewController {
            sourceVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func presentCreateTask(from view: TaskListViewProtocol) {
        let detailVC = TaskDetailRouter.createModule(with: nil)
        if let sourceVC = view as? UIViewController {
            sourceVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    func saveTasksFromAPI(_ taskDTOs: [TaskEntity]) {
        
        let context = CoreDataStack.shared.context

        for dto in taskDTOs {
            // Optional: Check if task with same ID already exists
            let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", dto.id)

            if let existing = try? context.fetch(request), existing.isEmpty == false {
                continue // skip duplicates
            }

            _ = TaskMapper.mapDTOToCoreData(dto, in: context)
        }

        do {
            try context.save()
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }
    
    func fetchTasksFromDatabase() -> [TaskObject] {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    
    func updateTaskObject(_ dto: TaskObject) {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", dto.id)

        do {
            if let task = try context.fetch(request).first {
                task.name = dto.name
                task.descriptionText = dto.descriptionText
                task.isCompleted = dto.isCompleted
                try context.save()
            }
        } catch {
            print("Failed to update: \(error)")
        }
    }
}

