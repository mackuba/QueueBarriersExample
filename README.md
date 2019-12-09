# Queue Barriers Example

This sample project demonstrates how barrier tasks in GCD/NSOperationQueue and DispatchGroups work. 

<img src="https://user-images.githubusercontent.com/28465/70355891-db72cf80-187b-11ea-8327-7d7c0e58de37.gif" width="400">


## GCD Barrier Task

Add a `.barrier` flag to mark the added job as a barrier task. It will prevent any other tasks from running in parallel with it, so any tasks added later will wait until this task finishes work. This is useful if you have some tasks that can mostly be run concurrently, but a subset of those tasks requires exclusive access to some resource (e.g. a database for writing) and other tasks can't run until the resource is released. 

```swift
dispatchQueue.async(qos: .userInitiated, flags: .barrier) {
    // do some work
}
```

## NSOperationQueue Barrier Task (new)

Call `addBarrierBlock()` on an `OperationQueue`. This is new in macOS 10.15 / iOS 13 and it works exactly like the `DispatchQueue` version (as far as I can tell).

```swift
operationQueue.addBarrierBlock {
    // do some work
}
```

## DispatchGroup

Dispatch Groups work slightly differently - you can assign a task to a group, and the group keeps a kind of counter that's increased when a task is scheduled and decreased when it finishes work. You can ask to be notified when the counter gets down to 0.

Since new tasks added after you set up the notification also increase the counter, the notification will only fire once the queue is completely empty. This can be useful if you want to run some kind of cleanup tasks after all other tasks finish, including those spawned in the meantime by one of the earlier tasks.

To add a task to a group, either pass the group as a parameter to `async`:


```swift
let dispatchGroup = DispatchGroup()

dispatchQueue.async(group: dispatchGroup, qos: .userInitiated) {
    // do some work
}
```

Or manually increase and decrease the group counter using the `enter()` and `leave()` methods:

```swift
let dispatchGroup = DispatchGroup()

dispatchGroup.enter()

dispatchQueue.async {
    // do some work

    dispatchGroup.leave()
}
```

You can use `enter()` and `leave()` with any blocks of code you run asynchronously, e.g. when running some downloads:

```swift
for url in urls {
    dispatchGroup.enter()

    downloadFile(url) { response in
        // ...
        dispatchGroup.leave()
    }
}
```

To set up a callback to be run when the queue is empty, use the `notify()` method:

```swift
let dispatchGroup = DispatchGroup()

// run some tasks

dispatchGroup.notify(queue: queue) {
    // do some cleanup after all tasks have finished
}
```

You can also block the current thread and wait until all tasks finish (possibly with a timeout):

```swift
let dispatchGroup = DispatchGroup()

// run some tasks

dispatchGroup.wait()

// continue when work is done
```
