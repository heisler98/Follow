//
//  FollowAddHabit.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct FollowAddHabit: View {
    @Binding var isSprint: Bool
    @Binding var sprint: Sprint?
    @Binding var text: String
    @Binding var isPresented: Bool
    ///0 = habit, 1 = sprint
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
                        self.isPresented = false
                        break
                    case 1: //sprint
                        self.isSprint = true
                        self.sprint = Sprint(name: self.text, expiry: Date() + 60*60*24*Double(self.expiryDays)!)
                        break
                    default:()
                    }
                    self.isPresented = false
                }) {
                    Text("Commit")
                }.padding()
            }
            Picker(selection: $formSelection, label: Text("")) {
                Text("Habit").tag(0)
                Text("Sprint").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            Form {
                if formSelection == 0 {
                    TextField("Habit name", text: $text)
                        .padding()
                }
                if formSelection == 1 {
                    TextField("Sprint name", text: $text)
                        .padding()
                    TextField("Number of days to sprint", text: $expiryDays).keyboardType(.numberPad)
                        .padding()
                }
            }
        }
    }
}

struct FollowAddHabit_Previews: PreviewProvider {
    static var previews: some View {
        FollowAddHabit(isSprint: .constant(false), sprint: .constant(nil), text: .constant(""), isPresented: .constant(false))
    }
}
