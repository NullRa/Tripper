//
//  TripDataManager.swift
//  Tripper
//
//  Created by Apple on 2022/8/3.
//

import Foundation

struct TripData: Codable {
    var tripName: String
    var scheduleDataArray: [ScheduleData]
    func getScheduleInDateList() -> [ScheduleInDateList] {
        var scheduleInDateList:[ScheduleInDateList] = []
        //        https://ithelp.ithome.com.tw/articles/10267421
        //        note_outerloop說明,跳出最外層迴圈
    outerloop:for scheduleData in scheduleDataArray {
        let date = scheduleData.getDateString()
        let startTime = scheduleData.getStartTimeString()
        let endTime = scheduleData.getEndTimeString()
        let name = scheduleData.scheduleName
        let newData = ScheduleInDate(schedule_name: name, schedule_start_time: startTime, schedule_end_time: endTime)
        
        for i in 0 ..< scheduleInDateList.count {
            if scheduleInDateList[i].schedule_date == date {
                scheduleInDateList[i].schedule_in_date_list.append(newData)
                continue outerloop
            }
        }
        let newlistData = ScheduleInDateList(schedule_date: date, schedule_in_date_list: [newData])
        scheduleInDateList.append(newlistData)
    }
        return scheduleInDateList
    }
}

struct ScheduleData: Codable, Identifiable {
    var id = UUID()
    var scheduleName: String
    var scheduleDate: Date
    var scheduleStartTime: Date
    var scheduleEndTime: Date
    //    https://ithelp.ithome.com.tw/articles/10205438
    //    note_日期格式使用
    func getDateString() -> String{
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: scheduleDate)
        return date
    }
    
    func getStartTimeString() -> String{
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        let date = formatter.string(from: scheduleStartTime)
        return date
    }
    
    func getEndTimeString() -> String{
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        let date = formatter.string(from: scheduleEndTime)
        return date
    }
}

struct ScheduleInDateList: Identifiable {
    var id = UUID()
    var schedule_date: String
    var schedule_in_date_list: [ScheduleInDate]
}
struct ScheduleInDate: Identifiable {
    var id = UUID()
    var schedule_name: String
    var schedule_start_time: String
    var schedule_end_time: String
}

class TripDataManager: ObservableObject {
    static let shared = TripDataManager()
    let userDefaultsManager = UserDefaultsManager.shared
    @Published var tripDataArray:[TripData]
    init(){
        if let tripDatas = userDefaultsManager.loadTripDataArray() {
            tripDataArray = tripDatas
        } else {
            tripDataArray = []
        }
    }
    func addTrip(tripName:String){
        let tripData = TripData(tripName: tripName, scheduleDataArray: [])
        tripDataArray.append(tripData)
        userDefaultsManager.saveTripDataArray(tripDataArray: tripDataArray)
    }
    func deleteTrip(index:Int){
        tripDataArray.remove(at: index)
        userDefaultsManager.saveTripDataArray(tripDataArray: tripDataArray)
    }
    func updateTrip(){
        userDefaultsManager.saveTripDataArray(tripDataArray: tripDataArray)
    }
}

