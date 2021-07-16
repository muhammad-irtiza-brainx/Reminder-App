//
//  EditNotesCell.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

class EditNotesCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet var notesTextView: UITextView!
    
    // MARK: Instance Methods
    func configure(notes: String?) {
        notesTextView.text = notes
    }
}
