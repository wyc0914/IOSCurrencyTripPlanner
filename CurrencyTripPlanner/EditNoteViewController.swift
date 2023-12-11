//
//  EditNoteViewController.swift
//  CurrencyTripPlanner
//
//  Created by YiC Wang on 12/8/23.
//

import UIKit
import CoreData

class EditNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    var noteToEdit: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        populateUI()
    }

    private func populateUI() {
        titleTextField.text = noteToEdit?.title
        contentTextView.text = noteToEdit?.content
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextView.text, !content.isEmpty else {
            showAlert(message: "Please fill out both the title and content.")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        noteToEdit?.title = title
        noteToEdit?.content = content
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
