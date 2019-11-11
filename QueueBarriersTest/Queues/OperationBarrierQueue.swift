//
//  DispatchGroupQueue.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 10.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import Foundation

class OperationBarrierQueue: TaskQueue {
    let queue = OperationQueue()

    func addTask(_ block: @escaping () -> ()) {
        queue.addOperation(block)
    }

    func runWhenFinished(_ block: @escaping () -> ()) {
        queue.addBarrierBlock(block)
    }
}
