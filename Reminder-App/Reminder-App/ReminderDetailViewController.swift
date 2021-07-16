//
//  ReminderDetailViewController.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 15/07/2021.
//

import UIKit

class ReminderDetailViewController: UITableViewController {
    
    enum ReminderRow: Int, CaseIterable {
        case title
        case date
        case time
        case notes
        
        func displayText(for reminder: Reminder?) -> String? {
            switch self {
            case .title:
                return reminder?.title
            case .date:
                return reminder?.dueDate.description
            case .time:
                return reminder?.dueDate.description
            case .notes:
                return reminder?.notes
            }
        }
        
        var cellImage: UIImage? {
            switch self {
            case .title:
                return nil
            case .date:
                return UIImage(systemName: Images.calenderCirceImage)
            case .time:
                return UIImage(systemName: Images.clockImage)
            case .notes:
                return UIImage(systemName: Images.squareAndPencil)
            }
        }
    }
    
    var reminder: Reminder?
    
    func configure(with reminder: Reminder) {
        self.reminder = reminder
    }
    
}

extension ReminderDetailViewController {
    
    static let reminderDetailCellIdentifier = "ReminderDetailCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderRow.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reminderDetailCellIdentifier, for: indexPath)
        let row = ReminderRow(rawValue: indexPath.row)
        
        cell.textLabel?.text = row?.displayText(for: reminder)
        cell.imageView?.image = row?.cellImage
        
        return cell
    }
}
