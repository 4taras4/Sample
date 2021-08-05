//
//  TerminalViewModel.swift
//  TransactionalKeyValueStore
//
//  Created by Taras Markevych on 30.07.2021.
//
import UIKit

class TerminalViewModel: NSObject {
    
    private var dataStorage: DataStorageService
    var stack = Array<[String: String]>()
    
    override init() {
        self.dataStorage = DataStorageService()
    }
    
    public func enterCommand(string: String) -> String? {
        switch initCommandFrom(string: string) {
        case .begin:
            stack.append(dataStorage.getDictionary())
            dataStorage.begin()
        case .commit:
            stack.erase()
        case .rollback:
            if let getLast = stack.pop() {
                dataStorage.setDictionary(dictionary: getLast)
            } else {
                return Constants.noTransactionsString
            }
        case .help:
            return Constants.helpInstructionString
        case .set(let value, let key):
            dataStorage.setValue(value: value, forKey: key)
        case .getValue(let key):
            return dataStorage.getValue(forKey: key) ?? Constants.noValueForKeyString
        case .count(let value):
            let similarValues = dataStorage.countValue(value: value)
            return "\(similarValues)"
        case .deleteValue(let key):
            dataStorage.removeValue(forKey: key)
        default:
            return Constants.invalidCommand
        }
        return nil
    }

    private func initCommandFrom(string: String) -> Command {
        return Command.getType(fromStringValue: string)
    }

}
