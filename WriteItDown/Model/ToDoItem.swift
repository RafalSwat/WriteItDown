//
//  ToDoItem.swift
//  WriteItDown
//
//  Created by Rafał Swat on 24/03/2021.
//

import Foundation

struct ToDoItem {
    
    var date: Date
    var note: String
    var isDone: Bool
    var priority: Priority
    
    init(date: Date,
         note: String,
         isDone: Bool,
         priority: Priority) {
        
        self.date = date
        self.note = note
        self.isDone = isDone
        self.priority = priority
    }
    
}
enum Priority {
    case high
    case ordinary
    case low
}
