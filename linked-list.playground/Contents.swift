import Foundation

class Node<T> {
    let value: T
    var next: Node<T>?
    var previous: Node<T>?
    
    init(value: T, next: Node<T>? = nil, previous: Node<T>? = nil) {
        self.value = value
        self.next = next
        self.previous = previous
    }
}

class DoubleLinkedList<T> where T: Comparable {
    var head: Node<T>?
    var tail: Node<T>?
    
    init(head: Node<T>?) {
        self.head = head
        self.tail = head
    }
    
    func add(value: T) {
        let newNode = Node(value: value)
        
        guard let tail = self.tail else {
            self.head = newNode
            self.tail = newNode
            return
        }
        
        tail.next = newNode
        newNode.previous = tail
        self.tail = newNode
    }
    
    func remove(value valueToRemove: T) -> Result<T, Error> {
        guard let head = self.head, let tail = self.tail else {
            return .failure(.NotFoundOnList(value: valueToRemove))
        }
        
        // If list has only one element
        guard head.value != tail.value else {
            guard valueToRemove == head.value else {
                return .failure(.NotFoundOnList(value: valueToRemove))
            }
            
            self.head = nil
            self.tail = nil
            return .success(valueToRemove)
        }
        
        // If removing HEAD
        guard valueToRemove != head.value else {
            self.head = head.next
            self.head?.previous = nil
            
            return .success(valueToRemove)
        }
        
        // If removing TAIL
        guard valueToRemove != tail.value else {
            self.tail = tail.previous
            self.tail?.next = nil
            
            return .success(valueToRemove)
        }
        
        // If removing middle element
        var currentNode = head
        while currentNode.value != valueToRemove && currentNode.value != tail.value {
            currentNode = currentNode.next!
        }
        
        // value not found until reaching TAIL
        guard currentNode.value != tail.value else {
            return .failure(.NotFoundOnList(value: valueToRemove))
        }
        
        // value found on middle
        let prev = currentNode.previous
        let next = currentNode.next
        
        currentNode.previous!.next = next
        currentNode.next!.previous = prev
        
        return .success(valueToRemove)
    }
    
    func toArray() -> [T] {
        guard let head = self.head else {
            return []
        }
        
        var array = [T]()
        var currentElement = head
        while currentElement.next != nil {
            array.append(currentElement.value)
            currentElement = currentElement.next!
        }
        
        array.append(currentElement.value)
        
        return array
    }
    
    enum Error: Swift.Error {
        case NotFoundOnList(value: T)
    }
}


import XCTest

class DoubleLinkedListTestCase: XCTestCase {
    var list: DoubleLinkedList<Int>!
    
    override func setUp() {
        super.setUp()
        
        self.list = DoubleLinkedList<Int>(head: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.list = nil
    }
    
    func testToArrayOnEmptyList() {
        XCTAssertEqual(self.list.toArray(), [Int]())
    }
    
    func testAddValueOnEmptyList() {
        let newElement = 1
        self.list.add(value: newElement)
        
        XCTAssertEqual(self.list.toArray(), [newElement])
    }
    
    func testRemoveOnEmptyList() {
        let result = self.list.remove(value: 1)
        
        XCTAssertThrowsError(try result.get())
    }
    
    func testRemoveOnSingleList() {
        self.list.add(value: 1)
        let result = self.list.remove(value: 1)
        
        XCTAssertEqual(try result.get(), 1)
        XCTAssertEqual(self.list.toArray(), [Int]())
    }
    
    func testMultipleAddValue() {
        self.list.add(value: 1)
        self.list.add(value: 2)
        self.list.add(value: 3)
        self.list.add(value: 4)
        self.list.add(value: 5)
        
        XCTAssertEqual(self.list.toArray(), [1, 2, 3, 4, 5])
    }
    
    func testRemoveFirstValue() {
        self.list.add(value: 1)
        self.list.add(value: 2)
        self.list.add(value: 3)
        self.list.add(value: 4)
        self.list.add(value: 5)
        

        let result = self.list.remove(value: 1)
        XCTAssertEqual(try result.get(), 1)
        
        XCTAssertEqual(self.list.toArray(), [2, 3, 4, 5])
    }
    
    func testRemoveMiddleValue() {
        self.list.add(value: 1)
        self.list.add(value: 2)
        self.list.add(value: 3)
        self.list.add(value: 4)
        self.list.add(value: 5)
        
        
        let result = self.list.remove(value: 2)
        XCTAssertEqual(try result.get(), 2)
        
        XCTAssertEqual(self.list.toArray(), [1, 3, 4, 5])
    }
    
    func testRemoveLastValue() {
        self.list.add(value: 1)
        self.list.add(value: 2)
        self.list.add(value: 3)
        self.list.add(value: 4)
        self.list.add(value: 5)
        
        
        let result = self.list.remove(value: 5)
        XCTAssertEqual(try result.get(), 5)
        
        XCTAssertEqual(self.list.toArray(), [1, 2, 3, 4])
    }
    
    func testAddAndRemoveAll() {
        self.list.add(value: 1)
        self.list.add(value: 2)
        self.list.add(value: 3)
        self.list.add(value: 4)
        self.list.add(value: 5)
        
        self.list.remove(value: 1)
        self.list.remove(value: 3)
        self.list.remove(value: 4)
        self.list.remove(value: 2)
        self.list.remove(value: 5)
        
        XCTAssertEqual(self.list.toArray(), [Int]())
    }
}

DoubleLinkedListTestCase.defaultTestSuite.run()
