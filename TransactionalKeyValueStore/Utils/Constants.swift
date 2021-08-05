//
//  Constants.swift
//  TransactionalKeyValueStore
//
//  Created by Taras Markevych on 30.07.2021.
//

struct Constants {
    static let helpInstructionString =  """
                SET <key> <value> // store the value for key
                GET <key>         // return the current value for key
                DELETE <key>      // remove the entry for key
                COUNT <value>     // return the number of keys that have the given value
                BEGIN             // start a new transaction
                COMMIT            // complete the current transaction
                ROLLBACK          // revert to state prior to BEGIN call
            """
    static let noTransactionsString = "no transaction"
    static let noValueForKeyString = "no value for key"
    static let invalidCommand = "Invalid command"
    static let welcomeString = "Welcome write 'help' to see available commands"
}
