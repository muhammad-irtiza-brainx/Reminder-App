//
//  ReminderListDataSource.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 15/07/2021.
//

import UIKit

class ReminderListDataSource: NSObject {
    
    // MARK: Public Properties
    var filter: Filter = .today
    var filteredReminders: [Reminder] {
        return Reminder.testData.filter { filter.shouldInclude(date: $0.dueDate) }.sorted { $0.dueDate < $1.dueDate }
    }
    
    // MARK: Static Properties
    static let reminderListCellIdentifier = "ReminderListCell"
    
    // MARK: Public Methods
    func update(_ reminder: Reminder, at row: Int) {
        Reminder.testData[row] = reminder
    }
    
    func reminder(at row: Int) -> Reminder {
        filteredReminders[row]
    }
    
    func add(_ reminder: Reminder) {
        Reminder.testData.insert(reminder, at: 0)
    }
    
    enum Filter: Int {
        case today
        case future
        case all
        
        // MARK: Public Methods
        func shouldInclude(date: Date) -> Bool {
            let isInToday = Locale.current.calendar.isDateInToday(date)
            
            switch self {
            case .today:
                return isInToday
            case .future:
                return (date > Date()) && !isInToday
            case .all:
                return true
            }
        }
    }
}

// MARK: Data Source Methods
extension ReminderListDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderListCell.reusableIdentifier, for: indexPath)
                as? ReminderListCell else {
            return UITableViewCell()
        }
        
        let reminder = Reminder.testData[indexPath.row]
        let dateText = reminder.dueDateTimeText(for: filter)
//        let dateText = dateFormatter.localizedString(for: reminder.dueDate, relativeTo: Date())
        
        cell.configure(title: reminder.title, dateText: dateText, isDone: reminder.isComplete) {
            Reminder.testData[indexPath.row].isComplete.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}

extension Reminder {
    
    // MARK: Static Properties
    static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        return timeFormatter
    }()
    
    static let futureDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    static let todayDateFormatter: DateFormatter = {
        let format = NSLocalizedString("'Today at '%@", comment: "format string for dates occurring today")
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = String(format: format, "hh:mm a")
        
        return dateFormatter
    }()
    
    // MARK: Public Methods
    func dueDateTimeText(for filter: ReminderListDataSource.Filter) -> String {
        let isInToday = Locale.current.calendar.isDateInToday(dueDate)
        
        switch filter {
        case .today:
            return Self.timeFormatter.string(from: dueDate)
        case .future:
            return Self.futureDateFormatter.string(from: dueDate)
        case .all:
            if isInToday {
                return Self.todayDateFormatter.string(from: dueDate)
            } else {
                return Self.futureDateFormatter.string(from: dueDate)
            }
        }
    }
}
