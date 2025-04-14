//
//  TestimonialCell.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/10/25.
//

import UIKit

class TestimonialCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Styling the image view
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
}
