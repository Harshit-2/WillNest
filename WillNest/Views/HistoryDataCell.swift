//
//  HistoryDataCell.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit

class HistoryDataCell: UITableViewCell {

    @IBOutlet weak var disease: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
