//
//  HeadlineCell.swift
//  FXDemo
//
//  Created by Naim on 21/01/2022.
//

import Foundation
import UIKit

class HeadlineCell: UITableViewCell {
    static let identifier = "HeadlineCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
}
