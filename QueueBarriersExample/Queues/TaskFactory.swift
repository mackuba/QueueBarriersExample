//
//  TaskFactory.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 10.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import Foundation

class TaskFactory {
    let queue: TaskQueue
    let schedulingQueue = DispatchQueue.global(qos: .userInteractive)

    init(queue: TaskQueue) {
        self.queue = queue
    }

    func runScenario() {
        let now = DispatchTime.now()

        addTask(Task(name: "Task 1", length: 3.0))

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(100))) {
            self.addTask(Task(name: "Task 2", length: 7.0))
        }

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(200))) {
            self.addTask(Task(name: "Task 3", length: 12.0))
        }

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(5_000))) {
            let blockingTask = Task(name: self.queue.specialTaskName, length: 5.0, isBlocking: true)
            self.queue.addTask(blockingTask)
        }

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(10_000))) {
            self.addTask(Task(name: "Task 4", length: 4.0))
        }

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(13_500))) {
            self.addTask(Task(name: "Task 5", length: 2.0))
        }

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(16_500))) {
            self.addTask(Task(name: "Task 6", length: 3.0))
        }
    }

    func addTask(_ task: Task) {
        queue.addTask(task)
    }
}
