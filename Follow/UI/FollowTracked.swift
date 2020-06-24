//
//  FollowTracked.swift
//  Follow
//
//  Created by Hunter Eisler on 6/19/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import SwiftUI

struct FollowTracked: View {
    @State private var configuration = TrackingDisplayer().mostRecentData()
    var body: some View {
        RadarView(configuration: $configuration)
    }
}

struct FollowTracked_Previews: PreviewProvider {
    static var previews: some View {
        FollowTracked()
    }
}
