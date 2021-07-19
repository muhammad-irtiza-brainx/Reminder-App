//
//  EditnoteCell.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

class EditnoteCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet var noteTextView: UITextView!
    
    // MARK: Public Methods
    func configure(note: String?) {
        
        noteTextView.text = note
    }
}
