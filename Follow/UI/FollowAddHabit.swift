//
//  FollowAddHabit.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct FollowAddHabit: View {
    
    var habitOrganizer: HabitOrganizer
    var sprintOrganizer: SprintOrganizer
    var todoOrganizer: ToDoOrganizer
    var synchronicityOrganizer: SynchronicityOrganizer
    var dreamOrganizer: DreamOrganizer
    
    @Binding var isPresented: Bool
    
    @State private var text: String = ""
    
    ///0 = habit, 1 = sprint, 2 = todo
    @State private var formSelection = 0
    @State private var expiryDays = ""
    var body: some View {
        VStack {
            HStack {
                Text("Something new")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    switch self.formSelection {
                    case 0: //habit
                        self.habitOrganizer.newHabit(Habit(name: self.text))
                        break
                    case 1: //synchronicity
                        self.synchronicityOrganizer.newSynchronicity(Synchronicity(name: self.text, frequency: 0))
                        break
                    case 2: //sprint
                        self.sprintOrganizer.newSprint(Sprint(name: self.text, expiry: Date() + 60*60*24*Double(self.expiryDays)!))
                        break
                    case 3: //todo
                        self.todoOrganizer.newToDo(ToDo(name: self.text, recurring: true))
                    case 4:
                        self.dreamOrganizer.newDream(Dream(date: Date(), journal: self.text))
                    default:()
                    }
                    self.isPresented = false
                }) {
                    Text("Commit")
                }.padding()
            }
            Picker(selection: $formSelection, label: Text("")) {
                Text("Habit").tag(0)
                Text("Synchronicity").tag(1)
                Text("Sprint").tag(2)
                Text("To-do").tag(3)
                Text("Dream").tag(4)
            }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            //            Form {
            if formSelection == 0 {
                TextField("Habit name", text: $text)
                    
                    .padding()
            }
            if formSelection == 1 {
                TextField("Synchronicity", text: $text)
                    .padding()
            }
            if formSelection == 2 {
                TextField("Sprint name", text: $text)
                    .padding()
                TextField("Number of days to sprint", text: $expiryDays).keyboardType(.numberPad)
                    .padding()
            }
            if formSelection == 3 {
                TextField("To-do", text: $text)
                    .padding()
            }
            if formSelection == 4 {
                TextView(text: $text)
                .padding()
            }
            //            }
            Spacer()
        }
    }
}

struct FollowAddHabit_Previews: PreviewProvider {
    static var previews: some View {
        FollowAddHabit(habitOrganizer: HabitOrganizer(), sprintOrganizer: SprintOrganizer(), todoOrganizer: ToDoOrganizer(), synchronicityOrganizer: SynchronicityOrganizer(), dreamOrganizer: DreamOrganizer(), isPresented: .constant(true))
    }
}
