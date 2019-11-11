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
    let schedulingQueue = DispatchQueue.global()

    init(queue: TaskQueue) {
        self.queue = queue
    }

    func runScenario() {
        addTask(Task(name: "Task 1", length: 3.0))
        addTask(Task(name: "Task 2", length: 5.0))
        addTask(Task(name: "Task 3", length: 8.0))

        let now = DispatchTime.now()

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(3500))) {
            let blockingTask = Task(name: "Blocking Task", length: 5.0)
            blockingTask.register()
            self.queue.runWhenFinished { blockingTask.run() }
        }

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(7000))) {
            self.addTask(Task(name: "Task 4", length: 4.0))
        }

        schedulingQueue.asyncAfter(deadline: now.advanced(by: .milliseconds(12000))) {
            self.addTask(Task(name: "Task 5", length: 3.0))
        }
    }

    func addTask(_ task: Task) {
        task.register()
        queue.addTask { task.run() }
    }
}
