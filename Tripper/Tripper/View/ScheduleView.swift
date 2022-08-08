//
//  ScheduleView.swift
//  Tripper
//
//  Created by Apple on 2022/8/1.
//

import SwiftUI

struct ScheduleView: View {
    @Binding var showingAddScheduleView:Bool
    
    var tripData: TripData = TripData(tripName: "Test Trip",
                                      scheduleDataArray: [
                                        ScheduleData(scheduleName: "S1", scheduleDate: Date(), scheduleStartTime: Date(), scheduleEndTime: Date()),
                                        ScheduleData(scheduleName: "S2", scheduleDate: Date(), scheduleStartTime: Date(), scheduleEndTime: Date()),
                                        ScheduleData(scheduleName: "S3", scheduleDate: Date(), scheduleStartTime: Date(), scheduleEndTime: Date())
                                      ]
    )
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(tripData.getScheduleInDateList()) { scheduleInDateList in
                        Section {
                            ForEach(scheduleInDateList.schedule_in_date_list) { schedule in
                                ScheduleRow(scheduleInDate: schedule)
                            }
                        } header: {
                            Text(scheduleInDateList.schedule_date)
                        }
                        
                    }
                }.navigationTitle(tripData.tripName)
            }
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
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(showingAddScheduleView: .constant(false))
    }
}

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
