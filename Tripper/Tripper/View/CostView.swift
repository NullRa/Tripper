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
    
    @State private var segmentedSelect = 0
    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-segmented-control-and-read-values-from-it
    //    note_segmented
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
                            .navigationTitle("t")
                            .navigationBarHidden(true)
                        }.navigationViewStyle(StackNavigationViewStyle())
                    case 1:
                        NavigationView {
                            List {
                                ForEach(tripDataManager.tripDataArray[tripListIndex!].costItems) { costItem in
                                    //                                    名稱,副標金額,付錢的是誰,欠債的是誰
                                    CostItemRow(costItem: costItem)
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
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
                            }
                            .navigationTitle("t")
                            .navigationBarHidden(true)
                        }.navigationViewStyle(StackNavigationViewStyle())
                    default:
                        Text("怎麼了你累了")
                    }
                }
                
                HStack{
                    Spacer()
                    //加入小夥伴的按鈕
                    Button {
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
            AddMemberView(tripDataManager: tripDataManager, tripListIndex: $tripListIndex)
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
                costItemActionEditIndex: $costItemActionEditIndex
            )
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
    var body: some View {
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
