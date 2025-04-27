//
//  CardViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit
import Cards

class CardViewController: UIViewController, CardDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let card = CardHighlight(frame: CGRect(x: 20,
                                               y: 100,
                                               width: screenWidth - 40,
                                               height: screenHeight / 5.5))

        card.title = "Prescription 1"
        card.itemTitle = "Dr. Zhang Ruonan"
        card.itemSubtitle = "Pulmonary Hypertension"
        card.backgroundImage = UIImage(named: "Background")
        card.delegate = self
        
        self.view.addSubview(card)

    }
    
    
    // MARK: - CardDelegate Method
    func cardHighlightDidTapButton(card: CardHighlight, button: UIButton) {
        performSegue(withIdentifier: "showPrescription", sender: self)
    }
}
