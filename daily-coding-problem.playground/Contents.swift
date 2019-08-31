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
