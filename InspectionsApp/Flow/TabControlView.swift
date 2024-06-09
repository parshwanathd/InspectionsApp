//
//  TabControlView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import SwiftUI

struct TabControlView: View {
    @State private var selectedIndex: Int = 0
    @State var isNavigationBarHidden: Bool = true
    var body: some View {
        TabView(selection: $selectedIndex) {
            InspectionListView1()
                .navigationBarBackButtonHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .tabItem {
                    Text("Home view")
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                }
                .tag(0)
            
            InspectionListView()
                .navigationBarBackButtonHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(1)
        }
        .navigationBarBackButtonHidden(self.isNavigationBarHidden)
        .navigationTitle(selectedIndex == 0 ? "Home" : "Profile")
        .onAppear {
            self.isNavigationBarHidden = true
        }
        .tint(.pink)
        .onAppear(perform: {
            UITabBar.appearance().unselectedItemTintColor = .systemBrown
            UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
            //5
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
            //UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
            //Above API will kind of override other behaviour and bring the default UI for TabView
        })
    }
}

struct TabControlView_Previews: PreviewProvider {
    static var previews: some View {
        TabControlView()
    }
}

struct InspectionListView: View {
    //TODO: Pass item list here
    let animalList = Animal.preview()
    var body: some View {
        //NavigationView {
            List(animalList) { animal in
                NavigationLink {
                    InspectionView(selected: "OPEN")
                } label: {
                    Text(animal.name)
                }
                
            }
       // }
    }
}

struct InspectionListView1: View {
    //TODO: Pass item list here
    let animalList = Animal.preview()
    var body: some View {
        List(animalList) { animal in
            Text(animal.name)
        }
    }
}

struct Animal: Identifiable {
    var identifier = UUID()
    var id: Int
    var name: String
    
    
    static func preview() -> [Animal] {
        return [Animal(id: 0, name: "cat"),
                Animal(id: 1, name: "cat"),
                Animal(id: 3, name: "goat"),
                Animal(id: 4, name: "camel"),
                Animal(id: 5, name: "elephant"),
                Animal(id: 6, name: "cat"),
                Animal(id: 12, name: "monkey")]
    }
}

struct SegmentedView: View {
    
    let segments: [String] = ["OPEN", "COMPLETED", "CANCELLED", "ALL"]
    @Binding var selected: String
    @Namespace var name: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal) {
                // 2
                HStack(spacing: 10) {
                    ForEach(segments, id: \.self) { segment in
                        Button {
                            selected = segment
                        } label: {
                            VStack {
                                Text(segment)
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .foregroundColor(selected == segment ? .red : Color(uiColor: .systemGray))
                                ZStack {
                                    Capsule()
                                        .fill(Color.clear)
                                        .frame(height: 4)
                                    if selected == segment {
                                        Capsule()
                                            .fill(Color.red)
                                            .frame(height: 4)
                                            .matchedGeometryEffect(id: "Tab", in: name)
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

struct InspectionQuestionView: View {
    @Binding var title: String
    @State private var selected = 1
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.black)
                .padding(.bottom, 24)
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array([1,2,3,4,5,6]), id: \.self) { item in
                    RadioButtonField(
                        id: item,
                        label: "\(item)",
                        isMarked: selected == item ? true : false
                    ) { value in
                        selected = value
                    }
                }
            }.padding(16)
        }
    }
}

struct InspectionView: View {
    @State var selected: String
    @Namespace var namespace
    var body: some View {
        VStack {
            SegmentedView(selected: $selected, name: _namespace)
                .padding(.bottom, 24)
            InspectionQuestionView(title: $selected)
            HStack {
                PrimaryButtonView(title: "Pre") {
                    
                }
                Spacer()
                PrimaryButtonView(title: "Net") {
                    
                }
            }
            Spacer()
        }.padding(.horizontal, 16)
    }
}

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
        textSize: CGFloat = 14,
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
