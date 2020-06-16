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
    var sprints: [Sprint] = []
//    var habits: [Habit] = [testHabit, testHabit, testHabit, testHabit, testHabit]
    @State private var floatingValues: [Double] = HabitOrganizer().habits.map { _ in Double() }
    @State private var sprintFloatingValues: [Double] = SprintOrganizer().sprints.map { _ in Double() }
//    @State private var floatingValues: [Double] = [0, 0, 0, 0, 0]
    var organizer = TrackingOrganizer()
    var sprintOrganizer = SprintTrackingOrganizer()
    var feedbackGenerator = UISelectionFeedbackGenerator()
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Cancel")
                        .bold()
                        .padding()
                }
                Spacer()
                Button(action: {
                    self.commit()
                    self.isPresented = false
                    
                }) {
                    Text("Commit")
                        .bold()
                        .padding()
                }
            }.padding(.top)
            HStack {
                Text("Track today")
                    .font(.title)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            //                .padding(.top)
            ScrollView {
                ForEach(floatingValues.indices) { index in
                    Text(self.habits[index].name)
                        .bold()
                        .padding()
//                    Slider(value: self.$floatingValues[index], in: 0...1, step: 0.25, onEditingChanged: {
//                        _ in
//                        self.feedbackGenerator.selectionChanged()
//                    })
//
//                        .background(Color.green
//                            .clipShape(RoundedRectangle(cornerRadius: 30)))
                    CustomSlider(value: self.$floatingValues[index], range: (0, 100), { (modifiers) in
                        self.sliderView(value: self.$floatingValues[index], modifiers)
                    })
                    
                        .frame(height: 30)
                        .padding([.bottom, .horizontal])
                    
                }
                ForEach(sprintFloatingValues.indices) { index in
                    Text(self.sprints[index].name)
                        .bold()
                        .padding()
                    CustomSlider(value: self.$sprintFloatingValues[index], range: (0, 100)) { (modifiers) in
                        self.sliderView(value: self.$sprintFloatingValues[index], modifiers)
                    }
                    .frame(height: 30)
                    .padding([.bottom, .horizontal])
                }
                Spacer()
            }
        }.onAppear {
            self.feedbackGenerator.prepare()
        }
    }
    
    func commit() {
        let track = Tracked(Date(), evaluation: Dictionary(uniqueKeysWithValues: zip(self.habits, self.floatingValues.map { Float($0) })))
        let sprintTrack = SprintTracked(Date(), evaluation: Dictionary(uniqueKeysWithValues: zip(self.sprints, self.sprintFloatingValues)))
        self.organizer.newTrack(track)
        self.sprintOrganizer.newTrack(sprintTrack)
        HabitTaskScheduler().manuallySchedule {
            (success) in
            guard success == true else { return }
            UserDefaults.standard.set(Date(), forKey: kFollowLastSetNotifyDate)
        }
        SprintTaskScheduler().manuallySchedule { (success) in
            guard success == true else { return }
            UserDefaults.standard.set(Date(), forKey: kFollowLastSetSprintNotifyDate)
        }
    }
    
    private func sliderView(value: Binding<Double>, _ modifiers: CustomSliderComponents) -> some View {
        ZStack {
          LinearGradient(gradient: .init(colors: [Color.blue, Color.green ]), startPoint: .leading, endPoint: .trailing)
          ZStack {
            Circle().fill(value.wrappedValue > 60 ? Color.green : Color.white)
                .shadow(radius: 10)
            Circle().stroke(Color.black.opacity(0.2), lineWidth: 2)
            Text(("\(Int(value.wrappedValue))")).font(.system(size: 11)).foregroundColor(.black)
          }
          .padding([.top, .bottom], 2)
          .modifier(modifiers.knob)
        }.cornerRadius(15)
    }
}

struct FollowUpChecker_Previews: PreviewProvider {
    static var previews: some View {
        FollowUpChecker(isPresented: .constant(true))
    }
}
