import Foundation

// MARK: - Bubble Sort
extension Array where Element: Comparable {
    mutating func bubbleSort() {
        var sorted = false
        
        while !sorted {
            sorted = true
            
            for index in 0..<self.count-1 {
                let firstElement = self[index]
                let secondElement = self[index + 1]
                
                if firstElement > secondElement {
                    sorted = false
                    self.swapAt(index, index + 1)
                }
            }
        }
    }
    
    func nonMutatingBubbleSort() -> Array {
        var sorted = false
        var sortedArray = self
        
        while !sorted {
            sorted = true
            
            for index in 0..<sortedArray.count-1 {
                let firstElement = sortedArray[index]
                let secondElement = sortedArray[index + 1]
                
                if firstElement > secondElement {
                    sorted = false
                    sortedArray[index] = secondElement
                    sortedArray[index + 1] = firstElement
                }
            }
        }
        
        return sortedArray
    }
    
    mutating func mergeSort() {
        let endIndex = self.count - 1
        self.mergeSortRecursion(startIndex: 0, endIndex: endIndex)
    }
    
    private mutating func mergeSortRecursion(startIndex: Int, endIndex: Int) {
        guard startIndex < endIndex else { return }
        
        let middleIndex = (startIndex + endIndex) / 2
        self.mergeSortRecursion(startIndex: startIndex, endIndex: middleIndex)
        self.mergeSortRecursion(startIndex: middleIndex + 1, endIndex: endIndex)
        self.mergeHalves(leftStart: startIndex, rightEnd: endIndex)
    }
    
    private mutating func mergeHalves(leftStart: Int, rightEnd: Int) {
        let leftEnd = (leftStart + rightEnd) / 2
        let rightStart = leftEnd + 1
        
        var left = leftStart
        var right = rightStart
        
        var sortedIndex = leftStart
        var sortedArray = self
        
        while left <= leftEnd && right <= rightEnd {
            if self[left] <= self[right] {
                sortedArray[sortedIndex] = self[left]
                left += 1
            } else {
                sortedArray[sortedIndex] = self[right]
                right += 1
            }
            sortedIndex += 1
        }
        
        let missingRange = sortedIndex...rightEnd
        let missinSortedRange = left <= leftEnd
            ? left...leftEnd
            : right...rightEnd
        sortedArray.replaceSubrange(missingRange, with: self[missinSortedRange])
        
        self = sortedArray
    }
    
    static func quickSort(array: Array) -> Array {
        guard array.count > 1 else { return array }
        
        let pivot = array.count / 2
        var smaller = [Element]()
        var equal = [Element]()
        var greater = [Element]()
        
        for element in array {
            if element < array[pivot] {
                smaller.append(element)
            } else if element > array[pivot] {
                greater.append(element)
            } else {
                equal.append(element)
            }
        }
        
        return quickSort(array: smaller) + equal + quickSort(array: greater)
    }
}


// MARK: - Tests
import XCTest

class SortingTests: XCTestCase {
    var unsortedArray: [Int]!
    var sortedArray: [Int]!
    
    override func setUp() {
        super.setUp()
        
        self.unsortedArray = [5, 3, 2, 1]
        self.sortedArray = [1, 2, 3, 5]
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.unsortedArray = nil
        self.sortedArray = nil
    }
    
    func testBubbleSort() {
        self.unsortedArray.bubbleSort()
        
        XCTAssertEqual(self.unsortedArray, self.sortedArray)
    }
    
    func testNonMutatingBubbleSort() {
        let bubbleSorted = self.unsortedArray.nonMutatingBubbleSort()
        
        XCTAssertEqual(bubbleSorted, self.sortedArray)
    }
    
    func testMergeSort() {
        self.unsortedArray.mergeSort()
        
        XCTAssertEqual(self.unsortedArray, self.sortedArray)
    }
    
    func testQuickSort() {
        let quickSorted = Array.quickSort(array: self.unsortedArray)
        
        XCTAssertEqual(quickSorted, self.sortedArray)
    }
}

SortingTests.defaultTestSuite.run()
