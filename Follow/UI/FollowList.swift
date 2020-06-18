//
//  FollowList.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct FollowList: View {
    @ObservedObject var organizer: HabitOrganizer = HabitOrganizer()
    @ObservedObject var sprintOrganizer: SprintOrganizer = SprintOrganizer()
    @ObservedObject var todoOrganizer: ToDoOrganizer = ToDoOrganizer()
    @State private var newHabitText: String = ""
    @State private var isAddingHabit: Bool = false
    @State private var isPresentingFollowUp: Bool = false
    @State private var didFollowTomorrow = false
    ///0 = ToDo, 1 = Sprint, 2 = Habit
    @State private var listSelection: Int = 0
    @State private var isNewAdditionSprint: Bool = false
    @State private var newSprint: Sprint?
    @State private var newToDo: ToDo?
    var scheduler = HabitTaskScheduler()
    var trackOrganizer = TrackingOrganizer()
    @State private var feedbackGenerator: UISelectionFeedbackGenerator! = UISelectionFeedbackGenerator()
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Follow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    Button(action: { self.isAddingHabit = true }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .padding()
                    }
                }.sheet(isPresented: $isAddingHabit, onDismiss: {
                    if self.isNewAdditionSprint == true {
                        self.sprintOrganizer.newSprint(self.newSprint!)
                        self.isNewAdditionSprint = false
                        self.newSprint = nil
                        self.newHabitText = ""
                        return
                    }
                    if self.newToDo != nil {
                        self.todoOrganizer.newToDo(self.newToDo!)
                        self.newHabitText = ""
                    }
                    if self.newHabitText != "" {
                        self.organizer.newHabit(Habit(name: self.newHabitText))
                        self.newHabitText = ""
                    }
                    
                }) {
                    FollowAddHabit(isSprint: self.$isNewAdditionSprint, sprint: self.$newSprint, todo: self.$newToDo, text: self.$newHabitText, isPresented: self.$isAddingHabit)
                }
                if organizer.lastSaveSucceeded == false {
                    HStack {
                        Spacer()
                        Text("Failed to save habit").font(.callout)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 10).foregroundColor(.red)
                        ).onTapGesture {
                            self.organizer.lastSaveSucceeded = true
                        }
                        Spacer()
                    }
                }
                Picker(selection: $listSelection, label: Text("")) {
                    Text("To-do").tag(0)
                    Text("Sprints").tag(1)
                    Text("Habits").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                
                    .padding(.horizontal)
                    .sheet(isPresented: $isPresentingFollowUp, onDismiss: {
//                        self.scheduler.manuallySchedule { (success) in
//                            guard success == true else { return }
//                            UserDefaults.standard.set(Date(), forKey: kFollowLastSetNotifyDate)
//                        }
                        self.didFollowTomorrow.toggle()
                    }) {
                        FollowUpChecker(isPresented: self.$isPresentingFollowUp, habits: self.organizer.habits, sprints: self.sprintOrganizer.sprints)
                }
                if listSelection == 0 {
                    List {
                        ForEach(todoOrganizer.todos, id: \.self) { todo in
                            Text(todo.name)
                            .bold()
                        }.onDelete(perform: self.removeToDos(at:))
                    }
                }
                if listSelection == 2 {
                    List {
                        ForEach(organizer.habits, id: \.self) { habit in
                            Text(habit.name)
                            .bold()
                        }.onDelete(perform: self.organizer.removeHabits)
                    }
                }
                if listSelection == 1 {
                    List {
                        ForEach(sprintOrganizer.sprints, id: \.self) { sprint in
                            HStack {
                                Text(sprint.name)
                                    .bold()
                                Spacer()
                                Text("\(self.sprintOrganizer.daysLeft(in: sprint)) days left")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }.onDelete(perform: self.sprintOrganizer.removeSprints)
                    }
                }
                if scheduler.isManuallyScheduled == false {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.isPresentingFollowUp = true
                        }) {
                            Text("Follow tomorrow")
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20).foregroundColor(.green)
                            )
                        }
                        Spacer()
                    }
                }
            }.onTapGesture(count: 2) {
                switch self.listSelection {
                case 0:
                    self.listSelection = 1
                    break
                case 1:
                    self.listSelection = 2
                    break
                case 2:
                    self.listSelection = 0
                default:()
                }
            }        }.onReceive([self.listSelection].publisher.first()) { _ in
            self.feedbackGenerator.selectionChanged()
        }.onAppear {
            self.feedbackGenerator.prepare()
        }.onDisappear {
            self.feedbackGenerator = nil
        }
    }
    
    func removeToDos(at offsets: IndexSet) {
        self.todoOrganizer.removeTodos(at: offsets)
    }
    
    func cellFor(_ habit: Habit) -> some View {
        let streak = trackOrganizer.streakForHabit(habit)
        if streak > 0 {
            return AnyView(VStack(spacing: 0) {
                Text(habit.name)
                    .bold()
                    .padding(.bottom, 7)
                Text("🔥 \(streak)")
                    .font(.caption)
            })
        } else {
            return AnyView(VStack(spacing: 0) {
                Text(habit.name)
                    .bold()
            })
        }
    }
}

struct FollowList_Preview: PreviewProvider {
    static var previews: some View {
        FollowList(organizer: HabitOrganizer([testHabit, testHabit, testHabit, testHabit]))
    }
}
