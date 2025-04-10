//
//  HomeViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 3/29/25.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var imageButtons: [UIButton]!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var testimonialCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerImageView.layer.cornerRadius = 15
        bannerImageView.clipsToBounds = true
        
        for button in imageButtons {
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.systemGray5.cgColor
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        }
        
        self.navigationItem.hidesBackButton = true
    }
        
}
