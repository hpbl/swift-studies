import Foundation

class Node<T> where T: Comparable {
    let value: T
    var left: Node<T>?
    var right: Node<T>?
    
    init(value: T) {
        self.value = value
        self.left = nil
        self.right = nil
    }
    
    func insert(newValue: T) {
        if newValue > self.value {
            guard let right = self.right else {
                self.right = Node(value: newValue)
                return
            }
            right.insert(newValue: newValue)
            
        } else {
            guard let left = self.left else {
                self.left = Node(value: newValue)
                return
            }
            left.insert(newValue: newValue)
        }
    }
    
    func contains(value: T) -> Bool {
        if value == self.value {
            return true
       
        } else if value > self.value {
            guard let right = self.right else {
                return false
            }
            return right.contains(value: value)
       
        } else {
            guard let left = self.left else {
                return false
            }
            return left.contains(value: value)
        }
    }
    
    func traverseInOrder() -> [T] {
        var elements = [T]()
        
        if let left = self.left {
            elements.append(contentsOf: left.traverseInOrder())
        }
        
        elements.append(self.value)
        
        if let right = self.right {
            elements.append(contentsOf: right.traverseInOrder())
        }
        
        return elements
    }
    
    func traversePreOrder() -> [T] {
        var elements = [self.value]
        
        if let left = self.left {
            elements.append(contentsOf: left.traverseInOrder())
        }
        
        if let right = self.right {
            elements.append(contentsOf: right.traverseInOrder())
        }
        
        return elements
    }
    
    func traversePostOrder() -> [T] {
        var elements = [T]()
        
        if let left = self.left {
            elements.append(contentsOf: left.traverseInOrder())
        }
        
        if let right = self.right {
            elements.append(contentsOf: right.traverseInOrder())
        }
        
        elements.append(self.value)
        
        return elements
    }
}


// MARK: - Tests
import XCTest

class TestNode: XCTestCase {
    var binaryTree: Node<Int>!
    
    override func setUp() {
        super.setUp()
        
        self.binaryTree = Node<Int>(value: 10)
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.binaryTree = nil
    }
    
    func testNodeConstructor() {
        XCTAssert(self.binaryTree.value == 10)
        XCTAssert(self.binaryTree.left == nil)
        XCTAssert(self.binaryTree.right == nil)
    }
    
    func testInsert() {
        self.binaryTree.insert(newValue: 5)
        self.binaryTree.insert(newValue: 15)
        
        XCTAssert(self.binaryTree.value == 10)
        XCTAssert(self.binaryTree.left?.value == 5)
        XCTAssert(self.binaryTree.right?.value == 15)
    }
    
    func testContainsExistingElement() {
        self.binaryTree.insert(newValue: 5)
        self.binaryTree.insert(newValue: 15)
        
        XCTAssertTrue(self.binaryTree.contains(value: 15))
    }
    
    func testContainsNonExistingElement() {
        XCTAssertFalse(self.binaryTree.contains(value: 15))
    }

    func testPrintInOrder() {
        self.binaryTree.insert(newValue: 5)
        self.binaryTree.insert(newValue: 15)

        XCTAssertEqual(self.binaryTree.traverseInOrder(), [5, 10, 15])
    }
    
    func testPrintPreOrder() {
        self.binaryTree.insert(newValue: 5)
        self.binaryTree.insert(newValue: 15)

        XCTAssertEqual(self.binaryTree.traversePreOrder(), [10, 5, 15])
    }
    
    func testPostOrder() {
        self.binaryTree.insert(newValue: 5)
        self.binaryTree.insert(newValue: 15)
        
        XCTAssertEqual(self.binaryTree.traversePostOrder(), [5, 15, 10])
    }
}


TestNode.defaultTestSuite.run()


