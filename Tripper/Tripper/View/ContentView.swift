//
//  ContentView.swift
//  Tripper
//
//  Created by Apple on 2022/7/29.
//

import SwiftUI

struct ContentView: View {
    @State var tabSelection = 1
    @State var tripListIndex: Int?
    @State private var showingTripList = false
    @State var showingAddTripTextFieldAlert = false
    @State var textFieldEnter = ""
    @StateObject var tripDataManager = TripDataManager.shared
    
    
    var body: some View {
        VStack {
            NavView(showingTripList: $showingTripList,
                    showingAddTripTextFieldAlert: $showingAddTripTextFieldAlert,
                    tripListIndex: $tripListIndex,
                    tripDataManager: tripDataManager)
            Spacer()
            ZStack {
                switch tabSelection {
                case 0:
                    //開銷-拆帳
                    CostView(tripDataManager: tripDataManager, tripListIndex: $tripListIndex)
                case 1:
                    //行程schedule
                    ScheduleView(tripDataManager: tripDataManager, tripListIndex: $tripListIndex)
                default:
                    //1相簿PhotoView(),3留言板PostView(),4個人記事本NoteView()
                    Text("default")
                }
            }
            Spacer()
            TabView(index: $tabSelection)
        }
        .onAppear(perform: {
            if !tripDataManager.tripDataArray.isEmpty {
                tripListIndex = 0
            }
        })
        .confirmationDialog("test", isPresented: $showingTripList) {
            //note_forEach取得index,element
            //https://stackoverflow.com/questions/57244713/get-index-in-foreach-in-swiftui
            //array.enumerated()
            //ForEach(contentViewModel.tripList) { tripName in}
            
            ForEach(Array(tripDataManager.tripDataArray.enumerated()), id: \.offset) { index, tripData in
                Button {
                    //fixme切換旅程資料
                    tripListIndex = index
                } label: {
                    Text(tripData.tripName)
                }
            }
            
            Button {
                showingAddTripTextFieldAlert = true
            } label: {
                Text("新增旅程")
            }
        }
        .textFieldAlert(isPresented: $showingAddTripTextFieldAlert, title: "輸入旅程名稱", text: $textFieldEnter, placeholder: "輸入旅程名稱") { tripName in
            tripDataManager.addTrip(tripName: tripName)
            tripListIndex = tripDataManager.tripDataArray.count-1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NavView: View {
    @Binding var showingTripList: Bool
    @Binding var showingAddTripTextFieldAlert: Bool
    @Binding var tripListIndex: Int?
    //    @ObservedObject var contentViewModel: ContentViewModel
    @StateObject var tripDataManager: TripDataManager
    var body: some View {
        HStack {
            Button {
                if tripDataManager.tripDataArray.isEmpty {
                    showingAddTripTextFieldAlert = true
                } else {
                    showingTripList = true
                }
            } label: {
                if tripDataManager.tripDataArray.isEmpty {
                    Text("新增旅程")
                } else {
                    Text("切換旅程")
                }
            }
            Spacer()
            //            Text(tripListIndex==nil ? "請先新增旅行" : contentViewModel.tripList[tripListIndex!])
            Text(tripListIndex==nil ? "請先新增旅行" : tripDataManager.tripDataArray[tripListIndex!].tripName)
            Spacer()
            // MARK: - todo 設定按鈕沒有功能先隱藏
            //            Text("設定")
        }.padding()
    }
}

struct TabView: View {
    @Binding var index: Int
    var body: some View {
        HStack {
            // MARK: todo 未實作按鈕先隱藏
            Spacer()
            Button {
                index = 0
            } label: {
                TabItemView(tabItemType: .tab1, selected: self.index == 0)
            }
            Spacer()
            Button {
                index = 1
            } label: {
                TabItemView(tabItemType: .tab3, selected: self.index == 1)
            }
            Spacer()
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
    //note_alert textfield
    //https://stackoverflow.com/questions/72446462/showing-textfield-in-alert-function-at-swiftui
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
                            Text("取消")
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
                            Text("確認")
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
