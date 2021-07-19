//
//  EditTitleCell.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

class EditTitleCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet var titleTextField: UITextField!
    
    // MARK: Public Methods
    func configure(title: String) {
        
        titleTextField.text = title
    }
}

