//
//  DispatchGroupQueue.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 10.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import Foundation

class DispatchGroupQueue: TaskQueue {
    let queue: DispatchQueue
    let dispatchGroup: DispatchGroup

    init() {
        queue = DispatchQueue(label: "DispatchGroupQueue", qos: .userInitiated, attributes: .concurrent)
        dispatchGroup = DispatchGroup()
    }

    func addTask(_ block: @escaping () -> ()) {
        queue.async(group: dispatchGroup, qos: .userInitiated, execute: block)
    }

    func runWhenFinished(_ block: @escaping () -> ()) {
        dispatchGroup.notify(queue: queue, execute: block)
    }
}
