//
//  ReminderDetailViewController.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 15/07/2021.
//

import UIKit

class ReminderDetailViewController: UITableViewController {
    
    // MARK: Private Properties
    private var reminder: Reminder?
    private var dataSource: UITableViewDataSource?
    
    // MARK: Public Methods
    func configure(with reminder: Reminder) {
        
        self.reminder = reminder
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setEditing(false, animated: false)
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReminderDetailEditDataSource.dateLabelCellIdentifier)
    }
    
    // MARK: Overridden Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        guard let reminder = reminder else {
            return
        }
        
        if editing {
            dataSource = ReminderDetailEditDataSource(reminder: reminder)
        } else {
            dataSource = ReminderDetailViewDataSource(reminder: reminder)
        }
        
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}
