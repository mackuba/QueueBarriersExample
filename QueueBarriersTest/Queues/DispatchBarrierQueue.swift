//
//  DispatchGroupQueue.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 10.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import Foundation

class DispatchBarrierQueue: TaskQueue {
    let queue: DispatchQueue

    init() {
        queue = DispatchQueue(label: "DispatchBarrierQueue", qos: .userInitiated, attributes: .concurrent)
    }

    func addTask(_ block: @escaping () -> ()) {
        queue.async(execute: block)
    }

    func runWhenFinished(_ block: @escaping () -> ()) {
        queue.async(qos: .userInitiated, flags: .barrier, execute: block)
    }
}
