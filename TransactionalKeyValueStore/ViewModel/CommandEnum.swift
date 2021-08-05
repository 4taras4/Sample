//
//  CommandsService.swift
//  TransactionalKeyValueStore
//
//  Created by Taras Markevych on 30.07.2021.
//
enum Command {
    case set(value: String, forKey: String)
    case getValue(forKey: String)
    case deleteValue(forKey: String)
    case count(values: String)
    case begin
    case commit
    case rollback
    case help
    case none
    
    static func isValidArguments(arguments: [String], string: String) -> Bool {
        switch string {
        case "set":
            return arguments.count == 3
        case "count", "get", "delete":
            return arguments.count == 2
        default:
            return arguments.count == 1
        }
    }
    
    static func getType(fromStringValue: String) -> Command {
        let argumentsArray = fromStringValue.components(separatedBy: " ")
        guard let command = argumentsArray.first?.lowercased(), isValidArguments(arguments: argumentsArray, string: command) else {
            return .none
        }
        switch command {
        case "set":
            return .set(value: argumentsArray[2], forKey: argumentsArray[1])
        case "get":
            return .getValue(forKey: argumentsArray.last!)
        case "delete":
            return .deleteValue(forKey: argumentsArray.last!)
        case "count":
            return .count(values: argumentsArray.last!)
        case "begin":
            return .begin
        case "commit":
            return .commit
        case "rollback":
            return .rollback
        case "help":
            return .help
        default:
            return .none
        }
    }
}
