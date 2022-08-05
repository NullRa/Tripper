//
//  TripDataManager.swift
//  Tripper
//
//  Created by Apple on 2022/8/3.
//

import Foundation
//import SwiftUI

struct TripData: Codable {
    var tripName: String
    var scheduleDataArray: [ScheduleData] = []
    
    func getScheduleDataFlowByDateDict() -> [String:[ScheduleDataFlowByDate]]{
        var scheduleDataFlowByDateDict: [String:[ScheduleDataFlowByDate]] = [:]
        for scheduleData in scheduleDataArray {
            let newData = ScheduleDataFlowByDate(date: scheduleData.getDateString(),
                                                 scheduleName: scheduleData.scheduleName,
                                                 startTime: scheduleData.getStartTimeString(),
                                                 endTime: scheduleData.getEndTimeString())
            if let _ = scheduleDataFlowByDateDict[scheduleData.getDateString()] {
                var dataArray = scheduleDataFlowByDateDict[scheduleData.getDateString()]!
                dataArray.append(newData)
                scheduleDataFlowByDateDict[scheduleData.getDateString()] = dataArray
            } else {
                scheduleDataFlowByDateDict[scheduleData.getDateString()] = [newData]
            }
        }
        return scheduleDataFlowByDateDict
    }
}

struct ScheduleDataFlowByDate {
    var date: String
    var scheduleName:String
    var startTime: String
    var endTime: String
}

struct ScheduleData: Codable, Identifiable {
    var id = UUID()
    var scheduleName: String
    var startDate: Date
    var endDate: Date
//    https://ithelp.ithome.com.tw/articles/10205438
//    note_日期格式使用
    func getDateString() -> String{
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: startDate)
        return date
    }
//    func getStartDateString() -> String{
//        let timeZone = NSTimeZone.local
//        let formatter = DateFormatter()
//        formatter.timeZone = timeZone
//        formatter.dateFormat = "yyyy-MM-dd"
//        let date = formatter.string(from: startDate)
//        return date
//    }
    func getStartTimeString() -> String{
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        let date = formatter.string(from: startDate)
        return date
    }
//    func getEndDateString() -> String{
//        let timeZone = NSTimeZone.local
//        let formatter = DateFormatter()
//        formatter.timeZone = timeZone
//        formatter.dateFormat = "yyyy-MM-dd"
//        let date = formatter.string(from: endDate)
//        return date
//    }
    func getEndTimeString() -> String{
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        let date = formatter.string(from: endDate)
        return date
    }
}

class TripDataManager: ObservableObject {
    static let shared = TripDataManager()
    let userDefaultsManager = UserDefaultsManager.shared
    var tripDataArray:[TripData]
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
}

