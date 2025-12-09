//
//  TaskObject+CoreDataProperties.swift
//  TodoListApp
//
//
//

import Foundation
import CoreData


extension TaskObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskObject> {
        return NSFetchRequest<TaskObject>(entityName: "TaskObject")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var dateCreated: Date?

}

extension TaskObject : Identifiable {

}
