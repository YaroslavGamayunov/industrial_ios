//
//  TodoItemListView.swift
//  todolist
//
//  Created by Ярослав Гамаюнов on 11.02.2024.
//

import Foundation
import SwiftUI


struct TodoItemListView: View {
    
    @ObservedObject var item: TodoItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name ?? "")
            
            if (item.deadline != nil) {
                Text("Due date: \(itemFormatter.string(from: item.deadline!))").font(.footnote)
            }
            if (item.priority == TaskPriority.high.rawValue) {
                Text("High priority!").font(.footnote).foregroundStyle(.red)
            }
        }
        
        Image(systemName: item.isComplete ? "checkmark.square.fill" : "square")
                    .foregroundColor(item.isComplete ? Color(UIColor.systemBlue) : Color.secondary)
                    .onTapGesture {
                        item.isComplete = !item.isComplete
                        do {
                            try item.managedObjectContext?.save()
                        } catch {
                            print(error)
                        }
                    }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
