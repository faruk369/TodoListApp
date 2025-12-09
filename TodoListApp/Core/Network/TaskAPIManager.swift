//
//  TaskAPIManager.swift
//  TodoListApp
//
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private let session: Session
    private let baseURL = "https://dummyjson.com/todos"
    
    // Add background queue
    private let backgroundQueue = DispatchQueue.global(qos: .background)
    
    // Dependency injection for testing
    init(session: Session = AF) {
        self.session = session
    }
    
    func fetchTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        // Use background queue for the request
        backgroundQueue.async {
            self.session.request(self.baseURL)
                .validate()
                .responseDecodable(of: TodoResponse.self, queue: self.backgroundQueue) { response in
                    switch response.result {
                    case .success(let taskResponse):
                        DispatchQueue.main.async {
                            completion(.success(taskResponse.todos))
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
        }
    }
}

struct TodoResponse: Codable {
    let todos: [TaskEntity]
}
