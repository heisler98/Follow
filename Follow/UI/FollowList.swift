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
    @State private var newHabitText: String = ""
    @State private var isAddingHabit: Bool = false
    @State private var didFollowTomorrow = false
    var scheduler = HabitTaskScheduler()
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
                List {
                    ForEach(organizer.habits, id: \.self) { habit in
                        Text(habit.name)
                            .bold()
                    }
                }
                if scheduler.isManuallyScheduled == false {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.scheduler.manuallySchedule { (success) in
                                guard success == true else { return }
                                UserDefaults.standard.set(Date(), forKey: kFollowLastSetNotifyDate)
                            }
                            self.didFollowTomorrow.toggle()
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
            }.sheet(isPresented: $isAddingHabit, onDismiss: {
                if self.newHabitText != "" {
                    self.organizer.newHabit(Habit(name: self.newHabitText))
                    self.newHabitText = ""
                }
            }) {
                FollowAddHabit(text: self.$newHabitText, isPresented: self.$isAddingHabit)
            }
            
        }
    }
}

struct FollowList_Preview: PreviewProvider {
    static var previews: some View {
        FollowList(organizer: HabitOrganizer([testHabit, testHabit, testHabit, testHabit]))
    }
}
