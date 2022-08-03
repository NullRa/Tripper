//
//  TripDataManager.swift
//  Tripper
//
//  Created by Apple on 2022/8/3.
//

import Foundation

struct TripData: Codable {
    var tripName: String
    var scheduleDataArray: [ScheduleData] = []
}

struct ScheduleData: Codable {
    var scheduleName: String
    var startTime: Date
    var endTime: Date
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

