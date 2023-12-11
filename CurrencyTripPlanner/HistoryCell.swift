//
//  HistoryCell.swift
//  CurrencyTripPlanner
//
//  Created by YiC Wang on 11/18/23.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var displayHistoryLabel: UILabel!

    func configure(with history: ConversionHistory) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let dateString = dateFormatter.string(from: history.date ?? Date())
        
        let formattedAmount = String(format: "%.2f", history.amount)
        let formattedResult = String(format: "%.2f", history.result)
        
        displayHistoryLabel.text = "\(history.fromCurrency ?? "") \(formattedAmount) to \(history.toCurrency ?? "") \(formattedResult) on \(dateString)"
    }

}
