//
//  ReminderDetailEditDataSource.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

class ReminderDetailEditDataSource: NSObject {
    
    typealias ReminderChangeAction = (Reminder) -> Void
    
    enum ReminderSection: Int, CaseIterable {
        case title
        case dueDate
        case note
        
        // MARK: Public Methods
        func cellIdentifier(for row: Int) -> String {
            switch self {
            case .title:
                return EditTitleCell.reusableIdentifier
            case .dueDate:
                return row == 0 ? "EditDateLabelCell" : "EditDateCell"
            case .note:
                return "EditNoteCell"
            }
        }
    
        // MARK: Computed Properties
        var displayText: String {
            switch self {
            case .title:
                return ReminderPropertyStrings.titleString
            case .dueDate:
                return ReminderPropertyStrings.dateString
            case .note:
                return ReminderPropertyStrings.noteString
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
    
    // MARK: Initializers
    init(reminder: Reminder, changeAction: @escaping ReminderChangeAction) {
        self.reminder = reminder
        self.reminderChangeAction = changeAction
    }
    
    // MARK: Static Properties
    static var dateLabelCellIdentifier: String {
        return ReminderSection.dueDate.cellIdentifier(for: 0)
    }
    
    // MARK: Public Properties
    var reminder: Reminder
    
    // MARK: Private Properties
    private var reminderChangeAction: ReminderChangeAction?
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: Private Methods
    private func dequeueAndConfigureCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        guard let section = ReminderSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let identifier = section.cellIdentifier(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        switch section {
        case .title:
            guard let titleCell = cell as? EditTitleCell else {
                break
            }
            
            titleCell.configure(title: reminder.title) {
                title in
                self.reminder.title = title
                self.reminderChangeAction?(self.reminder)
            }
//            if let titleCell = cell as? EditTitleCell {
//
//            }
        case .dueDate:
            if indexPath.row == 0 {
                cell.textLabel?.text = formatter.string(from: reminder.dueDate)
            } else if let dueDateCell = cell as? EditDateCell {
                dueDateCell.configure(date: reminder.dueDate) {
                    date in
                    self.reminder.dueDate = date
                    self.reminderChangeAction?(self.reminder)
                    let indexPath = IndexPath(row: 0, section: section.rawValue)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        case .note:
            guard let noteCell = cell as? EditNoteCell else {
                break
            }
            
            noteCell.configure(note: reminder.note) {
                note in
                self.reminder.note = note
                self.reminderChangeAction?(self.reminder)
            }
//            if let noteCell = cell as? EditNoteCell {
//
//            }
        }
        
        return cell
    }
}

// MARK: Data Source Methods
extension ReminderDetailEditDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        ReminderSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ReminderSection(rawValue: section)?.numRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dequeueAndConfigureCell(for: indexPath, from: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = ReminderSection(rawValue: section) else {
            return nil
        }
        return section.displayText
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        false
    }
}
