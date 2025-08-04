//
//  TaskListInteractor.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//

import Foundation

class TaskListInteractor: TaskListInteractorInputProtocol {
    weak var presenter: TaskListInteractorOutputProtocol?

    private var tasks: [TaskEntity] = [
        TaskEntity(id: 1, name: "Sample", description: "Details", isCompleted: false, dateCreated: Date())
    ]

    func fetchTasks() {
        presenter?.didFetchTasks(tasks)
    }

    func updateTaskCompletion(_ task: TaskEntity) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            presenter?.didUpdateTask(task)
        }
    }
    func deleteTask(_ task: TaskEntity) {
        presenter?.didUpdateTask(task)
    }
}

   
