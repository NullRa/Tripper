//
//  ContentView.swift
//  Tripper
//
//  Created by Apple on 2022/7/29.
//

import SwiftUI

struct ContentView: View {
    @State var selection = 2
    @State private var showingTripList = false
    @State var showingAddTripTextFieldAlert = false
    @State var text = "Text to change test"
    
    var body: some View {
        VStack {
            NavView(showingTripList: $showingTripList)
            Spacer()
            ZStack {
                switch selection {
                case 0:
                    //開銷-拆帳
                    CostView()
                case 1:
                    //相簿
                    PhotoView()
                case 2:
                    //行程schedule
                    ScheduleView()
                case 3:
                    //留言板
                    PostView()
                case 4:
                    //個人記事本
                    NoteView()
                default:
                    Text("default")
                }
            }
            Spacer()
            TabView(index: $selection)
        }
        .confirmationDialog("test", isPresented: $showingTripList) {
            Button {
                showingAddTripTextFieldAlert = true
            } label: {
                Text("Add Trip")
            }
        }
        .textFieldAlert(isPresented: $showingAddTripTextFieldAlert, title: "Some Title Test", text: $text, placeholder: "Placeholder") { text in
            print(text)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NavView: View {
    @Binding var showingTripList: Bool
    var body: some View {
        HStack {
            Button {
                showingTripList = true
            } label: {
                Text("Trip Name")
            }
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
    case tab1 = "Cost"
    case tab2 = "Photo"
    case tab3 = "Schedule"
    case tab4 = "Post"
    case tab5 = "Note"
    
    var image: Image {
        switch self {
        case .tab1:
            return Image(systemName: "dollarsign.circle")
        case .tab2:
            return Image(systemName: "person.circle")
        case .tab3:
            return Image(systemName: "clock.circle")
        case .tab4:
            return Image(systemName: "pencil.tip.crop.circle")
        case .tab5:
            return Image(systemName: "list.bullet.circle")
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

struct TextFieldAlert: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    @Binding var text: String
    let placeholder: String
    let action: (String) -> Void
    func body(content: Content) -> some View {
        ZStack(alignment: .center){
            content.disabled(isPresented)
            if isPresented {
                VStack{
                    Text(title).font(.headline).padding()
                    TextField(placeholder,text:$text).textFieldStyle(.roundedBorder).padding()
                    Divider()
                    HStack{
                        Spacer()
                        Button(role: .cancel) {
                            withAnimation {
                                isPresented.toggle()
                            }
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        Button {
                            action(text)
                            withAnimation {
                                isPresented.toggle()
                            }
                        } label: {
                            Text("Done")
                        }
                        Spacer()
                    }
                }
                .background(.background)
                .frame(
                    width: 300,
                    height: 200
                )
                .cornerRadius(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.quaternary,lineWidth: 1)
                }
            }
        }
    }
}

extension View {
    public func textFieldAlert(
        isPresented: Binding<Bool>,
        title:String,
        text:Binding<String>,
        placeholder:String="",
        action:@escaping (String) -> Void
    ) -> some View {
        self.modifier(TextFieldAlert(isPresented: isPresented, title: title, text: text, placeholder: placeholder, action: action))
    }
}
