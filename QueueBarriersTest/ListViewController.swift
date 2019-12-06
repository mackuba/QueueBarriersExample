//
//  ListViewController.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 10.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, TaskQueueDelegate {

    @IBOutlet var modeSwitch: UISegmentedControl!
    @IBOutlet var tableView: UITableView!

    var queue: TaskQueue!
    var dataSource: UITableViewDiffableDataSource<Int, Task>!

    let modes: [(name: String, queue: TaskQueue.Type)] = [
        (name: "GCD Barrier", queue: DispatchBarrierQueue.self),
        (name: "Operation Queue", queue: OperationBarrierQueue.self),
        (name: "Dispatch Group", queue: DispatchGroupQueue.self),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = UITableViewDiffableDataSource(tableView: tableView) { table, indexPath, task in
            let cell = table.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            cell.configure(task: task)
            return cell
        }

        dataSource.defaultRowAnimation = .fade

        for (i, mode) in modes.enumerated() {
            modeSwitch.setTitle(mode.name, forSegmentAt: i)
        }

        changeMode(modeSwitch)
    }

    @IBAction func changeMode(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        self.queue?.delegate = nil

        let queue = modes[sender.selectedSegmentIndex].queue.init()
        queue.delegate = self
        self.queue = queue

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(100))) {
            let factory = TaskFactory(queue: queue)
            factory.runScenario()
        }
    }

    func taskAdded(_ task: Task) {
        updateTasks()
    }

    func taskFinished(_ task: Task) {
        updateTasks()
    }

    func updateTasks() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Task>()
        snapshot.appendSections([0])
        snapshot.appendItems(queue.tasks)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot)
        }
    }
}
