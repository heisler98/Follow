//
//  FollowUpChecker.swift
//  Follow
//
//  Created by Hunter Eisler on 6/12/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct FollowUpChecker: View {
    @Binding var isPresented: Bool
    var habits: [Habit] = []
//    var habits: [Habit] = [testHabit, testHabit, testHabit, testHabit, testHabit]
    @State private var floatingValues: [Float] = HabitOrganizer().habits.map { _ in Float() }
//    @State private var floatingValues: [Float] = [0, 0, 0, 0, 0]
    var organizer = TrackingOrganizer()
    var body: some View {
        VStack {
            HStack {
                Text("Track today")
                    .font(.title)
                    .bold()
                    .padding(.leading)
                Spacer()
                Button(action: {
                    let track = Tracked(Date(), evaluation: Dictionary(uniqueKeysWithValues: zip(self.habits, self.floatingValues)))
                    self.organizer.newTrack(track)
                    self.isPresented = false
                }) {
                    Text("Commit")
                        .bold()
                        .padding()
                }
            }.padding(.top)
            ForEach(floatingValues.indices) { index in
                Text(self.habits[index].name)
                    .bold()
                    .padding()
                Slider(value: self.$floatingValues[index], in: 0...1, step: 0.25)
                    .background(Color.green
                        .clipShape(RoundedRectangle(cornerRadius: 30)))
                    .padding([.bottom, .horizontal])
            }
            Spacer()
        }
    }
}

struct FollowUpChecker_Previews: PreviewProvider {
    static var previews: some View {
        FollowUpChecker(isPresented: .constant(true))
    }
}
