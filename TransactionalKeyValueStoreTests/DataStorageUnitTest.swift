//
//  DataStorageUnitTest.swift
//  TransactionalKeyValueStoreTests
//
//  Created by Taras Markevych on 05.08.2021.
//

import XCTest
@testable import TransactionalKeyValueStore

class DataStorageUnitTest: XCTestCase {

    var dataStorage: DataStorageService!
    
    override func setUp() {
        super.setUp()
        self.dataStorage = DataStorageService()
    }
    
    func testGetSetValuesDictionary() {
        dataStorage.begin()
        XCTAssertEqual(dataStorage.getValue(forKey: "foo"), .none, "dictinary is empty")

        dataStorage.setValue(value: "aaa", forKey: "foo")
        dataStorage.setValue(value: "bbb", forKey: "boo")
        dataStorage.setValue(value: "ccc", forKey: "doo")

        XCTAssertEqual(dataStorage.getValue(forKey: "foo"), "aaa")
        XCTAssertEqual(dataStorage.getValue(forKey: "boo"), "bbb")
        XCTAssertEqual(dataStorage.getValue(forKey: "doo"), "ccc")
       
        dataStorage.setValue(value: "abc", forKey: "doo")

        XCTAssertNotEqual(dataStorage.getValue(forKey: "doo"), "ccc")
        XCTAssertEqual(dataStorage.getValue(forKey: "doo"), "abc")

        dataStorage.removeValue(forKey: "foo")
        XCTAssertNil(dataStorage.getValue(forKey:"foo"), "Not exist value for key")
    }
    
    func testCount() {
        dataStorage.begin()
        dataStorage.setValue(value: "aaa", forKey: "foo")
        dataStorage.setValue(value: "aaa", forKey: "boo")
        dataStorage.setValue(value: "aaa", forKey: "doo")

        XCTAssertEqual(dataStorage.countValue(value: "aaa"), 3)
        dataStorage.setValue(value: "bbb", forKey: "boo")
        dataStorage.setValue(value: "bbb", forKey: "xoo")

        XCTAssertNotEqual(dataStorage.countValue(value: "aaa"), 3)
        XCTAssertEqual(dataStorage.countValue(value: "bbb"), 2)

    }
    
    func testSetGetDictionary() {
        dataStorage.begin()
        let dictionary = ["foo": "qqq", "doo": "qwer", "goo": "utt", "hoo": "vcxx"]
        XCTAssertEqual(dataStorage.getDictionary().isEmpty, true, "Empty dictionary")

        dataStorage.setDictionary(dictionary: dictionary)
        XCTAssertEqual(dataStorage.getDictionary(), dictionary)
        
        dataStorage.removeValue(forKey: "foo")
        XCTAssertNotEqual(dataStorage.getDictionary(), dictionary)
        dataStorage.begin()
        XCTAssertEqual(dataStorage.getDictionary().isEmpty, true, "Empty dictionary")
    }
}
