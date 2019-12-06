//
//  TaskQueue.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 10.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import Foundation

protocol TaskQueue: class {
    var tasks: [Task] { get }
    var delegate: TaskQueueDelegate? { get set }
    var specialTaskName: String { get }

    init()

    func addTask(_ task: Task)
}

protocol TaskQueueDelegate: class {
    func taskAdded(_ task: Task)
    func taskFinished(_ task: Task)
}

extension TaskQueueDelegate {
    func taskAdded(_ task: Task) {}
    func taskFinished(_ task: Task) {}
}
