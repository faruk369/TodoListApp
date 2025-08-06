//
//  TaskAPIManager.swift
//  TodoListApp
//
//  Created by Faryk on 04.08.2025.
//

import Foundation
import Alamofire

struct TaskResponse: Codable {
    let todos: [TaskEntity]
}

class TaskAPIManager {
    static let shared = TaskAPIManager()
    private let baseURL = "https://dummyjson.com/todos"

    func fetchTasks(completion: @escaping (Result<[TaskObject], Error>) -> Void) {
        AF.request(baseURL).responseDecodable(of: TaskResponse.self) { response in
            switch response.result {
            case .success(let taskResponse):
                let context = CoreDataStack.shared.context
                let taskObjects: [TaskObject] = taskResponse.todos.map { entity in
                    let task = TaskObject(context: context)
                    task.id = Int64(entity.id)
                    task.name = entity.name
                    task.isCompleted = entity.isCompleted
                    task.dateCreated = Date()
                    return task
                }

                // Optionally save them to Core Data
                do {
                    try context.save()
                } catch {
                    print("Failed to save tasks: \(error)")
                }

                completion(.success(taskObjects))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
