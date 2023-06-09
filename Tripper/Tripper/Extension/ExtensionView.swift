//
//  ExtensionView.swift
//  Tripper
//
//  Created by Apple on 2022/8/18.
//

import Foundation
import SwiftUI

extension View {
    //note_alert textfield
    //https://stackoverflow.com/questions/72446462/showing-textfield-in-alert-function-at-swiftui
    public func textFieldAlert(
        isPresented: Binding<Bool>,
        title:String,
        text:Binding<String>,
        placeholder:String="",
        action:@escaping (String) -> Void
    ) -> some View {
        self.modifier(TextFieldAlert(isPresented: isPresented, title: title, text: text, placeholder: placeholder, action: action))
    }
}
