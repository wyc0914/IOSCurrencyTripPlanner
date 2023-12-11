//
//  NoteCell.swift
//  CurrencyTripPlanner
//
//  Created by YiC Wang on 11/26/23.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentPreviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with note: Note) {
        titleLabel.text = note.title
        contentPreviewLabel.text = note.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateLabel.text = dateFormatter.string(from: note.dateCreated ?? Date())
    }
}
