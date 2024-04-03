//
//  TODO.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import Foundation

struct TODO {
    var checkBox: Bool
    var todo: String
    var star: Bool
}

class TableData {
    static var tableData = [
        TODO(checkBox: false, todo: "테에스트으1", star: false),
        TODO(checkBox: false, todo: "테에스트으2", star: false),
        TODO(checkBox: false, todo: "테에스트으3", star: false)
    ]

}
