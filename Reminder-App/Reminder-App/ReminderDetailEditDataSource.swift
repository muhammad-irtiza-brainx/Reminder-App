//
//  ReminderDetailEditDataSource.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

class ReminderDetailEditDataSource: NSObject {
    
    enum ReminderSection: Int, CaseIterable {
        
        case title
        case dueDate
        case note
        
        // MARK: Public Methods
        func cellIdentifier(for row: Int) -> String {
            
            switch self {
            case .title:
                return "EditTitleCell"
            case .dueDate:
                return row == 0 ? "EditDateLabelCell" : "EditDateCell"
            case .note:
                return "EditnoteCell"
            }
        }
    
    // MARK: Computed Properties
    var displayText: String {
        switch self {
        case .title:
            return "Title"
        case .dueDate:
            return "Date"
        case .note:
            return "note"
        }
    }
    
    var numRows: Int {
        switch self {
        case .title, .note:
            return 1
        case .dueDate:
            return 2
        }
    }
    }
    // MARK: Static Properties
    static var dateLabelCellIdentifier: String {
        return ReminderSection.dueDate.cellIdentifier(for: 0)
    }
    
    // MARK: Stored Properties
    var reminder: Reminder
    
    
    // MARK: Initializers
    init(reminder: Reminder) {
        self.reminder = reminder
    }
    
    // MARK: Private Methods
    private func dequeueAndConfigureCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        
        guard let section = ReminderSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let identifier = section.cellIdentifier(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        switch section {
        case .title:
            if let titleCell = cell as? EditTitleCell {
                titleCell.configure(title: reminder.title)
            }
        case .dueDate:
            if indexPath.row == 0 {
                cell.textLabel?.text = reminder.dueDate.description
            } else if let dueDateCell = cell as? EditDateCell {
                    dueDateCell.configure(date: reminder.dueDate)
            }
        case .note:
            if let noteCell = cell as? EditnoteCell {
                noteCell.configure(note: reminder.note)
            }
        }
        
        return cell
    }
}

// MARK: Data Source Methods
extension ReminderDetailEditDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return ReminderSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ReminderSection(rawValue: section)?.numRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dequeueAndConfigureCell(for: indexPath, from: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let section = ReminderSection(rawValue: section) else {
            return ""
        }
        
        return section.displayText
    }
}
