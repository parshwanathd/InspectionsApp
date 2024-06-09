//
//  SegmentControlView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/9/24.
//

import SwiftUI

struct SegmentControlView: View {
    
    @State var segments: [Category]
    @Binding var selected: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal) {
                // 2
                HStack(spacing: 10) {
                    ForEach(segments) { segment in
                        Button {
                            selected = segment.id
                        } label: {
                            VStack {
                                Text(segment.name)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(selected == segment.id ? .red : Color(uiColor: .systemGray))
                                ZStack {
                                    Capsule()
                                        .fill(Color.clear)
                                        .frame(height: 4)
                                    if selected == segment.id {
                                        Capsule()
                                            .fill(Color.red)
                                            .frame(height: 4)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/*struct SegmentControlView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView()
    }
}*/
