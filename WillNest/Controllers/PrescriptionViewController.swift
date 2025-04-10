//
//  Prescription.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit
import RealmSwift

class PrescriptionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var record: Results<Prescription>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveDataToRealm()
        loadPrescriptions()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    func saveDataToRealm() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let prescriptions = [
            Prescription(value: ["drugName": "Amoxicillin", "dosage": "1 Morning, 1 Night", "days": 3]),
            Prescription(value: ["drugName": "Ciprofloxacin", "dosage": "1 Morning, 1 Evening", "days": 3]),
            Prescription(value: ["drugName": "Azithromycin", "dosage": "1 Evening, 1 Night", "days": 2]),
            Prescription(value: ["drugName": "Omeprazole", "dosage": "1 Morning", "days": 4]),
            Prescription(value: ["drugName": "Penicillin", "dosage": "1 Morning, 1 Afternoon", "days": 1]),
            Prescription(value: ["drugName": "Ibuprofen", "dosage": "1 Evening, 1 Night", "days": 3]),
            Prescription(value: ["drugName": "Naproxen", "dosage": "1 Afternoon, 1 Night", "days": 2]),
            Prescription(value: ["drugName": "Diclofenac", "dosage": "1 Morning, 1 Night", "days": 2]),
            Prescription(value: ["drugName": "Metformin", "dosage": "1 Noon", "days": 5]),
        ]
        
        try! realm.write {
            realm.add(prescriptions)
        }
    }
    
    func loadPrescriptions() {
        record = realm.objects(Prescription.self)
        tableView.reloadData()
    }
    
}

extension PrescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! RecordCell
        if let prescription = record?[indexPath.row] {
            cell.name.text = prescription.drugName
            cell.dosage.text = prescription.dosage
            cell.duration.text = "\(prescription.days)"
        }
        return cell
    }
    
}

extension PrescriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6
        
        let drugLabel = UILabel()
        drugLabel.text = "Drug Name"
        drugLabel.font = UIFont.boldSystemFont(ofSize: 14)
        drugLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dosageLabel = UILabel()
        dosageLabel.text = "Dosage"
        dosageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        dosageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let daysLabel = UILabel()
        daysLabel.text = "Days"
        daysLabel.font = UIFont.boldSystemFont(ofSize: 14)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(drugLabel)
        headerView.addSubview(dosageLabel)
        headerView.addSubview(daysLabel)
        
        // Layout constraints (basic horizontal layout)
        NSLayoutConstraint.activate([
            drugLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            drugLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            dosageLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            dosageLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            daysLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            daysLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        
        return headerView
    }
}
