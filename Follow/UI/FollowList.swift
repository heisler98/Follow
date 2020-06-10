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
    var body: some View {
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

struct FollowList_Preview: PreviewProvider {
    static var previews: some View {
        FollowList(organizer: HabitOrganizer([testHabit, testHabit, testHabit, testHabit]))
    }
}
