//
//  RecordCell.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit

class RecordCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dosage: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
