//
//  customTableCellTableViewCell.swift
//  ios101-project5-tumblr
//
//  Created by Sadia Nawaz on 23/03/2024.
//

import UIKit

class customTableCellTableViewCell: UITableViewCell {

    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var textArea: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
