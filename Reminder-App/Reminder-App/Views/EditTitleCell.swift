//
//  EditTitleCell.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//
import UIKit

class EditTitleCell: UITableViewCell {
    
    typealias TitleChangeAction = (String) -> Void
    
    // MARK: Outlets
    @IBOutlet var titleTextField: UITextField!
    
    // MARK: Private Properties
    private var titleChangeAction: TitleChangeAction?
    
    // MARK: Overridden Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField?.delegate = self
    }
    
    // MARK: Public Methods
    func configure(title: String, changeAction: @escaping TitleChangeAction) {
        titleTextField.text = title
        self.titleChangeAction = changeAction
    }
}

// MARK: Data Source Methods
extension EditTitleCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let originalText = textField.text {
            let title = (originalText as NSString).replacingCharacters(in: range, with: string)
            titleChangeAction?(title)
        }
        
        return true
    }
}
