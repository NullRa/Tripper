//
//  AddScheduleView.swift
//  Tripper
//
//  Created by Apple on 2022/8/3.
//

import SwiftUI

struct AddScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @State var scheduleName:String = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var schedulDate = Date()
    @StateObject var tripDataManager: TripDataManager
    @Binding var tripListIndex: Int?
    
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
                Text("新增行程")
                    .font(.title)
                    .padding()
                Spacer()
                Button {
                    let scheduleData = ScheduleData(scheduleName: scheduleName, scheduleDate: schedulDate, scheduleStartTime: startTime, scheduleEndTime: endTime)
                    //如果tripListIndex等於nil不會進入到這個頁面可以果斷使用!，邏輯是tripListIndex==nil，ScheduleView不會出現add schedule的按鈕，沒有點擊add schedule的按鈕不會進入此頁面。
                    //保險起見
                    if tripListIndex != nil {
                        tripDataManager.tripDataArray[tripListIndex!].scheduleDataArray.append(scheduleData)
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
                TextField("標題", text: $scheduleName)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                //                https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/ios-14-變成月曆的-date-picker-
                //                note_datapicker用法
                DatePicker("日期", selection: $schedulDate, displayedComponents: .date)
                DatePicker("起始時間", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("結束時間", selection: $endTime, displayedComponents: .hourAndMinute)
            }
            .listStyle(InsetGroupedListStyle())
            //            https://stackoverflow.com/questions/67515632/swiftui-detected-a-case-where-constraints-ambiguously-suggest-a-height-of-zero
            //            note_若使用form會出現log錯誤
        }
    }
}

//struct AddScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        //        AddScheduleView(tripName: "test")
//        AddScheduleView()
//    }
//}
