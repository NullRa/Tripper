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
                                        ScheduleData(scheduleName: "Schedule1", startDate: Date(), endDate: Date()),
                                        ScheduleData(scheduleName: "Schedule2", startDate: Date(), endDate: Date()),
                                        ScheduleData(scheduleName: "Schedule3", startDate: Date(), endDate: Date())
                                      ]
    )
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(Array(tripData.getScheduleDataFlowByDateDict().keys), id: \.self) {
//                        _ in
                        //                        key, value in
                        //                        Section(header: Text(key)) {
                        ////                            Text(value)
                        //                        }
                        Section {
                            
                        } header: {
                            Text($0.date)
                        }

                    }
                    //                    Section {
                    //                        ForEach(tripData.scheduleDataArray) { scheduleData in
                    //                            ScheduleRow(scheduleData: scheduleData)
                    //                        }
                    //                    } header: {
                    //                        Text("test")
                    //                    }
                    
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
    var scheduleData: ScheduleData
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(scheduleData.scheduleName)
                    .font(.system(.body, design: .rounded))
                    .bold()
                
                Text(scheduleData.getStartTimeString() + " ~ " + scheduleData.getEndTimeString())
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

//


