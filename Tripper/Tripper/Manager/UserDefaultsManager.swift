//
//  UserDefaultsManager.swift
//  Tripper
//
//  Created by Apple on 2022/8/1.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
//    func saveMediaIcons(iconsDict: [String:String]){
//        UserDefaults.standard.set(iconsDict, forKey: "SavedMediaIcons")
//    }
//    func loadMediaIcons() -> [String:String]{
//        return UserDefaults.standard.value(forKey: "SavedMediaIcons") as? [String:String] ?? [:]
//    }
//    
//    func saveTripProjectArray(list:[String]){
//        UserDefaults.standard.set(list, forKey: "SavedTripProjectList")
//    }
//    func loadTripProjectArray() -> [String]? {
//        if let saveTripProjectArray = UserDefaults.standard.object(forKey: "SavedTripProjectList") as? [String] {
//            return saveTripProjectArray
//        }
//        return nil
//    }
//    
//    func saveScheduleArray(scheduleNameDatas: [ScheduleData]){
//        if let encoded = try? JSONEncoder().encode(scheduleNameDatas) {
//            UserDefaults.standard.set(encoded, forKey: "SavedScheduleNameDataArray")
//        }
//    }
//    func loadScheduleArray() -> [ScheduleData]? {
//        if let savedScheduleArray = UserDefaults.standard.object(forKey: "SavedScheduleNameDataArray") as? Data {
//            let decoder = JSONDecoder()
//            return try? decoder.decode([ScheduleData].self, from: savedScheduleArray)
//        }
//        return nil
//    }
    
    func saveTripDataArray(tripDataArray: [TripData]){
        if let encoded = try? JSONEncoder().encode(tripDataArray) {
            UserDefaults.standard.set(encoded, forKey: "SavedTripDataArray")
        }
    }
    func loadTripDataArray() -> [TripData]? {
        if let savedTripDataArray = UserDefaults.standard.object(forKey: "SavedTripDataArray") as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode([TripData].self, from: savedTripDataArray)
        }
        return nil
    }
}
