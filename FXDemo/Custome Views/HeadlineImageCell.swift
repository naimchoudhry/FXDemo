//
//  HeadlineImageCell.swift
//  FXDemo
//
//  Created by Naim on 23/01/2022.
//
import UIKit

class HeadlineImageCell: UITableViewCell {
    static let identifier = "HeadlineImageCell"
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
    override func prepareForReuse() {
        thumbImageView.image = nil
        thumbImageView.cancelImageLoad()
    }
}
