//
//  HistoryViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var record: Results<History>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveHistory()
        loadHistory()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HistoryDataCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    func saveHistory() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let historyData = [
            History(value: ["disease": "ChickenPox", "date": "23 March 2019"]),
            History(value: ["disease": "Angina", "date": "21 June 2019"]),
            History(value: ["disease": "Aplastic anaemia", "date": "13 October 2020"]),
            History(value: ["disease": "Bulimia nervosa", "date": "2 February 2021"]),
            History(value: ["disease": "Chest Infection", "date": "21 December 2021"]),
            History(value: ["disease": "Depresson", "date": "3 June 2022"]),
            History(value: ["disease": "Earache", "date": "3 November 2022"]),
            History(value: ["disease": "Fibroids", "date": "14 December 2022"]),
            History(value: ["disease": "Food poisoning", "date": "1 April 2023"]),
            History(value: ["disease": "Gallstones", "date": "16 August 2023"]),
            History(value: ["disease": "Haemorrhoids", "date": "18 December 2023"]),
            History(value: ["disease": "Impetigo", "date": "21 April 2024"]),
            History(value: ["disease": "Low blood pressure", "date": "7 September 2024"]),
            History(value: ["disease": "Panic disorder", "date": "25 March 2025"]),
        ]
        
        try! realm.write {
            realm.add(historyData)
        }
    }
    
    func loadHistory() {
        record = realm.objects(History.self)
        tableView.reloadData()
    }

}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! HistoryDataCell
        if let prescription = record?[indexPath.row] {
            cell.disease.text = prescription.disease
            cell.date.text = prescription.date
        }
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6
        
        let diseaseLabel = UILabel()
        diseaseLabel.text = "Disease"
        diseaseLabel.font = UIFont.boldSystemFont(ofSize: 14)
        diseaseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.text = "Time of the Year"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(diseaseLabel)
        headerView.addSubview(dateLabel)
        
        // Layout constraints (basic horizontal layout)
        NSLayoutConstraint.activate([
            diseaseLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            diseaseLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
//            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -50),
            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            dateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        
        return headerView
    }
}

