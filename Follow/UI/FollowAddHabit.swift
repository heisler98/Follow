//
//  FollowAddHabit.swift
//  Follow
//
//  Created by Hunter Eisler on 6/9/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct FollowAddHabit: View {
    @Binding var text: String
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { self.isPresented = false }) {
                    Text("Commit")
                }.padding()
            }
            Form {
                TextField("Habit name", text: $text)
                .padding()
            }
        }
    }
}

struct FollowAddHabit_Previews: PreviewProvider {
    static var previews: some View {
        FollowAddHabit(text: .constant(""), isPresented: .constant(false))
    }
}
