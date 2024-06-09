//
//  InspectionQuestionView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/9/24.
//

import SwiftUI

struct InspectionQuestionView: View {
    @Binding var question: Question?
    @Binding var selected: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question?.name ?? "")
                .font(Font.system(size: 18))
                .fontWeight(.medium)
                .padding(.top, 16)
            VStack(alignment: .leading, spacing: 16) {
                ForEach(question?.answerChoices ?? []) { item in
                    RadioButtonField(
                        id: item.id,
                        label: item.name,
                        isMarked: selected == item.id ? true : false
                    ) { value in
                        selected = value
                        question?.selectedAnswerChoiceID = "\(selected)"
                    }
                }
            }.padding(16)
        }
    }
}

/*struct InspectionQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        InspectionQuestionView(title: .constant("One"))
    }
}*/
