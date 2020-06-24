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
    @ObservedObject var synchronicityOrganizer: SynchronicityOrganizer = SynchronicityOrganizer()
    @ObservedObject var dreamOrganizer: DreamOrganizer = DreamOrganizer()
    
    @State private var isAddingHabit: Bool = false
    @State private var isPresentingFollowUp: Bool = false
    @State private var didFollowTomorrow = false
    ///0 = ToDo, 1 = Synchronicity, 2 = Dreams, 3 = Sprint, 4 = Habit
    @State private var listSelection: Int = 0
    @State private var dreamSelected: Dream? = nil
    
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
                }.sheet(isPresented: $isAddingHabit) {
                    FollowAddHabit(habitOrganizer: self.organizer, sprintOrganizer: self.sprintOrganizer, todoOrganizer: self.todoOrganizer, synchronicityOrganizer: self.synchronicityOrganizer, dreamOrganizer: self.dreamOrganizer,isPresented: self.$isAddingHabit)
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
                    Text("ψ").tag(1)
                    Text("Dreams").tag(2)
                    Text("Sprints").tag(3)
                    Text("Habits").tag(4)
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
                if listSelection == 1 {
                    List {
                        ForEach(synchronicityOrganizer.synchronicities, id: \.self) { synchronicity in
                            Text(synchronicity.name)
                                .bold()
                        }.onDelete(perform: self.synchronicityOrganizer.removeSynchronicities)
                        
                    }
                }
                if listSelection == 2 {
                    List {
                        ForEach(dreamOrganizer.dreams, id: \.self) { dream in
                            Text(dream.title)
                                .bold()
                                .onTapGesture {
                                    self.dreamSelected = dream
                            }
                        }.onDelete(perform: self.dreamOrganizer.removeDreams)
                            .sheet(item: self.$dreamSelected, onDismiss: {
                                self.dreamSelected = nil
                            }) { (dreamSelected) in
                                FollowDreamSheet(dream: self.dreamSelected!)
                        }
                    }
                }
                if listSelection == 4 {
                    List {
                        ForEach(organizer.habits, id: \.self) { habit in
                            Text(habit.name)
                                .bold()
                        }.onDelete(perform: self.organizer.removeHabits)
                    }
                }
                if listSelection == 3 {
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
                if self.listSelection == 4 {
                    self.listSelection = 0
                } else {
                    self.listSelection += 1
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
