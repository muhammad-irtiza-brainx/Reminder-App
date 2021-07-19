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
    
    @objc
    func cancelButtonTrigger() {
        
        setEditing(false, animated: true)
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
            navigationItem.title = NSLocalizedString("Edit Reminder", comment: "edit reminder nav title")
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))
        } else {
            dataSource = ReminderDetailViewDataSource(reminder: reminder)
            navigationItem.title = NSLocalizedString("View Reminder", comment: "view reminder nav title")
            navigationItem.leftBarButtonItem = nil
            editButtonItem.isEnabled = true
        }
        
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}
