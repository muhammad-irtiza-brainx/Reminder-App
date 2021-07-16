//
//  ReminderDetailViewController.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 15/07/2021.
//

import UIKit

class ReminderDetailViewController: UITableViewController {
    
    private var reminder: Reminder?
    private var detailViewDataSource: ReminderDetailViewDataSource?
    
    func configure(with reminder: Reminder) {
        self.reminder = reminder
    }
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let reminder = reminder else {
            fatalError("No reminder found for detail view")
        }
        
        detailViewDataSource = ReminderDetailViewDataSource(reminder: reminder)
        tableView.dataSource = detailViewDataSource
    }
    
}
