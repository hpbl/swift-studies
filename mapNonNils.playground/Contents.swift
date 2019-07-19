import UIKit

//var str = "Hello, playground"
//
//// Adapts a function to handle optional input
//func adaptForOptional<T, R>(_ originalFunc: @escaping (T) -> R) -> (T?) -> R? {
//    return { optionalValue in
//        return (optionalValue != nil) ? originalFunc(optionalValue!) : nil
//    }
//}
//
//// maps over non-nil elements, and remove nils
//extension Array {
//    func mapNonNils<T, E>(function: @escaping (E) -> T) -> [T] where Element == Optional<E> {
//        let adaptedFunction = adaptForOptional(function)
//        return self.compactMap(adaptedFunction)
//    }
//}
//
//func double(num: Int) -> Int {
//    return num * 2
//}
//
//func doubleNonNil(_ original: [Int?]) -> [Int] {
//    return original.mapNonNils(function: double)
//}
//
//import XCTest
//
//func test_double() {
//    let mixedNumbers = [1, 2, nil, 4]
//    let expectedResult = [2, 4, 8]
//
//    XCTAssertEqual(doubleNonNil(mixedNumbers), expectedResult)
//}
//
//test_double()


// MARK: - 01-mapNonNils.swift
// Initial Optionals array
let numbersWithNils = [1, 2, nil, 4]

// Transformation function
func double(num: Int) -> Int {
    return num * 2
}

// Desired result of the transformation
//let doubledNumbers = [2, 4, 8]


// MARK: - 02-mapNonNils.swift (For Loop)
//var doubledNumbers = [Int]()
//
//for number in numbersWithNils {
//    if number != nil {
//        doubledNumbers.append(number!)
//    }
//}
//
//print(doubledNumbers) // prints [2, 4, 8]


// MARK: - 03-mapNonNils.swift (For Loop, no forced unwrapping)
//var doubledNumbers = [Int]()
//
//for number in numbersWithNils {
//    guard let number = number else { continue }
//    doubledNumbers.append(number)
//}
//
//print(doubledNumbers) // prints [2, 4, 8]


// MARK: - 04-mapNonNils.swift (Filtering and mapping)
//let doubledNumbers = numbersWithNils
//    .filter{ $0 != nil }
//    .map{ double(num: $0!) }
//
//print(doubledNumbers) // prints [2, 4, 8]


// MARK: - ERROR
//let doubledNumbers = numbersWithNils
//    .compactMap(double)


// MARK: - 05-mapNonNils.swift (Compact mapping)
//let doubledNumbers = numbersWithNils
//    .compactMap { $0.map(double) }
//
//print(doubledNumbers) // prints [2, 4, 8]


// MARK: - 06-mapNonNils.swift
//extension Array {
//    func mapNonNils<T, E>(_ transform: (E) -> T) -> [T] where Element == Optional<E> {
//        return self.compactMap { element in
//            guard let element = element else { return nil }
//            return transform(element)
//        }
//    }
//}


// MARK: - 08-mapNonNils.swift
extension Array {
    func mapNonNils<T, E>(_ transform: (E) -> T) -> [T] where Element == Optional<E> {
        return self.compactMap { $0.map(transform) }
    }
}


// MARK: - 07-mapNonNils.swift
let doubledNumbers = numbersWithNils.mapNonNils(double)

print(doubledNumbers) // prints [2, 4, 8]

[2, 4, 8]
