import Foundation

protocol Taskable: class {
    var group: DispatchGroup    { get }
    var tasks: [Task]           { get set }
}

class Task {
    typealias EndTaskHandler = (Task) -> Void
    
    fileprivate var group: DispatchGroup?
    fileprivate var handler: EndTaskHandler?
    
    init(group: DispatchGroup, handler: EndTaskHandler? = nil) {
        self.group      = group
        self.handler    = handler
        self.group?.enter()
    }
    
    func end() {
        self.group?.leave()
        self.handler?(self)
    }
}


fileprivate var tasksGroupKey: UInt8 = 0
fileprivate var tasksArrayKey: UInt8 = 0
extension Taskable {
    
    //MARK: Default
    
    var group: DispatchGroup {
        if let group = objc_getAssociatedObject(self, &tasksGroupKey) as? DispatchGroup {
            return group
        }
        let group = DispatchGroup()
        objc_setAssociatedObject(self, &tasksGroupKey, group, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return group
    }
    
    var tasks: [Task] {
        get {
            if let array = objc_getAssociatedObject(self, &tasksArrayKey) as? [Task] {
                return array
            }
            let array: [Task] = []
            self.tasks = array
            return array
        }
        set {
            objc_setAssociatedObject(self, &tasksArrayKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK: Public
    
    func addTask() -> Task {
        let task = Task(group: self.group) { [weak self] endedTask in
            self?.tasks = self?.tasks.filter{ $0 !== endedTask } ?? []
        }
        self.tasks.append(task)
        return task
    }
    
    func notify(_ handler: @escaping (Void)->Void) {
        self.group.notify(queue: .main, execute: handler)
    }
}
