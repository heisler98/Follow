//
//  FollowDreamSheet.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct FollowDreamSheet: View {
    var dream: Dream
    var body: some View {
        VStack(alignment: .leading) {
            Text(dream.title)
                .bold()
                .font(.title)
                .padding()
            TextView(text: .constant(dream.journal))
                .padding()
        }
        
    }
}

struct FollowDreamSheet_Previews: PreviewProvider {
    static var previews: some View {
        FollowDreamSheet(dream: testDream)
    }
}
