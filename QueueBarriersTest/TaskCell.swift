//
//  TaskCell.swift
//  QueueBarriersTest
//
//  Created by Kuba Suder on 11.11.2019.
//  Copyright © 2019 Kuba Suder. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!

    weak var task: Task?

    override func prepareForReuse() {
        super.prepareForReuse()

        self.spinner.stopAnimating()
        NotificationCenter.default.removeObserver(self)
        task = nil
    }

    func configure(task: Task) {
        self.task = task
        titleLabel.text = task.name

        if task.status == .active {
            self.spinner.startAnimating()
        }

        updateBackgroundColor()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateStatus),
            name: Task.taskStatusChanged,
            object: task
        )
    }

    @objc func updateStatus() {
        DispatchQueue.main.async {
            if let task = self.task, task.status == .active {
                self.spinner.startAnimating()
            } else {
                self.spinner.stopAnimating()
            }

            self.updateBackgroundColor()
        }
    }

    func updateBackgroundColor() {
        if let task = self.task {
            if task.status == .active {
                self.backgroundColor = self.tintColor.withAlphaComponent(0.2)
            } else if task.isBlocking && task.status == .waiting {
                self.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
}
