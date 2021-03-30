//
//  ToDoItem+CoreDataProperties.swift
//  
//
//  Created by Rafał Swat on 26/03/2021.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var priority: NSObject?

}
