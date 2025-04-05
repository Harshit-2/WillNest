//
//  MediflowViewController.swift
//  WillNest
//
//  Created by Harshit on 3/31/25.
//

import UIKit

class MediflowViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var predictionLabel: UILabel!
    
    var diseaseModel: DiseaseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        diseaseModel = DiseaseModel()
    }
}

extension MediflowViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let userInput = searchBar.text?.lowercased() else { return }
        
        let symptomsArray = userInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        if let predictedDisease = diseaseModel.predictDisease(from: symptomsArray) {
            DispatchQueue.main.async {
                self.predictionLabel.text = "Predicted Disease: \(predictedDisease)"
            }
        } else {
            DispatchQueue.main.async {
                self.predictionLabel.text = "No prediction available."
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
