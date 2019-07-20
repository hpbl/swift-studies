import Foundation

class Graph<T> where T: Hashable {
    private var nodes: [T: Node<T>]
    
    init(nodes: [T: Node<T>]) {
        self.nodes = nodes
    }
    
    func add(node: Node<T>) {
        self.nodes[node.value] = node
    }
    
    func getNode(value: T) -> Node<T>? {
        return self.nodes[value]
    }
    
    func addEdge(source: T, destination: T) {
        guard let sourceNode = self.getNode(value: source),
            let destinationNode = self.getNode(value: destination) else {
                fatalError("Attempt to add Edge to unexistent nodes")
        }
        
        sourceNode.adjacent.append(destinationNode)
    }
    
    /* DFS: Goes deep (to children) before going broad (to neighbors) */
    func hasPathDFS(source: T, destination: T) -> Bool {
        guard let sourceNode = self.getNode(value: source),
            let destinationNode = self.getNode(value: destination) else {
                return false
        }

        return self.recursiveDFS(source: sourceNode, destination: destinationNode)
    }

    private func recursiveDFS(source: Node<T>, destination: Node<T>, visitedNodes: Set<T> = []) -> Bool {
        if visitedNodes.contains(source.value) { return false }

        if source == destination { return true }

        for adjacentNode in source.adjacent {
            if self.recursiveDFS(
                source: adjacentNode,
                destination: destination,
                visitedNodes: visitedNodes.union([source.value])
                ) {
                return true
            }
        }

        return false
    }
    
    
    /* BFS: Goes broad (to neighbors) before going deep */
    func hasPathBFS(source: T, destination: T) -> Bool {
        guard let sourceNode = self.getNode(value: source),
            let destinationNode = self.getNode(value: destination) else {
                return false
        }
        
        var visitQueue: [Node<T>] = [sourceNode]
        var visitedNodes: Set<T> = []
        
        while !visitQueue.isEmpty {
            let nodeToVisit = visitQueue.removeFirst()
            
            if visitedNodes.contains(nodeToVisit.value) { continue }
            visitedNodes.insert(nodeToVisit.value)
            
            if nodeToVisit == destinationNode { return true }
            
            visitQueue.append(contentsOf: nodeToVisit.adjacent)
        }
        
        return false
    }
}

class Node<T> where T: Hashable {
    let value: T
    var adjacent: [Node<T>]
    
    init(value: T, adjacent: [Node] = []) {
        self.value = value
        self.adjacent = adjacent
    }
}

extension Node: Equatable {
    static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.value == rhs.value && lhs.adjacent == rhs.adjacent
    }
}

//extension Node: Hashable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(self.value)
//        hasher.combine(self.adjacent)
//    }
//}


// MARK: - Tests
import XCTest

class NodeTests: XCTestCase {
    var node: Node<Int>!
    
    override func setUp() {
        super.setUp()
        
        self.node = Node<Int>(value: 1)
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.node = nil
    }
    
    func testNodeConstructor() {
        let emptyAjacencyList: [Node<Int>] = []
        XCTAssertEqual(self.node.value, 1)
        XCTAssertEqual(self.node.adjacent, emptyAjacencyList)
    }
}

class GraphTests: XCTestCase {
    var graph: Graph<Int>!
    
    override func setUp() {
        super.setUp()
        
        self.graph = Graph<Int>(nodes: [:])
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.graph = nil
    }
    
    func testGetNode_existent() {
        let nodeOne = Node<Int>(value: 1)
        self.graph.add(node: nodeOne)
        
        XCTAssertEqual(self.graph.getNode(value: 1), nodeOne)
    }
    
    func testGetNode_nonexistent() {
        XCTAssertNil(self.graph.getNode(value: 1))
    }
    
    func testAddEdge() {
        let nodeOne = Node<Int>(value: 1)
        let nodeTwo = Node<Int>(value: 2)
        
        self.graph.add(node: nodeOne)
        self.graph.add(node: nodeTwo)
        self.graph.addEdge(source: 1, destination: 2)
        
        XCTAssertEqual(self.graph.getNode(value: 1)?.adjacent[0], nodeTwo)
    }
    
    func testHasPathDFS() {
        let nodeOne = Node<Int>(value: 1)
        let nodeTwo = Node<Int>(value: 2)
        let nodeThree = Node<Int>(value: 3)

        self.graph.add(node: nodeOne)
        self.graph.add(node: nodeTwo)
        self.graph.add(node: nodeThree)
        self.graph.addEdge(source: 1, destination: 2)
        
        XCTAssertFalse(self.graph.hasPathDFS(source: 1, destination: 3))
        
        self.graph.addEdge(source: 2, destination: 3)
        XCTAssertTrue(self.graph.hasPathDFS(source: 1, destination: 3))
    }
    
    func testHasPathBFS() {
        let nodeOne = Node<Int>(value: 1)
        let nodeTwo = Node<Int>(value: 2)
        let nodeThree = Node<Int>(value: 3)
        
        self.graph.add(node: nodeOne)
        self.graph.add(node: nodeTwo)
        self.graph.add(node: nodeThree)
        self.graph.addEdge(source: 1, destination: 2)
        
        XCTAssertFalse(self.graph.hasPathBFS(source: 1, destination: 3))
        
        self.graph.addEdge(source: 2, destination: 3)
        XCTAssertTrue(self.graph.hasPathBFS(source: 1, destination: 3))
    }
}

NodeTests.defaultTestSuite.run()
GraphTests.defaultTestSuite.run()
