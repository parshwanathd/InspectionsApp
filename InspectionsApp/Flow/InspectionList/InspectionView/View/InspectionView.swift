//
//  InspectionView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/9/24.
//

import SwiftUI
import CoreData

struct InspectionView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var selectedCategorie: Int = 1
    @StateObject var viewModel: InspectionViewModel
    @State var selectedQA: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading,spacing: 0) {
                SegmentControlView(segments: viewModel.data, selected: $selectedCategorie)
                question
                HStack {
                    if !viewModel.hidePreviousAction {
                        PrimaryButtonView(title: "Previous", foregroundColor: .red, backGroundColor: .white) {
                            viewModel.preQuestion(selectedCategorie: selectedCategorie)
                            selectedQA = viewModel.selectedAnswer(selectedCategorie: selectedCategorie)
                        }
                    }
                    Spacer()
                    if !viewModel.hideNextAction {
                        PrimaryButtonView(title: "Next", foregroundColor: .red, backGroundColor: .white) {
                            viewModel.nextQuestion(selectedCategorie: selectedCategorie)
                            selectedQA = viewModel.selectedAnswer(selectedCategorie: selectedCategorie)
                        }
                    }
                }.padding(.bottom, 16)
                Text(viewModel.submitted ?? "")
                Spacer()
            }
            PrimaryButtonView(title: viewModel.saveType == .completed ? "Submit" : "Save") {
                viewModel.save()
            }.frame(alignment: .center)
        }.padding(.all, 24)
            .onAppear(perform: {
                viewModel.startQuestion(selectedCategorie: selectedCategorie)
                selectedQA =  viewModel.selectedAnswer(selectedCategorie: selectedCategorie)
            })
            .onChange(of: selectedCategorie) { newValue in
                viewModel.startQuestion(selectedCategorie: selectedCategorie)
                selectedQA = viewModel.selectedAnswer(selectedCategorie: selectedCategorie)
            }.onChange(of: selectedQA) { newValue in
                viewModel.updateQuestion(newValue: newValue, selectedCategorie: selectedCategorie)
            }.onDisappear {
                viewModel.save()
            }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                viewModel.save()
                self.mode.wrappedValue.dismiss()
            }, label: {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.left").foregroundColor(.red)
                    Text("Back").foregroundColor(.red)
                }
            }))
    }
    
    var question: some View {
        InspectionQuestionView(question: .constant(viewModel.selectedQuestion(selectedCategorie: selectedCategorie)), selected: $selectedQA)
    }

}
