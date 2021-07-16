//
//  Reminder.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 14/07/2021.
//

import Foundation

struct Reminder {
    
    // MARK:- Instance Properties
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

extension Reminder {
    
    // MARK:- Static Properties
    static var testData: [Reminder] = [
        Reminder(title: "Create remote repo", dueDate: Date().addingTimeInterval(800.0), notes: "Use your own github account"),
        
        Reminder(title: "Clone it to local machine", dueDate: Date().addingTimeInterval(14000.0), notes: "Use git clone command"),
        
        Reminder(title: "Create Xocde project", dueDate: Date().addingTimeInterval(24000.0), notes: "This project should be in master branch"),
        
        Reminder(title: "Commit and push", dueDate: Date().addingTimeInterval(3200.0), notes: "Good commit message"),
        
        Reminder(title: "Create branch for feature", dueDate: Date().addingTimeInterval(60000.0), notes: "Call this branch feature/feature-name", isComplete: true),
        
        Reminder(title: "Implement the feature", dueDate: Date().addingTimeInterval(72000.0), notes: "Write clean code"),
        
        Reminder(title: "Create PR when feature is complete", dueDate: Date().addingTimeInterval(80000.0), notes: "blah blah"),
        
        Reminder(title: "Review the PR", dueDate: Date().addingTimeInterval(92000.0), notes: "Arslan will review it", isComplete: true),
        
        Reminder(title: "Merge the commit", dueDate: Date().addingTimeInterval(101000.0), notes: "Good commit message")
    ]
}
