//
//  CostView.swift
//  Tripper
//
//  Created by Apple on 2022/8/1.
//

import SwiftUI

struct CostView: View {
    @Binding var showingAddMemberView:Bool
    @Binding var showingAddCostItemView:Bool
    @StateObject var tripDataManager: TripDataManager
    @Binding var tripListIndex: Int?
    var body: some View {
        VStack {
            if tripListIndex != nil {
                NavigationView {
                    List {
                        ForEach(tripDataManager.tripDataArray[tripListIndex!].getSharedCostResultsList()) { sharedCostResult in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(sharedCostResult.oweder)
                                        .font(.system(.body, design: .rounded))
                                        .bold()
                                    if sharedCostResult.owner == "noOwner" {
                                        Text("尚未有消費")
                                            .font(.system(.subheadline, design: .rounded))
                                            .bold()
                                            .foregroundColor(.secondary)
                                            .lineLimit(3)
                                    } else {
                                        Text("欠" + sharedCostResult.owner + "$:\(sharedCostResult.price)")
                                            .font(.system(.subheadline, design: .rounded))
                                            .bold()
                                            .foregroundColor(.secondary)
                                            .lineLimit(3)
                                    }
                                }
                                
                                Spacer()
                                //                .layoutPriority(-100)
                            }
                        }
                    }
                    .navigationTitle("t")
                    .navigationBarHidden(true)
                }.navigationViewStyle(StackNavigationViewStyle())
                
                
                HStack{
                    Spacer()
                    //加入小夥伴的按鈕
                    Button {
                        showingAddMemberView = true
                        //alert
                    } label: {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width:80, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .overlay(content: {
                                        Text("B")
                                            .foregroundColor(.red)
                                            .font(.title)
                                    })
                            )
                    }
                    Spacer()
                    //加入開銷的按鈕//注意這邊要選擇分攤的人有哪些
                    Button {
                        showingAddCostItemView = true
                    } label: {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width:80, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .overlay(content: {
                                        Text("C")
                                            .foregroundColor(.red)
                                            .font(.title)
                                    })
                            )
                    }
                    Spacer()
                }
            } else {
                Spacer()
                Text("請先新增旅程")
                Spacer()
            }
        }
    }
}

//struct CostView_Previews: PreviewProvider {
//    static var previews: some View {
//        CostView()
//    }
//}
