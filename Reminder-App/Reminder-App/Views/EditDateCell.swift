//
//  EditDateCell.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

class EditDateCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet var datePicker: UIDatePicker!
    
    // MARK: Public Methods
    func configure(date: Date) {
        
        datePicker.date = date
    }
}
