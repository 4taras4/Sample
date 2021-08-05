//
//  Stack.swift
//  TransactionalKeyValueStore
//
//  Created by Taras Markevych on 05.08.2021.
//

import UIKit

protocol Stack {
    associatedtype Element
    
    mutating func push(item: Element)
    
    @discardableResult mutating func pop() -> Element?
        
    mutating func erase()
    
    var count: Int { get }
}

extension Array: Stack {
    mutating func push(item: Element) {
        self.append(item)
    }
    
    mutating func pop() -> Element? {
        if let last = self.last {
            self.remove(at: self.count - 1)
            return last
        }
        
        return .none
    }
    
    mutating func erase() {
        self = []
    }
}
