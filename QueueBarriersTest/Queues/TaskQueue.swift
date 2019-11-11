//
//  TaskQueue.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 10.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

protocol TaskQueue {
    func addTask(_ block: @escaping () -> ())
    func runWhenFinished(_ block: @escaping () -> ())
}
