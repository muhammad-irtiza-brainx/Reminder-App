//
//  EditNoteCell.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

class EditNoteCell: UITableViewCell {
    
    typealias NoteChangeAction = (String) -> Void
    
    // MARK: Outlets
    @IBOutlet var noteTextView: UITextView!
    
    // MARK: Private Properties
    private var noteChanegAction: NoteChangeAction?
    
    // MARk: Overridden Mrthods
    override func awakeFromNib() {
        super.awakeFromNib()
        noteTextView.delegate = self
    }
    
    // MARK: Public Methods
    func configure(note: String?, changeAction: NoteChangeAction?) {
        noteTextView.text = note
        self.noteChanegAction = changeAction
    }
}

// MARK: Data Source Methods
extension EditNoteCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let originalText = textView.text {
            let title = (originalText as NSString).replacingCharacters(in: range, with: text)
            noteChanegAction?(title)
        }
        return true
    }
}
