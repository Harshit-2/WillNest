//
//  MediflowViewController.swift
//  WillNest
//
//  Created by Harshit on 3/31/25.
//

import UIKit

class MediflowViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var diseaseModel: DiseaseModel!
    var topPredictions: [Prediction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "BrandLightBlue")
        
        diseaseModel = DiseaseModel()
        self.navigationItem.hidesBackButton = true
    }
}

extension MediflowViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let userInput = searchBar.text else { return }
        let symptomsArray = userInput
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }

        topPredictions = diseaseModel.predictTopDiseases(from: symptomsArray)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty == true {
            topPredictions = []
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


//MARK: - Table View Data Source methods

extension MediflowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topPredictions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prediction = topPredictions[indexPath.row]
        let percentage = Int(prediction.confidence * 100)

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)

        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.systemGray4.cgColor
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .white

        cell.textLabel?.textColor = UIColor(named: "BrandBlue")
        cell.textLabel?.font = indexPath.row == 0
            ? UIFont.systemFont(ofSize: 18, weight: .bold)
            : UIFont.systemFont(ofSize: 18, weight: .regular)
        cell.textLabel?.text = "\(prediction.disease.capitalized) — \(percentage)%"

        return cell
    }
}


//MARK: - Table View Delegate methods

extension MediflowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return topPredictions.isEmpty ? nil : "Predicted Diseases"
    }
}
