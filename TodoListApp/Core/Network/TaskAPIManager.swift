//
//  TaskAPIManager.swift
//  TodoListApp
//
//  Created by Faryk on 04.08.2025.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://dummyjson.com/todos"
    
    func fetchTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        AF.request(baseURL).responseDecodable(of: TodoResponse.self) { response in
            switch response.result {
            case .success(let taskResponse):
                completion(.success(taskResponse.todos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct TodoResponse: Codable {
    let todos: [TaskEntity]
}
