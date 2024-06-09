//
//  RadioButtonField.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/9/24.
//

import SwiftUI

struct RadioButtonField: View {
    let id: Int
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (Int)->()
    
    init(
        id: Int,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        textSize: CGFloat = 18,
        isMarked: Bool = false,
        callback: @escaping (Int)->()
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(Font.system(size: textSize))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}

/*struct RadioButtonField_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonField()
    }
}*/
