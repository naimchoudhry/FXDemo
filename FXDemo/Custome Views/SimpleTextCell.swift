//
//  SimpleTextCell.swift
//  FXDemo
//
//  Created by Naim on 22/01/2022.
//
import UIKit

class SimpleTextCell: UITableViewCell {
    static let identifier = "SimpleTextCell"
    static let defaultInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    @IBOutlet weak var simpleTextLabel: UILabel!
    @IBOutlet weak var leftInset: NSLayoutConstraint!
    @IBOutlet weak var rightInset: NSLayoutConstraint!
    @IBOutlet weak var topInset: NSLayoutConstraint!
    @IBOutlet weak var bottomInset: NSLayoutConstraint!
    
    var insets: UIEdgeInsets = SimpleTextCell.defaultInsets {
        didSet {
            leftInset.constant = insets.left
            rightInset.constant = insets.right
            topInset.constant = insets.top
            bottomInset.constant = insets.bottom
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        insets = SimpleTextCell.defaultInsets
        simpleTextLabel.numberOfLines = 0
        simpleTextLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        simpleTextLabel.textColor = .label
        simpleTextLabel.textAlignment = .left 
    }
}
