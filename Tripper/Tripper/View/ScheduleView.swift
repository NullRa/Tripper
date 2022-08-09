//
//  ScheduleView.swift
//  Tripper
//
//  Created by Apple on 2022/8/1.
//

import SwiftUI

struct ScheduleView: View {
    @Binding var showingAddScheduleView:Bool
    @StateObject var tripDataManager: TripDataManager
    @Binding var tripListIndex: Int?
    var body: some View {
        VStack {
            if tripListIndex != nil {
                NavigationView {
                    List {
                        ForEach(tripDataManager.tripDataArray[tripListIndex!].getScheduleInDateList()) { scheduleInDateList in
                            Section {
                                ForEach(scheduleInDateList.schedule_in_date_list) { schedule in
                                    ScheduleRow(scheduleInDate: schedule)
                                }
                            } header: {
                                Text(scheduleInDateList.schedule_date)
                            }
                        }
                    }
                    .navigationTitle(tripDataManager.tripDataArray[tripListIndex!].tripName)
                    .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                //                .navigationViewStyle(StackNavigationViewStyle())修正log錯誤
                //            note_https://stackoverflow.com/questions/65316497/swiftui-navigationview-navigationbartitle-layoutconstraints-issue
                HStack{
                    Spacer()
                    Button {
                        showingAddScheduleView = true
                    } label: {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width:80, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .overlay(content: {
                                        Text("A")
                                            .foregroundColor(.red)
                                            .font(.title)
                                    })
                            )
                    }
                }
            } else {
                Spacer()
                Text("請先新增旅程")
                Spacer()
            }
            
            
        }
    }
}

//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleView(showingAddScheduleView: .constant(false), tripDataManager: TripDataManager())
//    }
//}

struct ScheduleRow: View {
    var scheduleInDate: ScheduleInDate
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(scheduleInDate.schedule_name)
                    .font(.system(.body, design: .rounded))
                    .bold()
                
                Text(scheduleInDate.schedule_start_time + " ~ " + scheduleInDate.schedule_end_time)
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            Spacer()
            //                .layoutPriority(-100)
        }
    }
}
