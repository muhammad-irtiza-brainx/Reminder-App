//
//  UITableView.swift
//  Reminder-App
//
//  Created by BrainX Technologies 11 on 16/07/2021.
//

import UIKit

extension UITableViewCell {
    
    static var reusableIdentifier: String {
        String(describing: self)
    }
}
