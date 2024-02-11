//
//  EditItemScreen.swift
//  todolist
//
//  Created by Ярослав Гамаюнов on 10.02.2024.
//

import Foundation
import SwiftUI
import CoreData


struct EditItemScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var item: TodoItem
    private var context: NSManagedObjectContext
    private var isNewItem: Bool
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let endComponents = DateComponents(year: 2124, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return Date.now
            ...
            calendar.date(from:endComponents)!
    }()

    init(item: TodoItem, context: NSManagedObjectContext) {
        self.item = item
        self.context = context
        self.isNewItem = false
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.isNewItem = true
        
        let itemEnity = NSEntityDescription.entity(forEntityName: "TodoItem", in: context)!
        
        self.item = TodoItem(entity: itemEnity, insertInto: nil)
        self.item.deadline = Date.now
        self.item.isComplete = false
        self.item.detailed = ""
        self.item.priority = TaskPriority.low.rawValue
        self.item.id = UUID()
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Text("Name of task").font(.footnote)
                TextField(
                    "Put name of task here",
                    text: $item.name.withDefault("")
                )
            }
            
            VStack(alignment: .leading) {
                Text("Task details").font(.footnote)
                TextField(
                    "Put task details here",
                    text: $item.detailed.withDefault("")
                )
            }
            
            DatePicker(
                "Deadline",
                selection: $item.deadline.withDefault(Date.now),
                in: dateRange,
                displayedComponents: [.date, .hourAndMinute])
            
            Picker("Priority", selection: $item.priority) {
                ForEach(TaskPriority.allCases, id: \.id) { priority in
                    Text("\(priority)".capitalized).tag(priority.rawValue)
                }
            }
        }.toolbar {
            ToolbarItem {
                if (self.isNewItem) {
                    Button("Add Item", action: addNewItem)
                } else {
                    Button("Save changes", action: saveChanges)
                }
            }
        }
    }

    private func saveChanges() {
        do {
            try context.save()
            dismiss()
        } catch {
            print(error)
        }
    }
    
    private func addNewItem() {
        context.insert(item)
        dismiss()
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

