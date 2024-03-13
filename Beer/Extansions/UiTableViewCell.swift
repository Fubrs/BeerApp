//
//  UiTableViewCell.swift
//  Beer
//
//  Created by Nikita Chuklov on 10.03.2024.
//

import UIKit

extension UITableViewCell {
    static var reuseID: String {
        return String(describing: self)
    }
}
