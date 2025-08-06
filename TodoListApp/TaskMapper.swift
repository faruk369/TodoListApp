//
//  TaskMapper.swift
//  TodoListApp
//
//  Created by Faryk on 05.08.2025.
//

import Foundation
import CoreData

struct TaskMapper {
    
    static func mapDTOToCoreData(_ dto: TaskEntity, in context: NSManagedObjectContext) -> TaskObject {
        let task = TaskObject(context: context)
        task.id = Int64(dto.id)
        task.name = dto.name
        task.descriptionText = dto.description
        task.isCompleted = dto.isCompleted
        task.dateCreated = dto.dateCreated
        return task
    }

    static func mapCoreDataToDTO(_ object: TaskObject) -> TaskEntity {
        return TaskEntity(
            id: Int(object.id),
            name: object.name ?? "",
            description: object.descriptionText ?? "",
            isCompleted: object.isCompleted,
            dateCreated: object.dateCreated ?? Date()
        )
    }
}
