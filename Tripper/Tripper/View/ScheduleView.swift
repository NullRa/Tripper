//
//  ScheduleView.swift
//  Tripper
//
//  Created by Apple on 2022/8/1.
//

import SwiftUI

struct ScheduleView: View {
    @Binding var showingAddScheduleView:Bool
    var body: some View {
        VStack {
            Spacer()
            Text("Schedule View")
            Spacer()
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
