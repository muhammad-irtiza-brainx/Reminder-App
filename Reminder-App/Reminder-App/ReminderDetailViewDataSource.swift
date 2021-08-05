//
//  ReminderDetailViewDataSource.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

class ReminderDetailViewDataSource: NSObject {
    
    enum ReminderRow: Int, CaseIterable {
        case title
        case date
        case time
        case note
        
        // MARK: Static Properties
        static let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter
        }()
        
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            return formatter
        }()
        
        // MARK: Public Methods
        func displayText(for reminder: Reminder?) -> String? {
            switch self {
            case .title:
                return reminder?.title
            case .date:
                guard let date = reminder?.dueDate else { return nil }
                if Locale.current.calendar.isDateInToday(date) {
                    return NSLocalizedString("Today", comment: "Today for date description")
                }
                return Self.dateFormatter.string(from: date)
            case .time:
                guard let date = reminder?.dueDate else { return nil }
                return Self.timeFormatter.string(from: date)
            case .note:
                return reminder?.note
            }
        }
        
        // MARK: Computed Properties
        var cellImage: UIImage? {
            switch self {
            case .title:
                return nil
            case .date:
                return UIImage(systemName: Images.calenderCirceImage)
            case .time:
                return UIImage(systemName: Images.clockImage)
            case .note:
                return UIImage(systemName: Images.squareAndPencil)
            }
        }
    }
    
    // MARK: Private Properties
    private var reminder: Reminder
    
    // MARK: Initializers
    init(reminder: Reminder) {
        self.reminder = reminder
        super.init()
    }
}

// MARK: Data Source Methods
extension ReminderDetailViewDataSource: UITableViewDataSource {
    
    // MARK: Static Properties
    static let reminderDetailCellIdentifier = "ReminderDetailCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reminderDetailCellIdentifier, for: indexPath)
        let row = ReminderRow(rawValue: indexPath.row)
        
        cell.textLabel?.text = row?.displayText(for: reminder)
        cell.imageView?.image = row?.cellImage
        
        return cell
    }
}
