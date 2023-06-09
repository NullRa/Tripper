//
//  CostView.swift
//  Tripper
//
//  Created by Apple on 2022/8/1.
//

import SwiftUI

struct CostView: View {
    @State var showingAddMemberView = false
    @State var showingAddCostItemView = false
    @StateObject var tripDataManager: TripDataManager
    @Binding var tripListIndex: Int?
    //add & edit costItemView 參數
    @State var itemName:String = ""
    @State var itemPrice:Float = 0.0
    @State var itemPaidMember:String = "付錢的爸爸是誰"
    @State var itemSharedMembers: [String] = []
    @State var costItemSwipeAction: SwipeBtnAction = .add
    @State var costItemActionEditIndex: Int? = nil
    @State var sharedMembersString: String = "欠錢的孩子"
    //add & edit member參數
    @State var tripMemberName:String=""
    @State var memberListSwipeAction: SwipeBtnAction = .add
    @State var memberListActionEditIndex: Int? = nil
    
    @State private var segmentedSelect = 0
    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-segmented-control-and-read-values-from-it
    //    note_segmented
    
    @State var showingPaidMemberList: Bool = false
    @State var costListFlowMember: String? = nil
    
    var body: some View {
        VStack {
            if tripListIndex != nil {
                VStack {
                    Picker("CostView Type?",selection: $segmentedSelect){
                        Text("拆帳表").tag(0)
                        Text("支出表").tag(1)
                    }
                    .pickerStyle(.segmented)
                }.padding()
                ZStack {
                    switch segmentedSelect {
                    case 0:
                        NavigationView {
                            List {
                                let sharedCostResults = tripDataManager.tripDataArray[tripListIndex!].getSharedCostResultsList()
                                ForEach(tripDataManager.tripDataArray[tripListIndex!].tripMembers) {
                                    tripMember in
                                    TripMemberRow(tripMember: tripMember, sharedCostResults: sharedCostResults)
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                if tripMember.price != 0 {
                                                    assertionFailure("欠錢還想跑")
                                                    return
                                                } else {
                                                    tripDataManager.removeMember(tripIndex: tripListIndex!, memberName: tripMember.memberName)
                                                }
                                            } label: {
                                                Text("Delete")
                                                    .foregroundColor(.white)
                                            }
                                            Button(role: .cancel) {
                                                if let index = tripDataManager.getMemberIndex(tripIndex: tripListIndex!, memberName: tripMember.memberName) {
                                                    let editMemberData = tripDataManager.tripDataArray[tripListIndex!].tripMembers[index]
                                                    tripMemberName = editMemberData.memberName
                                                    memberListSwipeAction = .edit
                                                    memberListActionEditIndex = index
                                                } else {
                                                    assertionFailure("..")
                                                }
                                                showingAddMemberView = true
                                            } label: {
                                                Text("Edit")
                                                    .foregroundColor(.white)
                                            }
                                            .tint(.gray)
                                        }
                                }
                            }
                            .navigationTitle("t")
                            .navigationBarHidden(true)
                        }.navigationViewStyle(StackNavigationViewStyle())
                    case 1:
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    showingPaidMemberList = true
                                } label: {
                                    if let costListFlowMember = costListFlowMember {
                                        Text("\(costListFlowMember)的支出")
                                            .padding(.trailing)
                                    } else {
                                        Text("大家的支出")
                                            .padding(.trailing)
                                    }
                                }
                            }
                            
                            NavigationView {
                                List {
                                    ForEach(tripDataManager.tripDataArray[tripListIndex!].costItems) { costItem in
                                        //                                    名稱,副標金額,付錢的是誰,欠債的是誰
                                        CostItemRow(costItem: costItem, costListFlowMember: $costListFlowMember)
                                            .swipeActions(edge: .trailing) {
                                                Button(role: .destructive) {
                                                    //刪除時要一併處理每個成員的金流
                                                    if let index = tripDataManager.getCostItemIndex(tripIndex: tripListIndex!, itemName: costItem.itemName) {
                                                        let _ = print(tripDataManager.tripDataArray[tripListIndex!].tripMembers)
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
                                                    
                                                    tripDataManager.removeCostItem(tripIndex: tripListIndex!, itemName: costItem.itemName)
                                                } label: {
                                                    Text("Delete")
                                                        .foregroundColor(.white)
                                                }
                                                Button(role: .cancel) {
                                                    if let index = tripDataManager.getCostItemIndex(tripIndex: tripListIndex!, itemName: costItem.itemName)
                                                    {
                                                        itemName = costItem.itemName
                                                        itemPrice = costItem.itemPrice
                                                        itemPaidMember = costItem.paidMember
                                                        itemSharedMembers = costItem.sharedMembers
                                                        costItemSwipeAction = .edit
                                                        costItemActionEditIndex = index
                                                        for selection in itemSharedMembers {
                                                            if itemSharedMembers.first == selection {
                                                                sharedMembersString = selection
                                                            } else {
                                                                sharedMembersString = sharedMembersString + ", " + selection
                                                            }
                                                        }
                                                    } else {
                                                        assertionFailure("編輯行程出包了.")
                                                    }
                                                    showingAddCostItemView = true
                                                } label: {
                                                    Text("Edit")
                                                        .foregroundColor(.white)
                                                }
                                                .tint(.gray)
                                            }
                                    }
                                    if let index = tripListIndex {
                                        VStack(alignment: .leading){
                                            Text("Total")
                                                .font(.system(.body, design: .rounded))
                                                .bold()
                                            Text("$: \(tripDataManager.getTotalCost(tripIndex: index, paidMemberName: costListFlowMember), specifier: "%.2f")")
                                                .font(.system(.subheadline, design: .rounded))
                                                .bold()
                                                .foregroundColor(.secondary)
                                                .lineLimit(3)
                                        }
                                    }
                                }
                                .navigationTitle("t")
                                .navigationBarHidden(true)
                            }.navigationViewStyle(StackNavigationViewStyle())
                        }
                        
                    default:
                        Text("怎麼了你累了")
                    }
                }
                
                HStack{
                    Spacer()
                    //加入小夥伴的按鈕
                    Button {
                        memberListSwipeAction = .add
                        memberListActionEditIndex = nil
                        showingAddMemberView = true
                        //alert
                    } label: {
                        VStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .resizable()
                                .foregroundColor(.green)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                            Text("新增小夥伴")
                                .foregroundColor(.green)
                        }
                    }
                    Spacer()
                    //加入開銷的按鈕//注意這邊要選擇分攤的人有哪些
                    Button {
                        itemName = ""
                        itemPrice = 0.0
                        itemPaidMember = "付錢的爸爸是誰"
                        itemSharedMembers = []
                        costItemSwipeAction = .add
                        sharedMembersString = "欠錢的孩子"
                        costItemActionEditIndex = nil
                        showingAddCostItemView = true
                    } label: {
                        VStack {
                            Image(systemName: "cart.badge.plus")
                                .resizable()
                                .foregroundColor(.green)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                            Text("新增支出項目")
                                .foregroundColor(.green)
                        }
                    }
                    Spacer()
                }
            } else {
                Spacer()
                Text("請先新增旅程")
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showingAddMemberView) {
            self.showingAddMemberView = false
        } content: {
            AddMemberView(tripMemberName: $tripMemberName, tripDataManager: tripDataManager, tripListIndex: $tripListIndex,memberListSwipeAction:$memberListSwipeAction, memberListActionEditIndex:$memberListActionEditIndex)
        }
        .fullScreenCover(isPresented: $showingAddCostItemView) {
            self.showingAddCostItemView = false
        } content: {
            AddCostItemView(
                tripDataManager: tripDataManager,
                tripListIndex: $tripListIndex,
                itemName: $itemName,
                itemPrice: $itemPrice,
                itemPaidMember: $itemPaidMember,
                itemSharedMembers: $itemSharedMembers,
                costItemSwipeAction: $costItemSwipeAction,
                costItemActionEditIndex: $costItemActionEditIndex,
                sharedMembersString: $sharedMembersString
            )
        }
        .confirmationDialog("test", isPresented: $showingPaidMemberList) {
//            ForEach(Array(tripDataManager.tripDataArray.enumerated()), id: \.offset) { index, tripData in
//                Button {
//                    //fixme切換旅程資料
//                    tripListIndex = index
//                } label: {
//                    Text(tripData.tripName)
//                }
//            }
            if let tripListIndex = tripListIndex {
                ForEach(tripDataManager.tripDataArray[tripListIndex].tripMembers) {
                    tripMember in
                    Button {
                        costListFlowMember = tripMember.memberName
                    } label: {
                        Text(tripMember.memberName)
                    }
                }
                
                Button {
                    costListFlowMember = nil
                    showingPaidMemberList = false
                } label: {
                    Text("全部")
                }
            }
        }
    }
}

//struct CostView_Previews: PreviewProvider {
//    static var previews: some View {
//        CostView()
//    }
//}

struct CostItemRow: View {
    var costItem: CostItem
    @Binding var costListFlowMember: String?
    var body: some View {
        if costListFlowMember == nil || costItem.paidMember == costListFlowMember {
            VStack(alignment: .leading){
                Text(costItem.itemName)
                    .font(.system(.body, design: .rounded))
                    .bold()
                Text("$: \(costItem.itemPrice)" + ", " + "付錢的家長: " + costItem.paidMember)
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                Text("欠錢的孩子: " + costItem.getSharedMembersString())
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
    }
}

struct TripMemberRow: View {
    var tripMember:TripMember
    var sharedCostResults: [SharedCostResults]
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(tripMember.memberName)
                    .font(.system(.body, design: .rounded))
                    .bold()
                if tripMember.price == 0 {
                    Text("收支平衡")
                        .font(.system(.subheadline, design: .rounded))
                        .bold()
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                } else if tripMember.price > 0 {
                    Text("墊$:\(tripMember.price, specifier: "%.2f") 未收")
                        .font(.system(.subheadline, design: .rounded))
                        .bold()
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    //                                            https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/swiftui-控制浮點數顯示的-string-interpolation-7944a57418dd
                    //                                                note_float to string 小數點後控制
                } else {
                    ForEach(sharedCostResults){
                        sharedCostResult in
                        if sharedCostResult.oweder == tripMember.memberName && sharedCostResult.price > 0{
                            Text("欠\(sharedCostResult.owner) $:\(sharedCostResult.price, specifier: "%.2f")")
                                .font(.system(.subheadline, design: .rounded))
                                .bold()
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                        }
                    }
                }
            }
            Spacer()
            //                .layoutPriority(-100)
        }
    }
}
