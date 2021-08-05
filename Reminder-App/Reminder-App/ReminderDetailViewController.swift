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
    private var reminderEditAction: ReminderChangeAction?
    private var reminderAddAction: ReminderChangeAction?
    private var isNew = false
    
    // MARK: Public Methods
    func configure(with reminder: Reminder, isNew: Bool = false, addAction: ReminderChangeAction? = nil, editAction: ReminderChangeAction? = nil) {
        self.reminder = reminder
        self.isNew = isNew
        self.reminderAddAction = addAction
        self.reminderEditAction = editAction
        
        if isViewLoaded {
            setEditing(isNew, animated: false)
        }
    }
    
    @objc
    func cancelButtonTrigger() {
        if isNew {
            dismiss(animated: true, completion: nil)
        } else {
            temporaryReminder = nil
            setEditing(false, animated: true)
        }
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setEditing(isNew, animated: false)
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReminderDetailEditDataSource.dateLabelCellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationController = navigationController,
           !navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(true, animated: animated)
        }
    }
    
    // MARK: Overridden Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        guard let reminder = reminder else {
            return
        }
        
        if editing {
            trainsitionToEditMode(reminder)
            tableView.backgroundColor = GlobalColors.editBackgroundColor
        } else {
            transitionToView(reminder)
            tableView.backgroundColor = GlobalColors.viewBackgroundColor
        }
        
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    // MARK: File Private Methods
    fileprivate func transitionToView(_ reminder: Reminder) {
        guard let temporaryReminder = temporaryReminder else {
            dataSource = ReminderDetailViewDataSource(reminder: reminder)
            navigationItem.title = NSLocalizedString(GlobalStrings.viewReminderString, comment: GlobalStrings.viewReminderNavTitleString)
            navigationItem.leftBarButtonItem = nil
            editButtonItem.isEnabled = true
            return
        }
        
        self.reminder = temporaryReminder
        self.temporaryReminder = nil
        reminderEditAction?(temporaryReminder)
        dataSource = ReminderDetailViewDataSource(reminder: temporaryReminder)
        
        navigationItem.title = NSLocalizedString(GlobalStrings.viewReminderString, comment: GlobalStrings.viewReminderNavTitleString)
        navigationItem.leftBarButtonItem = nil
        editButtonItem.isEnabled = true
    }
    
    fileprivate func trainsitionToEditMode(_ reminder: Reminder) {
        if isNew {
            let addReminder = temporaryReminder ?? reminder
            
            dismiss(animated: true) {
                self.reminderAddAction?(addReminder)
            }
            return
        }
        
        dataSource = ReminderDetailEditDataSource(reminder: reminder) {
            reminder in
            self.temporaryReminder = reminder
            self.editButtonItem.isEnabled = true
        }
        
        navigationItem.title = isNew ? NSLocalizedString(GlobalStrings.addReminderString, comment: GlobalStrings.addReminderNavTitleString) : NSLocalizedString(GlobalStrings.editReminderString, comment: GlobalStrings.editReminderNavTitleString)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))
    }
}

extension ReminderDetailViewController {
    
    // MARK: Overridden Methods
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isEditing {
            cell.backgroundColor = GlobalColors.editTableRowBackgroundColor
            
            guard let editSection = ReminderDetailEditDataSource.ReminderSection(rawValue: indexPath.section) else {
                return
            }
            
            if editSection == .dueDate, indexPath.row == 0 {
                cell.textLabel?.textColor = GlobalColors.editDateLabelTextColor
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            }
        } else {
            cell.backgroundColor = .systemBackground
            
            guard let viewRow = ReminderDetailViewDataSource.ReminderRow(rawValue: indexPath.row) else {
                return
            }
            
            if viewRow == .title {
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            } else {
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            }
        }
    }
}
