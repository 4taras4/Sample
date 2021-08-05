//
//  StackUnitTest.swift
//  TransactionalKeyValueStoreTests
//
//  Created by Taras Markevych on 05.08.2021.
//

import XCTest
@testable import TransactionalKeyValueStore

class StackUnitTest: XCTestCase {

    func testStack() {
        var stack = Array<Int>()
        
        XCTAssertEqual(stack.pop(), .none, "stack is empty, pop returns none")

        stack.push(item: 0)
        stack.push(item: 1)
        stack.push(item: 2)
        
        XCTAssertEqual(stack.pop(), 2)
        
        XCTAssertEqual(stack.pop(), 1)
        
        XCTAssertEqual(stack.pop(), 0)
        
        stack.erase()
        XCTAssertEqual(stack.isEmpty, true)
    }

}
