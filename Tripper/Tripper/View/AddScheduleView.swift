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
                    let scheduleNameData = ScheduleData(scheduleName: scheduleName, scheduleDate: schedulDate, scheduleStartTime: startTime, scheduleEndTime: endTime)
                    print("add sechedule")
                } label: {
                    Text("加入")
                        .padding()
                }
            }
            Form {
                TextField("標題", text: $scheduleName)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                //                https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/ios-14-變成月曆的-date-picker-
                //                note_datapicker用法
                DatePicker("日期", selection: $schedulDate, displayedComponents: .date)
                DatePicker("起始時間", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("結束時間", selection: $endTime, displayedComponents: .hourAndMinute)
            }
        }
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        //        AddScheduleView(tripName: "test")
        AddScheduleView()
    }
}
