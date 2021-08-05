//
//  DataStorageService.swift
//  TransactionalKeyValueStore
//
//  Created by Taras Markevych on 30.07.2021.
//

protocol DataStorage {
    
    func setValue(value: String, forKey: String)
    
    func getValue(forKey: String) -> String?
    
    func removeValue(forKey: String)
    
    func countValue(value: String) -> Int
    
    func getDictionary() -> [String: String]
    
    func setDictionary(dictionary: [String: String])
    
    func begin()
}

class DataStorageService: DataStorage {
    
    private var storageDictionary = [String: String]()

    func setValue(value: String, forKey: String) {
        storageDictionary.updateValue(value, forKey: forKey)
    }
    
    func getValue(forKey: String) -> String? {
        return storageDictionary[forKey]
    }
    
    func removeValue(forKey: String) {
        storageDictionary.removeValue(forKey: forKey)
    }
    
    func countValue(value: String) -> Int {
        let filterSameValues = storageDictionary.filter({$0.value == value })
        return filterSameValues.count
    }
    
    func getDictionary() -> [String: String] {
        return storageDictionary
    }
    
    func setDictionary(dictionary: [String: String]) {
        storageDictionary = dictionary
    }
    
    func begin() {
        storageDictionary = [String: String]()
    }
}

