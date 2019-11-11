//
//  Task.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 11.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import Foundation

struct Task {
    let name: String
    let length: TimeInterval

    func register() {
        NSLog("\(name) is being scheduled")
    }

    func run() {
        NSLog("\(name) started")
        usleep(UInt32(length * 1_000_000))
        NSLog("\(name) finished")
    }
}
