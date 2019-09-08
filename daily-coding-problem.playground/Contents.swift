import Foundation
import XCTest

/*
 DAY 01:
 
 This problem was recently asked by Google.
 
 Given a list of numbers and a number k, return whether any two numbers from the list add up to k.
 
 For example, given [10, 15, 3, 7] and k of 17, return true since 10 + 7 is 17.
 
 Bonus: Can you do this in one pass?
*/

class AddToKTestCase: XCTestCase {
    func testAddTo17() {
        XCTAssertEqual([10, 15, 3, 7].addTo(17), true)
    }
    
    func testAddTo9() {
        XCTAssertEqual([10, 15, 3, 7].addTo(9), false)
    }
}

extension Array where Element == Int {
    // Brute-force
    func brute_addTo(_ k: Int) -> Bool {
        for index in 0..<self.count {
            for sumCandidateIndex in index+1..<self.count {
                let sum = self[index] + self[sumCandidateIndex]
                guard sum != k else { return true }
            }
        }
        
        return false
    }
    
    // O(n)
    func addTo(_ k: Int) -> Bool {
        var set = Set<Int>()
        for element in self {
            let complement = k - element
            guard !set.contains(complement) else { return true }
            
            set.insert(element)
        }
        
        return false
    }
}

AddToKTestCase.defaultTestSuite.run()


/*
 DAY 02:
 
 This problem was asked by Uber.
 
 Given an array of integers, return a new array such that each element at index i of the new array is the product of all the numbers in the original array except the one at i.
 
 For example, if our input was [1, 2, 3, 4, 5], the expected output would be [120, 60, 40, 30, 24]. If our input was [3, 2, 1], the expected output would be [2, 3, 6].
 
 Follow-up: what if you can't use division?
*/

class ExludingProductTestCase: XCTestCase {
    func testExcludingProduct_1() {
        XCTAssertEqual([1, 2, 3, 4, 5].excludingProduct(), [120, 60, 40, 30, 24])
    }
    
    func testExcludingProduct_2() {
        XCTAssertEqual([3, 2, 1].excludingProduct(), [2, 3, 6])
    }
}

extension Array where Element == Int {
    func division_excludingProduct() -> Array<Int> {
        let arrayProduct = self.reduce(1, *)
        return self.map { element in arrayProduct / element}
    }
    
    func excludingProduct() -> Array<Int> {
        // Construct a temporary array left[] such that left[i] contains product of all elements on left of arr[i] excluding arr[i].
        var left = Array<Int>(repeating: 1, count: self.count)
        for index in 1..<self.count {
            left[index] = self[index - 1] * left[index - 1]
        }
        
        // Construct another temporary array right[] such that right[i] contains product of all elements on on right of arr[i] excluding arr[i].
        var right = Array<Int>(repeating: 1, count: self.count)
        for index in stride(from: self.count - 2, through: 0, by: -1) {
            right[index] = self[index + 1] * right[index + 1]
        }
        
        // To get prod[], multiply left[] and right[].
        return zip(left, right).map(*)
    }
}

ExludingProductTestCase.defaultTestSuite.run()


/*
 DAY 03:
 
 Good morning! Here's your coding interview problem for today.
 
 This problem was asked by Google.
 
 Given the root to a binary tree, implement serialize(root), which serializes the tree into a string, and deserialize(s), which deserializes the string back into the tree.
 
 For example, given the following Node class
 
 class Node:
    def __init__(self, val, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
 
 The following test should pass:

 node = Node('root', Node('left', Node('left.left')), Node('right'))
 assert deserialize(serialize(node)).left.left.val == 'left.left'
*/

class NodeSeralizationTestCase: XCTestCase {
    func testNodeSerialization() {
        let node = Node(
            val: "root",
            left: Node(val: "left", left: Node(val: "left.left")),
            right: Node(val: "right")
        )
        XCTAssertEqual(deserialize(serialize(node)).left!.left!.val, "left.left")
    }
    
    func testSerialize() {
        let node = Node(val: "root")
        XCTAssertEqual(serialize(node), "{ \"val\": \"root\", \"left\": null, \"right\": null }")
    }
    
    func testSerializeWithChildren() {
        let node = Node(val: "root", left: Node(val: "left"), right: Node(val: "right"))
        XCTAssertEqual(serialize(node), "{ \"val\": \"root\", \"left\": { \"val\": \"left\", \"left\": null, \"right\": null }, \"right\": { \"val\": \"right\", \"left\": null, \"right\": null } }")
    }
    
    func testEquality() {
        let node1 = Node(val: "root", left: Node(val: "left"), right: Node(val: "right"))
        let node2 = Node(val: "root", left: Node(val: "left"), right: Node(val: "right"))
        XCTAssertEqual(node1, node2)
    }
    
    func testInequality() {
        let node1 = Node(val: "root", left: Node(val: "left"), right: Node(val: "right"))
        let node2 = Node(val: "root", left: Node(val: "left2"), right: Node(val: "right"))
        XCTAssertNotEqual(node1, node2)
    }
    
    func testDeserialize() {
        let serializedNode = "{ \"val\": \"root\", \"left\": null, \"right\": null }"
        XCTAssertEqual(deserialize(serializedNode), Node(val: "root"))
    }
}

class Node: Codable {
    var val: String
    var left: Node?
    var right: Node?
    
    init(val: String, left: Node? = nil, right: Node? = nil) {
        self.val = val
        self.left = left
        self.right = right
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return Node.compareNodes(lhs, nodeB: rhs)
    }
    
    private static func compareNodes(_ nodeA: Node?, nodeB: Node?) -> Bool {
        if nodeA == nil && nodeB == nil {
            return true
        } else {
            guard let nodeA = nodeA, let nodeB = nodeB else { return false }
            
            guard nodeA.val == nodeB.val else { return false }
            
            guard compareNodes(nodeA.left, nodeB: nodeB.left) else { return false }
            
            guard compareNodes(nodeA.right, nodeB: nodeB.right) else { return false }
            
            return true
        }
    }
}

func deserialize(_ nodeString: String) -> Node {
    do {
        let nodeData = nodeString.data(using: .utf8)!
        let node = try JSONDecoder().decode(Node.self, from: nodeData)
        return node
    } catch {
        fatalError(error.localizedDescription)
    }
}

func serialize(_ node: Node) -> String {
    return "{ \"val\": \"\(node.val)\", \"left\": \(node.left.map(serialize) ?? "null"), \"right\": \(node.right.map(serialize) ?? "null") }"
}

NodeSeralizationTestCase.defaultTestSuite.run()


/*
 Day 04:
 
 This problem was asked by Stripe.
 
 Given an array of integers, find the first missing positive integer in linear time and constant space. In other words, find the lowest positive integer that does not exist in the array. The array can contain duplicates and negative numbers as well.
 
 For example, the input [3, 4, -1, 1] should give 2. The input [1, 2, 0] should give 3.
 
 You can modify the input array in-place.
*/

class MissingIntTestCase: XCTestCase {
    func testMissingMinInt() {
        XCTAssertEqual([3, 4, -1, 1].missingMinInt(), 2)
        XCTAssertEqual([1, 2, 0].missingMinInt(), 3)
    }
}

extension Array where Element == Int {
    func missingMinInt() -> Int {
        var minInts = Set<Int>(1...self.count)
        for element in self {
            if minInts.contains(element) { minInts.remove(element) }
        }
        return minInts.min() ?? self.count + 1
    }
}

MissingIntTestCase.defaultTestSuite.run()


/*
 Day 05:
 
 This problem was asked by Jane Street.
 
 cons(a, b) constructs a pair, and fst(pair) and lst(pair) returns the first and last element of that pair.
 For example, fst(cons(3, 4)) returns 3, and lst(cons(3, 4)) returns 4.
 
 Given this implementation of cons:
 
 def cons(a, b):
    def pair(f):
        return f(a, b)
    return pair

 Implement fst and lst.
*/

class ConsTestCase: XCTestCase {
    func testFst() {
        XCTAssertEqual(fst(cons(3, 4)), 3)
    }
    
    func testLst() {
        XCTAssertEqual(lst(cons(3, 4)), 4)
    }
}

func cons(_ a: Int, _ b: Int) -> ((Int, Int) -> Int) -> Int {
    func pair(f: (Int, Int) -> Int) -> Int {
        return f(a, b)
    }
    return pair
}

func fst(_ p: ((Int, Int) -> Int) -> Int) -> Int {
    return p({ a, b in return a })
}

func lst(_ p: ((Int, Int) -> Int) -> Int) -> Int {
    return p({ a, b in return b })
}

ConsTestCase.defaultTestSuite.run()


/*
 Day 07:
 
 This problem was asked by Facebook.
 
 Given the mapping a = 1, b = 2, ... z = 26, and an encoded message, count the number of ways it can be decoded.
 
 For example, the message '111' would give 3, since it could be decoded as 'aaa', 'ka', and 'ak'.
 
 You can assume that the messages are decodable. For example, '001' is not allowed.
*/

class PossibleDecodingTestCase: XCTestCase {
    func testCountPossibleDecodings() {
        XCTAssertEqual(countPossibleDecoding("111"), 3)
        XCTAssertEqual(countPossibleDecoding("11"), 2)
        XCTAssertEqual(countPossibleDecoding("1"), 1)
    }
}

func countPossibleDecoding(_ encoded: String) -> Int {
    var possibleDecodings = 1
    
    var previousChar: Character?
    for char in encoded {
        // Check if combining with previous char makes a valid encoded letter (2 digits)
        if let previousChar = previousChar, let possibleEncoding = Int("\(previousChar)\(char)") {
            if (10...26).contains(possibleEncoding) { possibleDecodings += 1 }
        }
        
        previousChar = char
    }
    
    return possibleDecodings
}

PossibleDecodingTestCase.defaultTestSuite.run()
