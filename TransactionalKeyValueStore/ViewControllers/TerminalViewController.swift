//
//  ViewController.swift
//  TransactionalKeyValueStore
//
//  Created by Taras Markevych on 30.07.2021.
//

import UIKit

class TerminalViewController: UIViewController {
    
    private var viewModel: TerminalViewModel?
    // MARK: - Actions
    @IBAction func sendAction(_ sender: Any) {
        guard let string = commandTextField.text else {
            return
        }
        updateTextViewWith(string: string)
        if let result = viewModel?.enterCommand(string: string) {
            updateTextViewWith(string: result)
        }
    }
    
    // MARK: - OUTLETS
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var terminalTextView: UITextView!
    @IBOutlet weak var commandTextField: UITextField!
    @IBOutlet weak var commandToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        viewModel = TerminalViewModel()
        terminalTextView.text = Constants.welcomeString
        commandTextField.delegate = self
        commandTextField.becomeFirstResponder()
        commandTextField.inputAccessoryView = commandToolbar
    }
}

extension TerminalViewController {
    
    func updateTextViewWith(string: String) {
        terminalTextView.text += "\n\(string)"
        scrollToBottomTextView()
        resetTextField()
    }
    
    private func resetTextField() {
        commandTextField.text = nil
    }
    
    private func scrollToBottomTextView() {
        DispatchQueue.main.async {
            let range = NSRange(location: self.terminalTextView.text.count - 1, length: 0)
            self.terminalTextView.scrollRangeToVisible(range)
            //Not working correctrly scroll to bottom with short words without 'isScrollEnabled' false/true state
            self.terminalTextView.isScrollEnabled = false
            self.terminalTextView.isScrollEnabled = true
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.terminalTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height).isActive = true
        }
    }
}


extension TerminalViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let string = commandTextField.text else {
            return true
        }
        updateTextViewWith(string: string)
        if let result = viewModel?.enterCommand(string: string) {
            updateTextViewWith(string: result)
        }
        return true
    }
}
