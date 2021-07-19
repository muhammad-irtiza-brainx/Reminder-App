//
//  ViewController.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 14/07/2021.
//

import UIKit

class ReminderListViewController: UITableViewController {
    
    // MARK: Private Properties
    private var reminderListDataSource: ReminderListDataSource?
    
    // MARK: Static Properties
    static let showDetailSegueIdentifier = "ShowReminderDetailSegue"
    static let reminderListCellIdentifier = "ReminderListCell"
    
    // MARK: Overridden Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Self.showDetailSegueIdentifier,
           let destination = segue.destination as? ReminderDetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            
            let reminder = Reminder.testData[indexPath.row]
            destination.configure(with: reminder)
        }
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        reminderListDataSource = ReminderListDataSource()
        tableView.dataSource = reminderListDataSource
    }
}
