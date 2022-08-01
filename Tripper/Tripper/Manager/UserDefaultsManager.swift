//
//  UserDefaultsManager.swift
//  Tripper
//
//  Created by Apple on 2022/8/1.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    func saveMediaIcons(iconsDict: [String:String]){
        UserDefaults.standard.set(iconsDict, forKey: "SavedMediaIcons")
    }
    
    func loadMediaIcons() -> [String:String]{
        return UserDefaults.standard.value(forKey: "SavedMediaIcons") as? [String:String] ?? [:]
    }
    
//    func saveMemberInfo(memberInfo: CamerabayMemberInfo) {
//        if let encoded = try? JSONEncoder().encode(memberInfo) {
//            UserDefaults.standard.set(encoded, forKey: "SavedMemberInfo")
//        }
//    }
//
//    func loadMemberInfo() -> CamerabayMemberInfo? {
//        if let savedMemberInfo = UserDefaults.standard.object(forKey: "SavedMemberInfo") as? Data {
//            let decoder = JSONDecoder()
//            return try? decoder.decode(CamerabayMemberInfo.self, from: savedMemberInfo)
//        }
//        return nil
//    }
    
    func saveTripProjectArray(list:[String]){
        UserDefaults.standard.set(list, forKey: "TripProjectList")
    }
    func loadTripProjectArray() -> [String]? {
        if let saveTripProjectArray = UserDefaults.standard.object(forKey: "TripProjectList") as? [String] {
            return saveTripProjectArray
        }
        return nil
    }
}

/*
 let array = ["Hello", "Swift"]
 defaults.set(array, forKey: "SavedArray")

 let dict = ["Name": "Jack", "Country": "Tw"]
 defaults.set(dict, forKey: "SavedDict")
 
 object(forKey:) returns AnyObject? so you need to conditionally typecast it to your data type.
 */
