//
//  ContentView.swift
//  Tripper
//
//  Created by Apple on 2022/7/29.
//

import SwiftUI

struct ContentView: View {
    @State var selection = 0
    
    var body: some View {
        VStack {
            NavView()
            Spacer()
            ZStack {
                switch selection {
                case 0:
                    Text("Tab1")
                case 1:
                    Text("Tab2")
                case 2:
                    Text("Tab3")
                case 3:
                    Text("Tab4")
                case 4:
                    Text("Tab5")
                default:
                    Text("default")
                }
            }
            Spacer()
            TabView(index: $selection)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NavView: View {
    var body: some View {
        HStack {
            Text("Trip Name")
            Spacer()
            Text("Setting")
        }.padding()
    }
}

struct TabView: View {
    @Binding var index: Int
    var body: some View {
        HStack {
            Button {
                index = 0
            } label: {
                TabItemView(tabItemType: .tab1, selected: self.index == 0)
            }
            Spacer()
            Button {
                index = 1
            } label: {
                TabItemView(tabItemType: .tab2, selected: self.index == 1)
            }
            Spacer()
            Button {
                index = 2
            } label: {
                TabItemView(tabItemType: .tab3, selected: self.index == 2)
            }
            Spacer()
            Button {
                index = 3
            } label: {
                TabItemView(tabItemType: .tab4, selected: self.index == 3)
            }
            Spacer()
            Button {
                index = 4
            } label: {
                TabItemView(tabItemType: .tab5, selected: self.index == 4)
            }
        }
        .padding()
        .background(Color(red: 188/255, green: 216/255, blue: 193/255))
        .animation(.spring(), value: index)
    }
}

enum TabItemType: String {
    case tab1 = "Tab1"
    case tab2 = "Tab2"
    case tab3 = "Tab3"
    case tab4 = "Tab4"
    case tab5 = "Tab5"
    
    var image: Image {
        switch self {
        case .tab1:
            return Image(systemName: "magnifyingglass")
        case .tab2:
            return Image(systemName: "magnifyingglass")
        case .tab3:
            return Image(systemName: "magnifyingglass")
        case .tab4:
            return Image(systemName: "magnifyingglass")
        case .tab5:
            return Image(systemName: "magnifyingglass")
        }
    }
    var text: Text {
        return Text(self.rawValue)
    }
}

struct TabItemView: View {
    let tabItemType: TabItemType
    var selected: Bool
    
    var body: some View {
        if selected {
            tabItemType.image
                .resizable()
                .frame(width: 25, height: 30)
                .foregroundColor(Color(red: 22/255, green: 80/255, blue: 142/255))
                .padding()
                .background(Color(red: 67/255, green: 154/255, blue: 134/255))
                .clipShape(Circle())
                .offset(y: -30)
        } else {
            VStack {
                tabItemType.image
                    .resizable()
                    .frame(width: 25, height: 30)
                    .foregroundColor(Color(red: 67/255, green: 154/255, blue: 134/255))
                tabItemType.text
                    .foregroundColor(Color(red: 22/255, green: 80/255, blue: 142/255))
            }
        }
    }
}
