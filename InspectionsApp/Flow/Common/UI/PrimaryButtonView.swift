//
//  PrimaryButtonView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/12/24.
//

import SwiftUI

struct PrimaryButtonView: View {
    var title: String
    var action: (() -> Void)
    var horizontalPadding: Double
    var verticalPadding: Double
    var foregroundColor: Color
    var backGroundColor: UIColor
    
    init(title: String,
         horizontalPadding: Double = 30,
         verticalPadding: Double = 8,
         foregroundColor: Color = .white,
         backGroundColor: UIColor = .red,
         action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.foregroundColor = foregroundColor
        self.backGroundColor = backGroundColor
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .fontWeight(.semibold)
                .font(.title3)
                .frame(width: .infinity, height: horizontalPadding)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .foregroundColor(foregroundColor)
                .background {
                    Color(backGroundColor)
                        .cornerRadius(verticalPadding)
                }
        }
    }
}

