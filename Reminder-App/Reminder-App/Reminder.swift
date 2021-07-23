//
//  Reminder.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 14/07/2021.
//

import Foundation

struct Reminder {
    
    // MARK: Public Properties
    var id: String
    var title: String
    var dueDate: Date
    var note: String? = nil
    var isComplete: Bool = false
}
