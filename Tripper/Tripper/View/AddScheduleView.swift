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
                    let scheduleNameData = ScheduleData(scheduleName: scheduleName, startDate: startTime, endDate: endTime)
                    print("add sechedule")
                } label: {
                    Text("加入")
                        .padding()
                }
            }
            Form {
                TextField("標題", text: $scheduleName)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                DatePicker("起始時間", selection: $startTime)
                DatePicker("結束時間", selection: $endTime)
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
