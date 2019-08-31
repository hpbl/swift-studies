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

