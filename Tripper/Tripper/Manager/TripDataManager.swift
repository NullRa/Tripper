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
    var tripMembers: [TripMember]
    var costItems: [CostItem]
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
    
    func getSharedCostResultsList() -> [SharedCostResults]{
        //透過整理members的資料,回傳一個陣列,每個成員該付誰多少錢
        var sharedCostResults = [SharedCostResults]()
        var ownerMembers: [TripMember] = []
        let tempTripMembers = tripMembers.sorted { data1, data2 in
            return data1.price > data2.price
        }
        for tripMember in tempTripMembers {
            if tripMember.price >= 0 {
                ownerMembers.append(tripMember)
            } else {
                var owedPrice = -tripMember.price
                for i in 0 ..< ownerMembers.count {
                    if (ownerMembers[i].price - owedPrice) >= 0 {
                        ownerMembers[i].price = ownerMembers[i].price - owedPrice
                        let sharedCostResult = SharedCostResults(oweder: tripMember.memberName, owner: ownerMembers[i].memberName, price: owedPrice)
                        sharedCostResults.append(sharedCostResult)
                        owedPrice = 0
                        break
                    } else {
                        let sharedCostResult = SharedCostResults(oweder: tripMember.memberName, owner: ownerMembers[i].memberName, price: ownerMembers[i].price)
                        sharedCostResults.append(sharedCostResult)
                        owedPrice = owedPrice - ownerMembers[i].price
                        ownerMembers[i].price = 0
                    }
                    //                    Cost      a            b        c        d
                    //                    400       400-100      -100     -100     -100
                    //                    300       -75          300-75   -75      -75
                    //                    800       800-200      -200     -200     -200
                    //                    800       -200         800-200  -200     -200
                    //                    Sum       625          525      -575     -575
                }
            }
        }
        
        if sharedCostResults.isEmpty {
            for tripMember in tripMembers {
                let sharedCostResult = SharedCostResults(oweder: tripMember.memberName, owner: "noOwner", price: 0)
                sharedCostResults.append(sharedCostResult)
            }
        }
        
        //        note_錢多的往前排序..陣列排序
        //        https://franksios.medium.com/swift3-高階函數-higher-order-function-a97cf4577a11
        sharedCostResults.sort { data1, data2 in
            return data1.price > data2.price
        }
        return sharedCostResults
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

struct TripMember: Codable,Identifiable {
    var id = UUID()
    var memberName: String
    var price: Float
}

struct CostItem: Codable, Identifiable {
    var id = UUID()
    var itemName: String
    var itemPrice: Float
    var paidMember: String//墊錢的爸爸
    var sharedMembers: [String]//被照顧得有誰
    
    func getSharedMembersString() -> String {
        var str = ""
        if sharedMembers.isEmpty {return str}
        for sharedMember in sharedMembers {
            if sharedMember == sharedMembers.first {
                str = sharedMember
            } else {
                str = str + ", " + sharedMember
            }
        }
        return str
    }
}

struct SharedCostResults: Identifiable {
    var id = UUID()
    var oweder: String
    var owner: String
    var price: Float
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
        let tripData = TripData(tripName: tripName, scheduleDataArray: [], tripMembers: [], costItems: [])
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
    func removeSchedule(tripIndex:Int,scheduleName:String){
        let index = getScheduleIndex(tripIndex: tripIndex, scheduleName: scheduleName)
        if let index = index {
            tripDataArray[tripIndex].scheduleDataArray.remove(at: index)
            updateTrip()
        } else {
            assertionFailure("wtf")
        }
        
    }
    
    func getScheduleIndex(tripIndex:Int,scheduleName:String) -> Int?{
        let tempArray = tripDataArray[tripIndex].scheduleDataArray
        for i in 0..<tempArray.count {
            if tempArray[i].scheduleName == scheduleName {
                return i
            }
        }
        return nil
    }
}

