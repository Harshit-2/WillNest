//
//  ss.swift
//  WillNest
//
//  Created by Harshit ‎ on 3/29/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        let titleText = "⚕️Will Nest"
        var counter = 0.0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * counter, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            counter += 1
        }
        
    }
}
