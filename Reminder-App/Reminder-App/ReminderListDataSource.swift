//
//  ReminderListDataSource.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 15/07/2021.
//

import UIKit
import EventKit

class ReminderListDataSource: NSObject {
    
    typealias ReminderCompletedAction = (Int) -> Void
    typealias ReminderDeletedAction = () -> Void
    typealias RemindersChangedAction = () -> Void
    
    // MARK: Public Properties
    var filter: Filter = .today
    var filteredReminders: [Reminder] {
        return reminders.filter { filter.shouldInclude(date: $0.dueDate) }.sorted { $0.dueDate < $1.dueDate }
    }
    
    var percentComplete: Double {
        guard filteredReminders.count > 0 else {
            return 1.0
        }
        
        let numComplete: Double = filteredReminders.reduce(0) {
            $0 + ($1.isComplete ? 1 : 0)
        }
        
        return numComplete / Double(filteredReminders.count)
    }
    
    // MARK: Static Properties
    static let reminderListCellIdentifier = "ReminderListCell"
    
    // MARK: Private Properties
    private var reminderCompletedAction: ReminderCompletedAction?
    private var reminderDeletedAction: ReminderDeletedAction?
    private let eventStore = EKEventStore()
    private var reminders: [Reminder] = []
    private var remindersChangedAction: RemindersChangedAction
    
    // MARK: Initializers
    init(reminderCompletedAction: @escaping ReminderCompletedAction,
         reminderDeletedAction: @escaping ReminderDeletedAction,
         remindersChangedAction: @escaping RemindersChangedAction) {
        
        self.reminderCompletedAction = reminderCompletedAction
        self.reminderDeletedAction = reminderDeletedAction
        self.remindersChangedAction = remindersChangedAction
        
        super.init()
        
        requestAccess {
            (authorized) in
            if authorized {
                self.readAllReminders()
            }
        }
    }
    
    // MARK: Deinitializers
    deinit {
        NotificationCenter.default.removeObserver(self, name: .EKEventStoreChanged, object: self.eventStore)
    }
    
    // MARK: Public Methods
    func update(_ reminder: Reminder, at row: Int, completion: (Bool) -> Void) {
        saveReminder(reminder) {
            (id) in
            let success = id != nil
            let index = self.index(for: row)
            reminders[index] = reminder
            
            completion(success)
        }
    }
    
    func reminder(at row: Int) -> Reminder {
        filteredReminders[row]
    }
    
    func add(_ reminder: Reminder, completion: (Int?) -> Void) {
        saveReminder(reminder) {
            (id) in
            
            if let id = id {
                let reminder = Reminder(id: id,
                                        title: reminder.title,
                                        dueDate: reminder.dueDate,
                                        note: reminder.note,
                                        isComplete: reminder.isComplete)
                reminders.insert(reminder, at: 0)
                let index = filteredReminders.firstIndex { $0.id == id }
                
                completion(index)
            } else {
                completion(nil)
            }
        }
    }
    
    func delete(at row: Int, completion: (Bool) -> Void) {
        let reminder = self.reminder(at: row)
        
        removeReminder(with: reminder.id) {
            (success) in
            if success {
                let index = self.index(for: row)
                reminders.remove(at: index)
            }
            
            completion(success)
        }
    }
    
    func index(for filteredIndex: Int) -> Int {
        let filteredReminder = filteredReminders[filteredIndex]
        
        guard let index = reminders.firstIndex(where: { $0.id == filteredReminder.id }) else {
            return 0
        }
        
        return index
    }
    
    @objc
    func storeChanged(_ notification: NSNotification) {
        requestAccess {
            (authorized) in
            if authorized {
                self.readAllReminders()
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.storeChanged(_:)),
                                                       name: .EKEventStoreChanged,
                                                       object: self.eventStore)
            }
        }
    }
    
    enum Filter: Int {
        case today
        case future
        case all
        
        // MARK: Public Methods
        func shouldInclude(date: Date) -> Bool {
            let isInToday = Locale.current.calendar.isDateInToday(date)
            
            switch self {
            case .today:
                return isInToday
            case .future:
                return (date > Date()) && !isInToday
            case .all:
                return true
            }
        }
    }
}

// MARK: Data Source Methods
extension ReminderListDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderListCell.reusableIdentifier, for: indexPath)
                as? ReminderListCell else {
            return UITableViewCell()
        }
        
        let reminder = reminder(at: indexPath.row)
        let dateText = reminder.dueDateTimeText(for: filter)
        
        cell.configure(title: reminder.title, dateText: dateText, isDone: reminder.isComplete) {
            var modifiedReminder = reminder
            
            modifiedReminder.isComplete.toggle()
            self.update(modifiedReminder, at: indexPath.row) {
                success in
                
                if success {
                    self.reminderCompletedAction?(indexPath.row)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        delete(at: indexPath.row) {
            success in
            if success {
                DispatchQueue.main.async {
                    tableView.performBatchUpdates({
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }) {
                        (_) in
                        tableView.reloadData()
                    }
                    
                    self.reminderDeletedAction?()
                }
            }
        }
    }
}

extension Reminder {
    
    // MARK: Static Properties
    static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        return timeFormatter
    }()
    
    static let futureDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    static let todayDateFormatter: DateFormatter = {
        let format = NSLocalizedString("'Today at '%@", comment: "format string for dates occurring today")
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = String(format: format, "hh:mm a")
        
        return dateFormatter
    }()
    
    // MARK: Public Methods
    func dueDateTimeText(for filter: ReminderListDataSource.Filter) -> String {
        let isInToday = Locale.current.calendar.isDateInToday(dueDate)
        
        switch filter {
        case .today:
            return Self.timeFormatter.string(from: dueDate)
        case .future:
            return Self.futureDateFormatter.string(from: dueDate)
        case .all:
            if isInToday {
                return Self.todayDateFormatter.string(from: dueDate)
            } else {
                return Self.futureDateFormatter.string(from: dueDate)
            }
        }
    }
}

extension ReminderListDataSource {
    
    // MARK: Private Properties
    private var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }
    
    // MARK: Private Mehthods
    private func requestAccess(completion: @escaping (Bool) -> Void) {
        let currentStatus = EKEventStore.authorizationStatus(for: .reminder)
        
        guard currentStatus == .notDetermined else {
            completion(currentStatus == .authorized)
            return
        }
        
        eventStore.requestAccess(to: .reminder) {
            (success, error) in
            completion(success)
        }
    }
    
    private func readAllReminders() {
        guard isAvailable else {
            return
        }
        
        let predicate = eventStore.predicateForReminders(in: nil)
        
        eventStore.fetchReminders(matching: predicate) {
            (ekReminders) in
            guard let ekReminders = ekReminders else {
                self.reminders = []
                return
            }
            
            self.reminders = ekReminders.compactMap {
                guard let dueDate = $0.alarms?.first?.absoluteDate else {
                    return nil
                }
                
                let reminder = Reminder(id: $0.calendarItemIdentifier,
                                        title: $0.title,
                                        dueDate: dueDate,
                                        note: $0.notes,
                                        isComplete: $0.isCompleted)
                
                return reminder
            }
            
            self.remindersChangedAction()
        }
    }
    
    private func readReminder(with id: String, completion: (EKReminder?) -> Void) {
        guard isAvailable else {
            completion(nil)
            return
        }
        
        guard let calendarItem = eventStore.calendarItem(withIdentifier: id),
              let ekReminder = calendarItem as? EKReminder else {
            return
        }
        
        completion(ekReminder)
    }
    
    private func saveReminder(_ reminder: Reminder, completion: (String?) -> Void) {
        guard isAvailable else {
            completion(nil)
            return
        }
        
        readReminder(with: reminder.id) {
            (ekReminder) in
            
            let ekReminder = ekReminder ?? EKReminder(eventStore: self.eventStore)
            ekReminder.title = reminder.title
            ekReminder.notes = reminder.note
            ekReminder.isCompleted = reminder.isComplete
            ekReminder.calendar = self.eventStore.defaultCalendarForNewReminders()
            
            ekReminder.alarms?.forEach {
                alarm in
                
                if let absoluteDate = alarm.absoluteDate {
                    let comparison = Locale.current.calendar.compare(reminder.dueDate, to: absoluteDate, toGranularity: .minute)
                    
                    if comparison != .orderedSame {
                        ekReminder.removeAlarm(alarm)
                    }
                }
            }
            
            if !ekReminder.hasAlarms {
                ekReminder.addAlarm(EKAlarm(absoluteDate: reminder.dueDate))
            }
            
            do {
                try self.eventStore.save(ekReminder, commit: true)
                completion(ekReminder.calendarItemIdentifier)
            } catch {
                completion(nil)
            }
        }
    }
    
    private func removeReminder(with id: String, completion: (Bool) -> Void) {
        guard isAvailable else {
            completion(false)
            return
        }
        
        readReminder(with: id) {
            (ekReminder) in
            
            guard let ekReminder = ekReminder else {
                completion(false)
                return
            }
            
            do {
                try self.eventStore.remove(ekReminder, commit: true)
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
}
