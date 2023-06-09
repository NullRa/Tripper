//
//  ExtensionString.swift
//  Tripper
//
//  Created by Apple on 2022/8/18.
//

import Foundation

extension String: Identifiable {
    //note_讓String可以進array
    //https://stackoverflow.com/questions/67977092/swiftui-initialzier-requires-string-conform-to-identifiable
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
