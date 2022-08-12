//
//  AddCostItemView.swift
//  Tripper
//
//  Created by Apple on 2022/8/11.
//

import SwiftUI

struct AddCostItemView: View {
    @Environment(\.dismiss) var dismiss
    @State var itemName:String = ""
    @State var paidMember:String = "付錢的爸爸是誰"
    @State var itemPrice:Float = 0.0
    @StateObject var tripDataManager: TripDataManager
    @Binding var tripListIndex: Int?
    @State var showSelectPaidMemberList = false
    @State var showSelectSharedMembersList = false
    @State var sharedMembersString: String = "欠錢的孩子"
    
    @State var selections: [String] = []
    
    //    https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
    //    note_關閉keyboard_doneBtn
    private enum Field: Int, CaseIterable {
        case itemName,itemPrice
    }
    @FocusState private var focusedField: Field?
    
    let itemPriceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        //    https://blog.zhheo.com/p/426008c3.html
        //        note_格式
        //        https://www.hackingwithswift.com/quick-start/swiftui/how-to-format-a-textfield-for-numbers
        //        note_textfield格式
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("關閉")
                        .foregroundColor(.red)
                        .padding()
                }
                Spacer()
                Text("新增消費項目")
                    .font(.title)
                    .padding()
                Spacer()
                Button {
                    //                    let tripMember = TripMember(memberName:tripMemberName, price: 0)
                    //如果tripListIndex等於nil不會進入到這個頁面可以果斷使用!，邏輯是tripListIndex==nil，ScheduleView不會出現add的按鈕，沒有點擊add的按鈕不會進入此頁面。
                    //保險起見
                    if tripListIndex != nil {
                        //                        tripDataManager.tripDataArray[tripListIndex!].tripMembers.append(tripMember)
                        //                        tripDataManager.updateTrip()
                        //                        dismiss()
                    } else {
                        assertionFailure("這邊出包了請確認")
                    }
                } label: {
                    Text("加入")
                        .padding()
                }
            }
            NavigationView{
                List {
                    HStack {
                        Text("項目:")
                        TextField("名稱", text: $itemName)
                            .focused($focusedField, equals: .itemName)
                    }.font(.system(size: 20, weight: .semibold, design: .rounded))
                    HStack {
                        Text("金額:")
                        TextField("價格", value: $itemPrice, formatter: itemPriceFormatter)
                            .focused($focusedField, equals: .itemPrice)
                            .keyboardType(.decimalPad)
                    }.font(.system(size: 20, weight: .semibold, design: .rounded))
                    HStack {
                        Text("付錢的爸爸:")
                        Button {
                            showSelectPaidMemberList = true
                        } label: {
                            Text(paidMember)
                        }
                    }.font(.system(size: 20, weight: .semibold, design: .rounded))
                    HStack {
                        Text("欠債的人們:")
                        Button {
                            showSelectSharedMembersList = true
                        } label: {
                            Text(sharedMembersString)
                        }
                    }.font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                .toolbar(content: {
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            focusedField = nil
                        } label: {
                            Text("Done")
                        }
                    }
                })
                .listStyle(InsetGroupedListStyle())
            }
        }
        .fullScreenCover(isPresented: $showSelectPaidMemberList) {
            NavigationView {
                List {
                    ForEach(tripDataManager.tripDataArray[tripListIndex!].tripMembers) { member in
                        Button {
                            paidMember = member.memberName
                            showSelectPaidMemberList = false
                        } label: {
                            Text(member.memberName)
                        }
                    }
                    Button {
                        showSelectPaidMemberList = false
                    } label: {
                        Text("關閉")
                    }
                    
                }.navigationTitle("付錢的爸爸是誰")
            }
        }
        .fullScreenCover(isPresented: $showSelectSharedMembersList) {
            MultipleSelectionList(tripMembers: tripDataManager.tripDataArray[tripListIndex!].tripMembers, selections: $selections, showSelectPaidMemberList: $showSelectSharedMembersList, sharedMembersString: $sharedMembersString)
        }
    }
}

//struct AddCostItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCostItemView()
//    }
//}

//https://stackoverflow.com/questions/57022615/select-multiple-items-in-swiftui-list
//note_多選單
struct MultipleSelectionList: View {
    var tripMembers: [TripMember]
    @Binding var selections: [String]
    @Binding var showSelectPaidMemberList: Bool
    @Binding var sharedMembersString: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tripMembers) { member in
                    MultipleSelectionRow(title: member.memberName, isSelected: selections.contains(member.memberName)) {
                        if self.selections.contains(member.memberName) {
                            self.selections.removeAll { select in
                                select == member.memberName
                            }
                        } else {
                            self.selections.append(member.memberName)
                        }
                        sharedMembersString = ""
                        for selection in selections {
                            if selections.first == selection {
                                sharedMembersString = selection
                            } else {
                                sharedMembersString = sharedMembersString + ", " + selection
                            }
                        }
                        if selections.isEmpty {
                            sharedMembersString = "欠錢的孩子"
                        }
                    }
                }
                Button {
                    showSelectPaidMemberList = false
                } label: {
                    Text("關閉")
                }
            }.navigationTitle("欠錢的孩子們")
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: ()->Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
