//
//  Binding.swift
//  todolist
//
//  Created by Ярослав Гамаюнов on 10.02.2024.
//

import Foundation
import SwiftUI

extension Binding {
  func withDefault<T>(_ defaultValue: T) -> Binding<T> where Value == Optional<T> {
    return Binding<T>(get: {
      self.wrappedValue ?? defaultValue
    }, set: { newValue in
      self.wrappedValue = newValue
    })
  }
}
