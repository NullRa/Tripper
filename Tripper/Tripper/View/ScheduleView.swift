//
//  ScheduleView.swift
//  Tripper
//
//  Created by Apple on 2022/8/1.
//

import SwiftUI
enum ScheduleAction: Int{
    case add,edit
}
struct ScheduleView: View {
    
    @State var showingAddScheduleView = false
    @StateObject var tripDataManager: TripDataManager
    @Binding var tripListIndex: Int?
    @State var scheduleName: String = ""
    @State var startTime:Date = Date()
    @State var endTime:Date = Date()
    @State var schedulDate:Date = Date()
    @State var scheduleAction: ScheduleAction = .add
    @State var scheduleActionEditIndex: Int? = nil
    
    var body: some View {
        VStack {
            if tripListIndex != nil {
                NavigationView {
                    List {
                        ForEach(tripDataManager.tripDataArray[tripListIndex!].getScheduleInDateList()) { scheduleInDateList in
                            Section {
                                ForEach(scheduleInDateList.schedule_in_date_list) { schedule in
                                    ScheduleRow(scheduleInDate: schedule)
                                    //note_swipe_delete滑動刪除功能
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                tripDataManager.removeSchedule(tripIndex: tripListIndex!, scheduleName: schedule.schedule_name)
                                            } label: {
                                                Text("Delete")
                                                    .foregroundColor(.white)
                                            }
                                            Button(role: .cancel) {
                                                if let index = tripDataManager.getScheduleIndex(tripIndex: tripListIndex!, scheduleName: schedule.schedule_name)
                                                {
                                                    let editScheduleData = tripDataManager.tripDataArray[tripListIndex!].scheduleDataArray[index]
                                                    scheduleName = editScheduleData.scheduleName
                                                    startTime = editScheduleData.scheduleStartTime
                                                    endTime = editScheduleData.scheduleEndTime
                                                    schedulDate = editScheduleData.scheduleDate
                                                    scheduleAction = .edit
                                                    scheduleActionEditIndex = index
                                                } else {
                                                    assertionFailure("編輯行程出包了.")
                                                }
                                                showingAddScheduleView = true
                                            } label: {
                                                Text("Edit")
                                                    .foregroundColor(.white)
                                            }
                                            .tint(.gray)
                                        }
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
                        scheduleName = ""
                        startTime = Date()
                        endTime = Date()
                        schedulDate = Date()
                        scheduleAction = .add
                        scheduleActionEditIndex = nil
                        showingAddScheduleView = true
                    } label: {
                        VStack {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .foregroundColor(.green)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                            Text("新增行程")
                                .foregroundColor(.green)
                        }.padding(.trailing)
                    }
                }
            } else {
                Spacer()
                Text("請先新增旅程")
                Spacer()
            }
            
            
        }
        .fullScreenCover(isPresented: $showingAddScheduleView) {
            showingAddScheduleView = false
        } content: {
            AddScheduleView(
                tripDataManager: tripDataManager,
                tripListIndex: $tripListIndex,
                scheduleName: $scheduleName,
                startTime: $startTime,
                endTime: $endTime,
                schedulDate: $schedulDate,
                scheduleAction: $scheduleAction,
                editIndex: $scheduleActionEditIndex
            )
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
