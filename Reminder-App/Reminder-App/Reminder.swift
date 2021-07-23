//
//  Reminder.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 14/07/2021.
//

import Foundation

struct Reminder {
    
    // MARK: Instance Properties
    var id: String
    var title: String
    var dueDate: Date
    var note: String? = nil
    var isComplete: Bool = false
    
    // MARK: Static Properties
    static var testData = [
            Reminder(id: UUID().uuidString, title: "Submit reimbursement report", dueDate: Date().addingTimeInterval(800.0), note: "Don't forget about taxi receipts"),
        
            Reminder(id: UUID().uuidString, title: "Code review", dueDate: Date().addingTimeInterval(14000.0), note: "Check tech specs in shared folder", isComplete: true),
        
            Reminder(id: UUID().uuidString, title: "Pick up new contacts", dueDate: Date().addingTimeInterval(24000.0), note: "Optometrist closes at 6:00PM"),
        
            Reminder(id: UUID().uuidString, title: "Add notes to retrospective", dueDate: Date().addingTimeInterval(3200.0),
                     note: "Collaborate with project manager", isComplete: true),
        
            Reminder(id: UUID().uuidString, title: "Interview new project manager candidate", dueDate: Date().addingTimeInterval(60000.0),
                     note: "Review portfolio"),
        
            Reminder(id: UUID().uuidString, title: "Mock up onboarding experience", dueDate: Date().addingTimeInterval(72000.0),
                     note: "Think different"),
        
            Reminder(id: UUID().uuidString, title: "Review usage analytics", dueDate: Date().addingTimeInterval(83000.0),
                     note: "Discuss trends with management"),
        
            Reminder(id: UUID().uuidString, title: "Confirm group reservation", dueDate: Date().addingTimeInterval(92500.0),
                     note: "Ask about space heaters"),
        
            Reminder(id: UUID().uuidString, title: "Add beta testers to TestFlight", dueDate: Date().addingTimeInterval(101000.0),
                     note: "v0.9 out on Friday")
        ]
}
