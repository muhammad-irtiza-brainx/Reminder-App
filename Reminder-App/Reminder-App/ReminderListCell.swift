//
//  ReminderListCell.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 14/07/2021.
//

import UIKit

class ReminderListCell: UITableViewCell {
    
    typealias DoneButtonAction = () -> Void
    
    //MARK:- Outlets
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    //MARK:- Private Property
//    private var doneButtonAction: DoneButtonAction?
    var doneButtonAction: DoneButtonAction?
    
    //MARK:- Actions
    @IBAction
    func doneButtonTriggered(_ sender: UIButton) {
        doneButtonAction?()
    }
    
    //MARK:- Instance Methods
    func configure(title: String, dateText: String, isDone: Bool, doneButtonAction: @escaping DoneButtonAction) {
        titleLabel.text = title
        dateLabel.text = dateText
        
        let image = isDone ? UIImage(systemName: Images.circleFilledImage) : UIImage(systemName: Images.circleUnfilledImage)
        doneButton.setBackgroundImage(image, for: .normal)
        
        self.doneButtonAction = doneButtonAction
        
    }
}
