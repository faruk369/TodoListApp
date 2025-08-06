//
//  TaskEntity.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//

import Foundation

struct TaskEntity: Codable {
    let id: Int
    var name: String
    var description: String
    var isCompleted: Bool
    let dateCreated: Date

    enum CodingKeys: String, CodingKey {
        case id, name = "todo", isCompleted = "completed", description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id          = try container.decode(Int.self,  forKey: .id)
        name        = try container.decode(String.self, forKey: .name)
        isCompleted = try container.decode(Bool.self,   forKey: .isCompleted)
        description = "Task from API"
        dateCreated = Date()
    }

    //member-wise init
    init(id: Int, name: String, description: String, isCompleted: Bool, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.description = description
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
    }
}
