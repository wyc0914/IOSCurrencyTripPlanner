//
//  NoteListViewController.swift
//  CurrencyTripPlanner
//
//  Created by YiC Wang on 11/26/23.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = fetchedResultsController.object(at: indexPath)
            let context = fetchedResultsController.managedObjectContext
            context.delete(noteToDelete)
            do {
                try context.save()
            } catch {
                print("Error deleting note: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = fetchedResultsController.object(at: indexPath)
        cell.configure(with: note)
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            fatalError("Unknown change type in NSFetchedResultsController")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNoteSegue" {
            if let destinationVC = segue.destination as? EditNoteViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedNote = fetchedResultsController.object(at: indexPath)
                destinationVC.noteToEdit = selectedNote
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func newNoteButtonTapped(_ sender: UIButton) {
    }
}
    

