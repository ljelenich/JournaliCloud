//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by LAURA JELENICH on 10/5/20.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    //MARK: - Properties
    var entry: Entry? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func mainViewTapped(_ sender: Any) {
        resignFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveEntry()
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    //MARK: - Helper/Class Methods
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
    
    func saveEntry() {
        guard let title = titleTextField.text, !title.isEmpty,
              let body = bodyTextView.text, !body.isEmpty else { return }
        EntryController.shared.createEntry(with: title, body: body) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
    }
  
}
