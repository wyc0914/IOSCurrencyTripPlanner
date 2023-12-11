//
//  HistoryViewController.swift
//  CurrencyTripPlanner
//
//  Created by YiC Wang on 11/18/23.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var historyEntries: [ConversionHistory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchConversions()
    }

    func fetchConversions() {
        let fetchRequest: NSFetchRequest<ConversionHistory> = ConversionHistory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            historyEntries = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }


    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            fatalError("The dequeued cell is not an instance of HistoryCell.")
        }
        
        let historyEntry = historyEntries[indexPath.row]
        cell.configure(with: historyEntry)
        
        return cell
    }
}
