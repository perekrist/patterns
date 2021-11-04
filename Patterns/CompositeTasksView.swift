//
//  CompositeTasksView.swift
//  Patterns
//
//  Created by Кристина Перегудова on 04.11.2021.
//

import SwiftUI

struct CompositeTasksView: View {
  @ObservedObject var parentTask = Task(name: "TODO:", parent: nil)
  
  var body: some View {
    NavigationView {
      List {
        ForEach(parentTask.children) { child in
          TaskView(task: child)
        }
      }
      .listStyle(.plain)
      .navigationBarTitle(parentTask.name).padding()
      .toolbar {
        AddTaskButton(task: parentTask)
      }
    }
  }
}

struct SubTasksView: View {
  @StateObject var task: Task
  
  var body: some View {
    List {
      ForEach(task.children) { child in
        TaskView(task: child)
      }
    }
    .listStyle(.plain)
    .navigationBarTitle(task.name)
    .padding()
    .toolbar {
      AddTaskButton(task: task)
    }
  }
}

struct TaskView: View {
  @ObservedObject var task: Task
  
  var body: some View {
    NavigationLink {
      SubTasksView(task: task)
    } label: {
      VStack(alignment: .leading) {
        Text(task.name).font(.title)
        Text("Subtasks: \(task.children.count)").foregroundColor(.secondary)
      }.padding()
    }
  }
}

struct AddTaskButton: View {
  @ObservedObject var task: Task
  var body: some View {
    Button {
      task.add(child: Task(name: "Task \(task.children.count + 1)", parent: task))
    } label: {
      Text("Add task")
    }
  }
}

protocol CompositeProtocol {
  var parent: CompositeProtocol? { get }
  var children: [Task] { get set }
  var name: String { get }
  
  func add(child: Task)
}

class Task: CompositeProtocol, Identifiable, ObservableObject {
  var name: String
  var parent: CompositeProtocol?
  @Published var children: [Task] = []
  
  init(name: String, parent: CompositeProtocol?) {
    self.name = name
    self.parent = parent
  }
  
  func add(child: Task) {
    children.append(child)
  }
}

