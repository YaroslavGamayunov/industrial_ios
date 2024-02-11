//
//  ContentView.swift
//  todolist
//
//  Created by Ярослав Гамаюнов on 10.02.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TodoItem.isComplete, ascending: true),
            NSSortDescriptor(keyPath: \TodoItem.priority, ascending: false),
            NSSortDescriptor(keyPath: \TodoItem.deadline, ascending: true),
        ],
        animation: .default)
    private var items: FetchedResults<TodoItem>

    var body: some View {
        NavigationView {
            let completed = items.filter { item in
                item.isComplete
            }
            
            let notCompleted = items.filter { item in
                !item.isComplete
            }
            
            List {
                Section(header: Text("Not completed tasks")) {
                    ForEach(notCompleted) { todoItem in
                        NavigationLink {
                            EditItemScreen(item: todoItem, context: viewContext)
                        } label: {
                            TodoItemListView(item: todoItem)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section(header: Text("Completed tasks")) {
                    ForEach(completed) { todoItem in
                        NavigationLink {
                            EditItemScreen(item: todoItem, context: viewContext)
                        } label: {
                            TodoItemListView(item: todoItem)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink {
                        EditItemScreen(context: viewContext)
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
}
