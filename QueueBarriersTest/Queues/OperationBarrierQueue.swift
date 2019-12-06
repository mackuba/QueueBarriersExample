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
    var tasks: [Task] = []
    weak var delegate: TaskQueueDelegate?

    var specialTaskName: String {
        return "Blocking Task"
    }

    required init() {}

    func addTask(_ task: Task) {
        task.register()
        tasks.append(task)
        delegate?.taskAdded(task)

        if task.isBlocking {
            queue.addBarrierBlock {
                task.run()
                self.tasks.removeAll(where: { $0 == task })
                self.delegate?.taskFinished(task)
            }
        } else {
            queue.addOperation {
                task.run()
                self.tasks.removeAll(where: { $0 == task })
                self.delegate?.taskFinished(task)
            }
        }
    }
}
