//
//  PrescriptionViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PrescriptionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var record: [Prescription] = []
    
    struct Colors {
        // Helper function to create dynamic colors based on interface style
        static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
            return UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        }
        
        // Main background color
        static let backgroundColor = dynamicColor(
            light: UIColor(red: 246/255, green: 248/255, blue: 250/255, alpha: 1.0),
            dark: UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        )
        
        // Header background
        static let headerBackground = dynamicColor(
            light: UIColor(red: 226/255, green: 246/255, blue: 245/255, alpha: 1.0),
            dark: UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1.0)
        )
        
        // Teal accent
        static let tealAccent = dynamicColor(
            light: UIColor(red: 52/255, green: 199/255, blue: 190/255, alpha: 1.0),
            dark: UIColor(red: 48/255, green: 176/255, blue: 199/255, alpha: 1.0)
        )
        
        // Day count colors
        static let day1Color = dynamicColor(
            light: UIColor(red: 255/255, green: 111/255, blue: 145/255, alpha: 1.0),
            dark: UIColor(red: 255/255, green: 85/255, blue: 100/255, alpha: 1.0)
        )
        
        static let day1Background = dynamicColor(
            light: UIColor(red: 255/255, green: 235/255, blue: 238/255, alpha: 1.0),
            dark: UIColor(red: 50/255, green: 35/255, blue: 40/255, alpha: 1.0)
        )
        
        static let day2Color = dynamicColor(
            light: UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0),
            dark: UIColor(red: 255/255, green: 180/255, blue: 0/255, alpha: 1.0)
        )
        
        static let day2Background = dynamicColor(
            light: UIColor(red: 255/255, green: 243/255, blue: 224/255, alpha: 1.0),
            dark: UIColor(red: 51/255, green: 46/255, blue: 38/255, alpha: 1.0)
        )
        
        static let day3Color = dynamicColor(
            light: UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0),
            dark: UIColor(red: 255/255, green: 180/255, blue: 0/255, alpha: 1.0)
        )
        
        static let day3Background = dynamicColor(
            light: UIColor(red: 255/255, green: 243/255, blue: 224/255, alpha: 1.0),
            dark: UIColor(red: 51/255, green: 46/255, blue: 38/255, alpha: 1.0)
        )
        
        static let day4PlusColor = dynamicColor(
            light: UIColor(red: 52/255, green: 199/255, blue: 190/255, alpha: 1.0),
            dark: UIColor(red: 48/255, green: 176/255, blue: 199/255, alpha: 1.0)
        )
        
        static let day4PlusBackground = dynamicColor(
            light: UIColor(red: 224/255, green: 247/255, blue: 250/255, alpha: 1.0),
            dark: UIColor(red: 38/255, green: 45/255, blue: 51/255, alpha: 1.0)
        )
        
        // Card background color
        static let cardBackground = dynamicColor(
            light: .white,
            dark: UIColor(red: 36/255, green: 36/255, blue: 38/255, alpha: 1.0)
        )
        
        // Text colors
        static let primaryText = dynamicColor(
            light: .darkGray,
            dark: UIColor(red: 230/255, green: 230/255, blue: 235/255, alpha: 1.0)
        )
        
        static let secondaryText = dynamicColor(
            light: .darkGray,
            dark: UIColor(red: 180/255, green: 180/255, blue: 185/255, alpha: 1.0)
        )
        
        // Empty cell background
        static let emptyCellBackground = dynamicColor(
            light: UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0),
            dark: UIColor(red: 30/255, green: 28/255, blue: 28/255, alpha: 1.0)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        saveDataInFirestore()
        loadPrescriptions()
        configureTabBarAppearance()
        
        // Register for theme changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userInterfaceStyleDidChange),
            name: NSNotification.Name("UIApplicationDidBecomeActiveNotification"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure navigation bar to maintain appearance during scrolling
        if let navigationController = navigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Colors.backgroundColor
            
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.compactAppearance = appearance
            
            // Ensure consistent status bar style
            navigationController.navigationBar.barStyle = traitCollection.userInterfaceStyle == .dark ? .black : .default
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Prevent content from going under status bar
        tableView.contentInsetAdjustmentBehavior = .always
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    func configureTabBarAppearance() {
        if let tabBarController = tabBarController {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Colors.backgroundColor
            
            tabBarController.tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBarController.tabBar.scrollEdgeAppearance = appearance
            }
        }
    }
    
    @objc func userInterfaceStyleDidChange() {
        // Refresh UI elements when theme changes
        setupUI()
        tableView.reloadData()
        configureTabBarAppearance()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        view.backgroundColor = Colors.backgroundColor
        setupTableView()
        setupTableHeader()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tableView.backgroundColor = Colors.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
    }
    
    func setupTableHeader() {
        if let existingHeader = tableView.tableHeaderView {
            existingHeader.removeFromSuperview()
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.backgroundColor = Colors.headerBackground
        headerView.layer.cornerRadius = 12
        
        // Medication icon
        let pillIcon = UIImageView(frame: CGRect(x: 30, y: 15, width: 20, height: 20))
        pillIcon.image = UIImage(systemName: "pills.circle.fill")
        pillIcon.tintColor = Colors.tealAccent
        pillIcon.contentMode = .scaleAspectFit
        
        // Medication label
        let medicationLabel = createHeaderLabel(text: "Medication", x: 60)
        
        // Duration icon
        let durationIcon = UIImageView(frame: CGRect(x: tableView.bounds.width - 110, y: 15, width: 20, height: 20))
        durationIcon.image = UIImage(systemName: "clock.fill")
        durationIcon.tintColor = Colors.tealAccent
        durationIcon.contentMode = .scaleAspectFit
        
        // Duration label
        let durationLabel = createHeaderLabel(text: "Duration", x: tableView.bounds.width - 85)
        
        // Add all to header
        headerView.addSubview(pillIcon)
        headerView.addSubview(medicationLabel)
        headerView.addSubview(durationIcon)
        headerView.addSubview(durationLabel)
        
        tableView.tableHeaderView = headerView
    }
    
    private func createHeaderLabel(text: String, x: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x: x, y: 15, width: 100, height: 20))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Colors.tealAccent
        return label
    }
    
    func saveDataInFirestore() {
        guard let user = Auth.auth().currentUser else {
            print("No user is signed in.")
            return
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
        
        for prescription in prescriptions {
            let data: [String: Any] = [
                "drugName": prescription.drugName,
                "dosage": prescription.dosage,
                "days": prescription.days,
                "timestamp": Timestamp()
            ]
            
            // Save data to the "userData" collection for the current signed-in user under "prescriptions" subcollection
            db.collection("userData")
                .document(user.uid)
                .collection("prescriptions")
                .addDocument(data: data) { error in
                    if let error = error {
                        print("Error adding prescription: \(error.localizedDescription)")
                    } else {
                        print("Prescription added successfully!")
                    }
                }
        }
    }
    
    func loadPrescriptions() {
        guard let user = Auth.auth().currentUser else {
            print("No user is signed in.")
            return
        }
        
        db.collection("userData")
            .document(user.uid)
            .collection("prescriptions")
            .order(by: "timestamp", descending: true) // Optional: order by timestamp
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error retrieving prescriptions: \(error.localizedDescription)")
                    return
                }
                
                self.record = []
                
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        if let drugName = data["drugName"] as? String,
                           let dosage = data["dosage"] as? String,
                           let days = data["days"] as? Int {
                            let prescription = Prescription(drugName: drugName, dosage: dosage, days: days)
                            self.record.append(prescription)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }
    
    // Helper function to get the appropriate colors based on the number of days
    func getDayColors(_ days: Int) -> (color: UIColor, background: UIColor) {
        switch days {
        case 1:
            return (Colors.day1Color, Colors.day1Background)
        case 2:
            return (Colors.day2Color, Colors.day2Background)
        case 3:
            return (Colors.day3Color, Colors.day3Background)
        default:
            return (Colors.day4PlusColor, Colors.day4PlusBackground)
        }
    }
}

// MARK: - UITableViewDataSource
extension PrescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.isEmpty ? 1 : record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if record.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "EmptyCell")
            cell.textLabel?.text = "No prescriptions found."
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = Colors.secondaryText
            cell.backgroundColor = Colors.emptyCellBackground
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! RecordCell
        
        // Configure the cell so it displays the actual values from the Prescription object
        configureCell(cell, with: record[indexPath.row])
        
        return cell
    }
    
    private func configureCell(_ cell: RecordCell, with prescription: Prescription) {
        // Reset any existing subviews from previous reuse
        for view in cell.contentView.subviews where view.tag == 100 {
            view.removeFromSuperview()
        }
        
        let dayColors = getDayColors(prescription.days)
        
        // Main card view setup
        let cardView = UIView()
        cardView.tag = 100
        cardView.backgroundColor = Colors.cardBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.3 : 0.1
        cardView.layer.shadowRadius = 3
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
            cardView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5),
        ])
        
        // Left indicator
        let leftIndicator = UIView()
        leftIndicator.backgroundColor = dayColors.color
        leftIndicator.layer.cornerRadius = 1
        leftIndicator.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(leftIndicator)
        
        NSLayoutConstraint.activate([
            leftIndicator.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            leftIndicator.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            leftIndicator.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            leftIndicator.widthAnchor.constraint(equalToConstant: 4),
        ])
        
        // Pill icon container
        let pillContainer = UIView()
        pillContainer.backgroundColor = dayColors.background
        pillContainer.layer.cornerRadius = 25
        pillContainer.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(pillContainer)
        
        NSLayoutConstraint.activate([
            pillContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            pillContainer.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            pillContainer.widthAnchor.constraint(equalToConstant: 50),
            pillContainer.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let pillIcon = UIImageView(image: UIImage(systemName: "pills.fill"))
        pillIcon.tintColor = dayColors.color
        pillIcon.contentMode = .scaleAspectFit
        pillIcon.translatesAutoresizingMaskIntoConstraints = false
        pillContainer.addSubview(pillIcon)
        
        NSLayoutConstraint.activate([
            pillIcon.centerXAnchor.constraint(equalTo: pillContainer.centerXAnchor),
            pillIcon.centerYAnchor.constraint(equalTo: pillContainer.centerYAnchor),
            pillIcon.widthAnchor.constraint(equalToConstant: 26),
            pillIcon.heightAnchor.constraint(equalToConstant: 26),
        ])
        
        // Configure medication name label with actual drug name
        let nameLabel = cell.name!
        nameLabel.text = prescription.drugName   // Set to actual drug name
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = Colors.primaryText
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: pillContainer.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
        ])
        
        // Configure dosage label with actual dosage
        let dosageLabel = cell.dosage!
        dosageLabel.text = prescription.dosage   // Set to actual dosage
        dosageLabel.font = UIFont.systemFont(ofSize: 14)
        dosageLabel.textColor = Colors.secondaryText
        dosageLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dosageLabel)
        
        NSLayoutConstraint.activate([
            dosageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dosageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
        ])
        
        // Days container badge with proper padding
        let daysContainer = UIView()
        daysContainer.backgroundColor = dayColors.background
        daysContainer.layer.cornerRadius = 16
        daysContainer.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(daysContainer)
        
        let durationLabel = cell.duration!
        durationLabel.text = "\(prescription.days) days"
        durationLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        durationLabel.textColor = dayColors.color
        durationLabel.textAlignment = .center
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        daysContainer.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            daysContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            daysContainer.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            daysContainer.heightAnchor.constraint(equalToConstant: 32),
            
            durationLabel.leadingAnchor.constraint(equalTo: daysContainer.leadingAnchor, constant: 10),
            durationLabel.trailingAnchor.constraint(equalTo: daysContainer.trailingAnchor, constant: -10),
            durationLabel.topAnchor.constraint(equalTo: daysContainer.topAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: daysContainer.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension PrescriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        if record.isEmpty { return }
        //        let prescription = record[indexPath.row]
        //
        //        let alert = UIAlertController(
        //            title: prescription.drugName,
        //            message: "Dosage: \(prescription.dosage)\nDuration: \(prescription.days) days",
        //            preferredStyle: .alert
        //        )
        //
        //        alert.addAction(UIAlertAction(title: "OK", style: .default))
        //        present(alert, animated: true)
    }
    
    // Adapt to theme changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // Update UI for the new appearance
            setupUI()
            tableView.reloadData()
            configureTabBarAppearance()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Ensure tab bar appearance stays consistent during scrolling
        if let tabBarController = tabBarController {
            tabBarController.tabBar.backgroundColor = Colors.backgroundColor
        }
    }
}
