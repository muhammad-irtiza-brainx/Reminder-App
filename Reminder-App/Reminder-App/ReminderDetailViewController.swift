//
//  ReminderDetailViewController.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 15/07/2021.
//

import UIKit

class ReminderDetailViewController: UITableViewController {
    
    typealias ReminderChangeAction = (Reminder) -> Void
    
    // MARK: Private Properties
    private var reminder: Reminder?
    private var temporaryReminder: Reminder?
    private var dataSource: UITableViewDataSource?
    private var reminderChangeAction: ReminderChangeAction?
    
    // MARK: Public Methods
    func configure(with reminder: Reminder, changeAction: @escaping ReminderChangeAction) {
        self.reminder = reminder
        self.reminderChangeAction = changeAction
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
            dataSource = ReminderDetailEditDataSource(reminder: reminder) {
                reminder in
                self.temporaryReminder = reminder
                self.editButtonItem.isEnabled = true
            }
            navigationItem.title = NSLocalizedString("Edit Reminder", comment: "edit reminder nav title")
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))
        } else {
            navigationItem.title = NSLocalizedString("View Reminder", comment: "view reminder nav title")
            navigationItem.leftBarButtonItem = nil
            editButtonItem.isEnabled = true
            
            guard let temporaryReminder = temporaryReminder else {
                dataSource = ReminderDetailViewDataSource(reminder: reminder)
                return
            }
            
            self.reminder = temporaryReminder
            self.temporaryReminder = nil
            reminderChangeAction?(temporaryReminder)
            dataSource = ReminderDetailViewDataSource(reminder: temporaryReminder)
        }
        
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}
