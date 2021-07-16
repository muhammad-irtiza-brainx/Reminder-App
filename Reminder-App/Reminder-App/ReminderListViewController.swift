//
//  ViewController.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 14/07/2021.
//

import UIKit

class ReminderListViewController: UITableViewController {
    
    //MARK:- Identifiers
    static let showDetailSegueIdentifier = "ShowReminderDetailSegue"
    static let reminderListCellIdentifier = "ReminderListCell"
    
    //MARK:- Overridden Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == Self.showDetailSegueIdentifier,
           let destination = segue.destination as? ReminderDetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let reminder = Reminder.testData[indexPath.row]
        destination.configure(with: reminder)
    }
}

//MARK:- UITableViewController
extension ReminderListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Reminder.testData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.reminderListCellIdentifier, for: indexPath) as? ReminderListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        
        let reminder = Reminder.testData[indexPath.row]
        let image = reminder.isComplete ? UIImage(systemName: Images.circleFilledImage) : UIImage(systemName: Images.circleUnfilledImage)
        
        cell.titleLabel.text = reminder.title
        cell.dateLabel.text = reminder.dueDate.description
        cell.doneButton.setBackgroundImage(image, for: .normal)
        
        cell.doneButtonAction = {
            Reminder.testData[indexPath.row].isComplete.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
}
