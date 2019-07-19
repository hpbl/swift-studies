class Stack<T> {
    private var elements: [T]
    
    init() {
        self.elements = []
    }
    
    func push(_ element: T) {
        elements.append(element)
    }
    
    func pop() -> T? {
        return self.elements.popLast()
    }
}

class Queue<T> {
    private var elements: [T]
    
    init() {
        self.elements = []
    }
    
    func enqueue(_ element: T) {
        self.elements.append(element)
    }
    
    func dequeue() -> T? {
        guard self.elements.count > 0 else {
            return nil
        }
        
        return elements.removeFirst()
    }
}

let queue = Queue<Int>()

queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)

queue.dequeue()
queue.dequeue()
queue.dequeue()
queue.dequeue()


let stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)

stack.pop()
stack.pop()
stack.pop()
stack.pop()


