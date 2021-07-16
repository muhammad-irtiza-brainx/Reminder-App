//
//  ReminderListDataSource.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 15/07/2021.
//

import UIKit

class ReminderListDataSource: NSObject {
    private lazy var dateFormatter = RelativeDateTimeFormatter()
}


// MARK:- Data Source Methods
extension ReminderListDataSource: UITableViewDataSource {
    
    //static let showDetailSegueIndentifier = "ShowReminderDetailSegue"
    static let reminderListCellIdentifier = "ReminderListCell"
    
    // Returns the number of rows to display (in table view section).
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Reminder.testData.count
    }
    // Returns a cell for an index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderListViewController.reminderListCellIdentifier, for: indexPath) as? ReminderListCell else {
//            fatalError("Unable to dequeue ReminderCell")
//        }
//
//        let reminder = Reminder.testData[indexPath.row]
//        let dateText = dateFormatter.localizedString(for: reminder.dueDate, relativeTo: Date())
//        let image = reminder.isComplete ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
//
//        cell.titleLabel.text = reminder.title
//        cell.dateLabel.text = reminder.dueDate.description
//        cell.doneButton.setBackgroundImage(image, for: .normal)
//
//        cell.doneButtonAction = {
//            Reminder.testData[indexPath.row].isComplete.toggle()
//            tableView.reloadRows(at: [indexPath], with: .none)
//        }
//        return cell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.reminderListCellIdentifier, for: indexPath) as? ReminderListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        
        let reminder = Reminder.testData[indexPath.row]
        let dateText = dateFormatter.localizedString(for: reminder.dueDate, relativeTo: Date())
        
        cell.configure(title: reminder.title, dateText: dateText, isDone: reminder.isComplete) {
            Reminder.testData[indexPath.row].isComplete.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}