//
//  AddMemberView.swift
//  Tripper
//
//  Created by Apple on 2022/8/9.
//

import SwiftUI

struct AddMemberView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tripMemberName:String
    @StateObject var tripDataManager: TripDataManager
    @Binding var tripListIndex: Int?
    @Binding var memberListSwipeAction: SwipeBtnAction
    @Binding var memberListActionEditIndex: Int?
    
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
                Text("新增夥伴")
                    .font(.title)
                    .padding()
                Spacer()
                Button {
                    let tripMember = TripMember(memberName:tripMemberName, price: 0)
                    //如果tripListIndex等於nil不會進入到這個頁面可以果斷使用!，邏輯是tripListIndex==nil，ScheduleView不會出現add的按鈕，沒有點擊add的按鈕不會進入此頁面。
                    //保險起見
                    if tripListIndex != nil {
                        if memberListSwipeAction == .add {
                            tripDataManager.tripDataArray[tripListIndex!].tripMembers.append(tripMember)
                        }
                        if memberListSwipeAction == .edit, let index = memberListActionEditIndex {
                            tripDataManager.tripDataArray[tripListIndex!].tripMembers[index].memberName = tripMemberName
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
            List {
                TextField("夥伴名稱", text: $tripMemberName)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
            }.listStyle(InsetGroupedListStyle())
        }
    }
}

//struct AddMemberView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMemberView()
//    }
//}
