//
//  ViewController.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 14/07/2021.
//

import UIKit

class ReminderListViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    @IBOutlet var progressContainerView: UIView!
    @IBOutlet var percentIncompleteView: UIView!
    @IBOutlet var percentCompleteView: UIView!
    @IBOutlet var percentCompleteHeightConstraint: NSLayoutConstraint!
    
    // MARK: Actions
    @IBAction func addButtonTriggered(_ sender: UIBarButtonItem) {
        addReminder()
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        reminderListDataSource?.filter = filter
        
        tableView.reloadData()
        self.refreshProgressView()
        refreshBackground()
    }
    
    // MARK: Private Properties
    private var reminderListDataSource: ReminderListDataSource?
    private var filter: ReminderListDataSource.Filter {
        return ReminderListDataSource.Filter(rawValue: filterSegmentedControl.selectedSegmentIndex) ?? .today
    }
    
    // MARK: Public Properties
    static let showDetailSegueIdentifier = "ShowReminderDetailSegue"
    static let reminderListCellIdentifier = "ReminderListCell"
    static let mainStoryboardName = "Main"
    static let detailViewControllerIdentifier = "ReminderDetailViewController"
    
    // MARK: Overridden Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier,
           let destination = segue.destination as? ReminderDetailViewController,
           let cell = sender as? UITableViewCell,
           
           let indexPath = tableView.indexPath(for: cell) {
            let rowIndex = indexPath.row
            
            guard let reminder = reminderListDataSource?.reminder(at: rowIndex) else {
                return
            }
            
            destination.configure(with: reminder, editAction: {
                reminder in
                self.reminderListDataSource?.update(reminder, at: rowIndex) {
                    success in
                    
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshProgressView()
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alertTitle = NSLocalizedString(ErrorMessages.cannotUpdateReminderTitle, comment: ErrorMessages.errorUpdatingReminderTitle)
                            let alertMessage = NSLocalizedString(ErrorMessages.errorInUpdatingReminder, comment: ErrorMessages.errorUpdatingReminderMessage)
                            
                            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                            let actionTitle = NSLocalizedString(ErrorMessages.okMessage, comment: ErrorMessages.okActionTitle)
                            
                            alert.addAction(UIAlertAction(title: actionTitle,
                                                          style: .default,
                                                          handler: {
                                                            _ in
                                                            self.dismiss(animated: true, completion: nil)
                                                          }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            })
        }
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminderListDataSource = ReminderListDataSource(
            reminderCompletedAction: {
                reminderIndex in
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: reminderIndex, section: 0)], with: .automatic)
                    self.refreshProgressView()
                }
            }, reminderDeletedAction: {
                DispatchQueue.main.async {
                    self.refreshProgressView()
                }
            }, remindersChangedAction: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshProgressView()
                }
            })
        
        tableView.dataSource = reminderListDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let radius = view.bounds.size.width * 0.5 * 0.7
        progressContainerView.layer.cornerRadius = radius
        progressContainerView.layer.masksToBounds = true
        self.refreshProgressView()
        refreshBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationController = navigationController,
           navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(false, animated: animated)
        }
    }
    
    // MARK: Private Methods
    private func addReminder() {
        let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
        let detailViewController: ReminderDetailViewController = storyboard.instantiateViewController(identifier: Self.detailViewControllerIdentifier)
        let reminder = Reminder(id: UUID().uuidString, title: "New Reminder", dueDate: Date())
        
        detailViewController.configure(with: reminder,
                                       isNew: true,
                                       addAction: {
                                        reminder in
                                        self.reminderListDataSource?.add(reminder, completion: {
                                            (index) in
                                            if let index = index {
                                                DispatchQueue.main.async {
                                                    self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                                    self.refreshProgressView()
                                                }
                                            }
                                        })
                                       })
        
        let navigationController = UINavigationController(rootViewController: detailViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func refreshProgressView() {
        guard let percentComplete = reminderListDataSource?.percentComplete else {
            return
        }
        
        let totalHeight = progressContainerView.bounds.size.height
        percentCompleteHeightConstraint.constant = totalHeight * CGFloat(percentComplete)
        
        UIView.animate(withDuration: 0.2) {
            self.progressContainerView.layoutSubviews()
        }
    }
    
    private func refreshBackground() {
        tableView.backgroundView = nil
        let backgroundView = UIView()
        tableView.backgroundView = backgroundView
        
        if let backgroundColors = filter.backgroundColors {
            let gradientBackgroundLayer = CAGradientLayer()
            gradientBackgroundLayer.colors = backgroundColors
            gradientBackgroundLayer.frame = tableView.frame
            
            backgroundView.layer.addSublayer(gradientBackgroundLayer)
        } else {
            backgroundView.backgroundColor = filter.substituteBackgroundColor
        }
        
        tableView.backgroundView = backgroundView
    }
}

fileprivate extension ReminderListDataSource.Filter {
    
    // MARK: Private Properties
    private var gradientBeginColor: UIColor? {
        switch self {
        case .today:
            return UIColor(named: "LIST_GradientTodayBegin")
        case .future:
            return UIColor(named: "LIST_GradientFutureBegin")
        case .all:
            return UIColor(named: "LIST_GradientAllBegin")
        }
    }
    
    private var gradientEndColor: UIColor? {
        switch self {
        case .today: return UIColor(named: "LIST_GradientTodayEnd")
        case .future: return UIColor(named: "LIST_GradientFutureEnd")
        case .all: return UIColor(named: "LIST_GradientAllEnd")
        }
    }
    
    // MARK: Public Properties
    var backgroundColors: [CGColor]? {
        guard let beginColor = gradientBeginColor, let endColor = gradientEndColor else {
            return nil
        }
        
        return [beginColor.cgColor, endColor.cgColor]
    }
    
    var substituteBackgroundColor: UIColor {
        return gradientBeginColor ?? .tertiarySystemBackground
    }
}
