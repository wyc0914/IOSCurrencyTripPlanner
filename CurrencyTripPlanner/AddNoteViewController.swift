//
//  AddNoteViewController.swift
//  CurrencyTripPlanner
//
//  Created by YiC Wang on 12/3/23.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextView.text, !content.isEmpty else {
            showAlert(message: "Please fill out both the title and content.")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newNote = Note(context: context)
        newNote.title = title
        newNote.content = content
        newNote.dateCreated = Date()

        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save note: \(error)")
            showAlert(message: "Failed to save note.")
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
