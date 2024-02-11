//
//  TaskPriority.swift
//  todolist
//
//  Created by Ярослав Гамаюнов on 11.02.2024.
//

import Foundation

enum TaskPriority: Int32, CaseIterable {
    case low = 1
    case high = 2
    
    var id: Self { self }
}
