//
//  ContentViewModel.swift
//  Tripper
//
//  Created by Apple on 2022/8/2.
//

import Foundation

class ContentViewModel: ObservableObject {
    static let shared = ContentViewModel()
    let userDefaultsManager = UserDefaultsManager.shared
    var tripList:[String]
    init(){
        if let list = userDefaultsManager.loadTripProjectArray() {
            tripList = list
        } else {
            tripList = []
        }
    }
    func addTrip(tripName:String){
        tripList.append(tripName)
        userDefaultsManager.saveTripProjectArray(list: tripList)
    }
    func deleteTrip(index:Int){
        tripList.remove(at: index)
        userDefaultsManager.saveTripProjectArray(list: tripList)
    }
}


