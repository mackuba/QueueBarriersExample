//
//  Task.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 11.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import Foundation

var idGenerator: Int = 0

class Task: Hashable {
    static func == (left: Task, right: Task) -> Bool {
        return left.id == right.id
    }

    enum Status {
        case waiting
        case active
        case finished
    }

    static let taskStatusChanged = NSNotification.Name("taskStatusChanged")

    let id: Int
    let name: String
    let length: TimeInterval
    let isBlocking: Bool
    var status: Status = .waiting

    init(name: String, length: TimeInterval, isBlocking: Bool = false) {
        idGenerator += 1

        self.id = idGenerator
        self.name = name
        self.length = length
        self.isBlocking = isBlocking
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func register() {
        NSLog("\(name) is being scheduled")
    }

    func run() {
        self.status = .active
        NSLog("\(name) started")
        NotificationCenter.default.post(name: Task.taskStatusChanged, object: self)

        usleep(UInt32(length * 1_000_000))

        self.status = .finished
        NSLog("\(name) finished")
        NotificationCenter.default.post(name: Task.taskStatusChanged, object: self)
    }
}
