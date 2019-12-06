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
    var tasks: [Task] = []
    weak var delegate: TaskQueueDelegate?

    var specialTaskName: String {
        return "Finalizing Task"
    }

    required init() {
        queue = DispatchQueue(label: "DispatchGroupQueue", qos: .userInitiated, attributes: .concurrent)
        dispatchGroup = DispatchGroup()
    }

    func addTask(_ task: Task) {
        task.register()

        if task.isBlocking {
            tasks.append(task)
            dispatchGroup.notify(queue: queue) {
                task.run()
                self.tasks.removeAll(where: { $0 == task })
                self.delegate?.taskFinished(task)
            }
        } else {
            if let index = tasks.firstIndex(where: { $0.isBlocking && $0.status == .waiting }) {
                tasks.insert(task, at: index)
            } else {
                tasks.append(task)
            }

            queue.async(group: dispatchGroup, qos: .userInitiated) {
                task.run()
                self.tasks.removeAll(where: { $0 == task })
                self.delegate?.taskFinished(task)
            }
        }

        delegate?.taskAdded(task)
    }
}
