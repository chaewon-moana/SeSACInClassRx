//
//  TODO.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import Foundation

struct TODO {
    let id: UUID
    var checkBox: Bool
    var todo: String
    var star: Bool
    
    init(todo: String) {
        self.id = UUID()
        self.checkBox = false
        self.todo = todo
        self.star = false
    }
}

class TableData {
    static let shared = TableData()
    var tableData: [TODO] = [
    TODO(todo: "123"),
    TODO(todo: "444"),
    TODO(todo: "555")
    ]
    
    private init() { }
}
