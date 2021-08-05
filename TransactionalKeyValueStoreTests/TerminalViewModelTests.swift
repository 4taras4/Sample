//
//  TerminalViewModelTests.swift
//  TransactionalKeyValueStoreTests
//
//  Created by Taras Markevych on 30.07.2021.
//

import XCTest
@testable import TransactionalKeyValueStore

class TerminalViewModelTests: XCTestCase {
    
    var terminalViewModel: TerminalViewModel!

    override func setUp() {
        super.setUp()
        terminalViewModel = TerminalViewModel()
    }
    

    func testSetGetRemoveCountTerminalCommands() {
        let keyOne = "foo"
        let valueOne = "aaa"
        terminalViewModel.enterCommand(string: "set \(keyOne) \(valueOne)")
        processCommand(command: .set(value: valueOne, forKey: keyOne), withKey: keyOne, value: valueOne)
        let resultGet = terminalViewModel.enterCommand(string: "get \(keyOne)")
        processCommand(command: .getValue(forKey: keyOne), withKey: keyOne)
        XCTAssertEqual(resultGet, valueOne)

        terminalViewModel.enterCommand(string: "delete \(keyOne)")
        let resultGetAfterDeleting = terminalViewModel.enterCommand(string: "get \(keyOne)")
        XCTAssertEqual(resultGetAfterDeleting, Constants.noValueForKeyString)
        terminalViewModel.enterCommand(string: "set \(keyOne) \(valueOne)")
        terminalViewModel.enterCommand(string: "set boo \(valueOne)")
        let countResult = terminalViewModel.enterCommand(string: "count \(valueOne)")
        XCTAssertEqual(countResult, "2")
    }
    
    func testBeginRollbackTerminalCommands() {
        let keyOne = "foo"
        let keyTwo = "boo"

        terminalViewModel.enterCommand(string: "set \(keyOne) 123")
        terminalViewModel.enterCommand(string: "set \(keyTwo) 345")
        let resultOneFirstValueGet = terminalViewModel.enterCommand(string: "get \(keyOne)")
        let resultOneSecondValueGet = terminalViewModel.enterCommand(string: "get \(keyTwo)")
        XCTAssertEqual(resultOneFirstValueGet, "123")
        XCTAssertEqual(resultOneSecondValueGet, "345")

        terminalViewModel.enterCommand(string: "begin")
        terminalViewModel.enterCommand(string: "set \(keyOne) 678")
        terminalViewModel.enterCommand(string: "set \(keyTwo) 098")
        let resultTwoFirstValueGet = terminalViewModel.enterCommand(string: "get \(keyOne)")
        let resultTwoSecondValueGet = terminalViewModel.enterCommand(string: "get \(keyTwo)")
        XCTAssertEqual(resultTwoFirstValueGet, "678")
        XCTAssertEqual(resultTwoSecondValueGet, "098")
        
        terminalViewModel.enterCommand(string: "begin")
        terminalViewModel.enterCommand(string: "set \(keyOne) qwer")
        terminalViewModel.enterCommand(string: "set \(keyTwo) asd")
        let resultThreeFirstValueGet = terminalViewModel.enterCommand(string: "get \(keyOne)")
        let resultThreeSecondValueGet = terminalViewModel.enterCommand(string: "get \(keyTwo)")
        XCTAssertEqual(resultThreeFirstValueGet, "qwer")
        XCTAssertEqual(resultThreeSecondValueGet, "asd")
        
        terminalViewModel.enterCommand(string: "rollback")
        let resultFourFirstValueGet = terminalViewModel.enterCommand(string: "get \(keyOne)")
        let resultFourSecondValueGet = terminalViewModel.enterCommand(string: "get \(keyTwo)")
        XCTAssertEqual(resultFourFirstValueGet, "678")
        XCTAssertEqual(resultFourSecondValueGet, "098")
        
        terminalViewModel.enterCommand(string: "rollback")
        let resultFiveFirstValueGet = terminalViewModel.enterCommand(string: "get \(keyOne)")
        let resultFiveSecondValueGet = terminalViewModel.enterCommand(string: "get \(keyTwo)")
        XCTAssertEqual(resultFiveFirstValueGet, "123")
        XCTAssertEqual(resultFiveSecondValueGet, "345")
        
        let resultEmptyRollback = terminalViewModel.enterCommand(string: "rollback")
        XCTAssertEqual(resultEmptyRollback, Constants.noTransactionsString)
    }
    
    func testCommitTransaction() {
        let keyOne = "foo"
        terminalViewModel.enterCommand(string: "set \(keyOne) 1234")
        terminalViewModel.enterCommand(string: "begin")
        terminalViewModel.enterCommand(string: "set \(keyOne) 678")
        let resultOneValueGet = terminalViewModel.enterCommand(string: "get \(keyOne)")
        XCTAssertEqual(resultOneValueGet, "678")
       
        terminalViewModel.enterCommand(string: "commit")
        let resultTwoValueGet = terminalViewModel.enterCommand(string: "get \(keyOne)")
        XCTAssertEqual(resultTwoValueGet, "678")
       
        let rollbackResult = terminalViewModel.enterCommand(string: "rollback")
        XCTAssertEqual(rollbackResult, Constants.noTransactionsString)
    }
    
    func testHelpAndInvalidCommands() {
        let helpResult = terminalViewModel.enterCommand(string: "help")
        XCTAssertEqual(helpResult, Constants.helpInstructionString)
      
        let invalidCommandResult = terminalViewModel.enterCommand(string: "set foo 211 2313")
        XCTAssertEqual(invalidCommandResult, Constants.invalidCommand)

        let invalidGetCommandResult = terminalViewModel.enterCommand(string: "getfoo")
        XCTAssertEqual(invalidGetCommandResult, Constants.invalidCommand)
    }
    
    func processCommand(command: Command, withKey: String? = nil, value: String? = nil) {
        switch command {
        case .set(let resultValue, let resultKey):
            XCTAssertEqual(resultValue, value)
            XCTAssertEqual(resultKey, withKey)
        case .getValue(let resultValue):
            XCTAssertEqual(resultValue, withKey)
        default:
            break
        }
    }
}
