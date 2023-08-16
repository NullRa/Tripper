//
//  AddCostItemView.swift
//  Tripper
//
//  Created by Apple on 2022/8/11.
//

import SwiftUI

struct AddCostItemView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var tripDataManager: TripDataManager
    @Binding var tripListIndex: Int?
    
    @Binding var itemName:String
    @Binding var itemPrice:Float
    @Binding var itemPaidMember:String
    @Binding var itemSharedMembers: [String]
    @Binding var costItemSwipeAction: SwipeBtnAction
    @Binding var costItemActionEditIndex: Int?
    @Binding var sharedMembersString: String
    @State var showSelectPaidMemberList = false
    @State var showSelectSharedMembersList = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    
    //    https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
    //    note_關閉keyboard_doneBtn, 這篇第二則
    //    note_關閉keyboard,點擊空白區域關閉 這篇第一則
    //    https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/swiftui-list-row-的-button-點選-af13892c95ca
    //    note_處理list內的btn無法點擊問題
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
                    if itemName == "" || itemPrice == 0 || itemPaidMember == "付錢的爸爸是誰" || itemSharedMembers.isEmpty {
                        //alert確認資料輸入正確
                        //                        note_alert
                        showAlert = true
                        alertTitle = "確認輸入資料是否正確"
                        return
                    }
                    
                    let costItem = CostItem(itemName: itemName, itemPrice: itemPrice, paidMember: itemPaidMember, sharedMembers: itemSharedMembers)
                    
                    if costItemSwipeAction == .edit, let index = costItemActionEditIndex {
                        let changeCostItem = tripDataManager.tripDataArray[tripListIndex!].costItems[index]
                        for i in 0 ..< tripDataManager.tripDataArray[tripListIndex!].tripMembers.count {
                            if tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].memberName == changeCostItem.paidMember {
                                tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].price = tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].price - (changeCostItem.itemPrice - changeCostItem.itemPrice/Float(changeCostItem.sharedMembers.count+1))
                            }
                            for sharedMember in changeCostItem.sharedMembers {
                                if tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].memberName == sharedMember {
                                    tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].price = tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].price + changeCostItem.itemPrice/Float(changeCostItem.sharedMembers.count+1)
                                }
                            }
                        }
                    }
                    for i in 0 ..< tripDataManager.tripDataArray[tripListIndex!].tripMembers.count {
                        if tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].memberName == itemPaidMember {
                            tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].price = tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].price + itemPrice - itemPrice/Float(itemSharedMembers.count+1)
                        }
                        for sharedMember in itemSharedMembers {
                            if tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].memberName == sharedMember {
                                tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].price = tripDataManager.tripDataArray[tripListIndex!].tripMembers[i].price - itemPrice/Float(itemSharedMembers.count+1)
                            }
                        }
                    }
                    
                    
                    //如果tripListIndex等於nil不會進入到這個頁面可以果斷使用!，邏輯是tripListIndex==nil，ScheduleView不會出現add的按鈕，沒有點擊add的按鈕不會進入此頁面。
                    //保險起見
                    if tripListIndex != nil {
                        //add新增
                        if costItemSwipeAction == .add {
                            tripDataManager.tripDataArray[tripListIndex!].costItems.append(costItem)
                        }
                        //edit用index判斷要更新誰
                        if costItemSwipeAction == .edit, let index = costItemActionEditIndex {
                            tripDataManager.tripDataArray[tripListIndex!].costItems[index] = costItem
                        }
                        tripDataManager.updateTrip()
                        dismiss()
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
                        Text(itemPaidMember)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showSelectPaidMemberList = true
                            }
                    }.font(.system(size: 20, weight: .semibold, design: .rounded))
                    HStack {
                        Text("欠債的人們:")
                        Text(sharedMembersString)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showSelectSharedMembersList = true
                            }
                    }.font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                .navigationTitle("t")
                .navigationBarHidden(true)
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
                            itemPaidMember = member.memberName
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
            MultipleSelectionList(tripMembers: tripDataManager.tripDataArray[tripListIndex!].tripMembers, itemSharedMembers: $itemSharedMembers, showSelectPaidMemberList: $showSelectSharedMembersList, sharedMembersString: $sharedMembersString)
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK"){
                showAlert = false
            }
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
    @Binding var itemSharedMembers: [String]
    @Binding var showSelectPaidMemberList: Bool
    @Binding var sharedMembersString: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tripMembers) { member in
                    MultipleSelectionRow(title: member.memberName, isSelected: itemSharedMembers.contains(member.memberName)) {
                        if self.itemSharedMembers.contains(member.memberName) {
                            self.itemSharedMembers.removeAll { select in
                                select == member.memberName
                            }
                        } else {
                            self.itemSharedMembers.append(member.memberName)
                        }
                        sharedMembersString = ""
                        for selection in itemSharedMembers {
                            if itemSharedMembers.first == selection {
                                sharedMembersString = selection
                            } else {
                                sharedMembersString = sharedMembersString + ", " + selection
                            }
                        }
                        if itemSharedMembers.isEmpty {
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
