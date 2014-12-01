//
//  TableViewCell.swift
//  Help
//
//  Created by demo on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var nameField: UILabel!
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var messageText: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
