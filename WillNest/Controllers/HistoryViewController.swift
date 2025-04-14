//
//  HistoryViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var record: [History] = []
    
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
//        saveHistoryInFirestore()
        loadHistory()
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HistoryDataCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tableView.backgroundColor = Colors.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        
        setupTableHeader()
    }
    
    func setupTableHeader() {
        if let existingHeader = tableView.tableHeaderView {
            existingHeader.removeFromSuperview()
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.backgroundColor = Colors.headerBackground
        headerView.layer.cornerRadius = 12
        
        let icon = UIImageView(frame: CGRect(x: 30, y: 15, width: 20, height: 20))
        icon.image = UIImage(systemName: "cross.case.fill")
        icon.tintColor = Colors.tealAccent
        icon.contentMode = .scaleAspectFit
        
        let label = UILabel(frame: CGRect(x: 60, y: 15, width: 200, height: 20))
        label.text = "Medical History"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Colors.tealAccent
        
        headerView.addSubview(icon)
        headerView.addSubview(label)
        
        tableView.tableHeaderView = headerView
    }
    
    func loadHistory() {
        guard let user = Auth.auth().currentUser else {
            print("No user is signed in.")
            return
        }
        
        db.collection("userData")
            .document(user.uid)
            .collection("history")
            .order(by: "timestamp", descending: true) // Optional: order by timestamp
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error retrieving history: \(error.localizedDescription)")
                    return
                }
                
                self.record = []
                
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        if let disease = data["disease"] as? String,
                           let date = data["date"] as? String {
                            let history = History(disease: disease, date: date)
                            self.record.append(history)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }
    
    
    func saveHistoryInFirestore() {
        guard let user = Auth.auth().currentUser else {
            print("No user is signed in.")
            return
        }
        
        let historyData = [
            History(value: ["disease": "ChickenPox", "date": "23 March 2019"]),
            History(value: ["disease": "Angina", "date": "21 June 2019"]),
            History(value: ["disease": "Aplastic anaemia", "date": "13 October 2020"]),
            History(value: ["disease": "Bulimia nervosa", "date": "2 February 2021"]),
            History(value: ["disease": "Chest Infection", "date": "21 December 2021"]),
            History(value: ["disease": "Depression", "date": "3 June 2022"]),
            History(value: ["disease": "Earache", "date": "3 November 2022"]),
            History(value: ["disease": "Fibroids", "date": "14 December 2022"]),
            History(value: ["disease": "Food poisoning", "date": "1 April 2023"]),
            History(value: ["disease": "Gallstones", "date": "16 August 2023"]),
            History(value: ["disease": "Haemorrhoids", "date": "18 December 2023"]),
            History(value: ["disease": "Impetigo", "date": "21 April 2024"]),
            History(value: ["disease": "Low blood pressure", "date": "7 September 2024"]),
            History(value: ["disease": "Panic disorder", "date": "25 March 2025"]),
        ]
        
        for history in historyData {
            let data: [String: Any] = [
                "disease": history.disease,
                "date": history.date,
                "timestamp": Timestamp()
            ]
            
            // Save data to the "userData" collection for the current signed-in user
            db.collection("userData").document(user.uid).collection("history").addDocument(data: data) { error in
                if let error = error {
                    print("Error adding history: \(error.localizedDescription)")
                } else {
                    print("History added successfully!")
                }
            }
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.isEmpty ? 1 : record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if record.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "EmptyCell")
            cell.textLabel?.text = "No history found."
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = Colors.secondaryText
            cell.backgroundColor = Colors.emptyCellBackground
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! HistoryDataCell
        let history = record[indexPath.row]
        
        for view in cell.contentView.subviews where view.tag == 100 {
            view.removeFromSuperview()
        }
        
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
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = Colors.headerBackground
        iconContainer.layer.cornerRadius = 25
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(iconContainer)
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            iconContainer.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 50),
            iconContainer.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let icon = UIImageView(image: UIImage(systemName: "cross.circle.fill"))
        icon.tintColor = Colors.tealAccent
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 26),
            icon.heightAnchor.constraint(equalToConstant: 26),
        ])
        
        let diseaseLabel = cell.disease!
        diseaseLabel.text = history.disease
        diseaseLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        diseaseLabel.textColor = Colors.primaryText
        diseaseLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(diseaseLabel)
        
        NSLayoutConstraint.activate([
            diseaseLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 15),
            diseaseLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
        ])
        
        let dateLabel = cell.date!
        dateLabel.text = history.date
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = Colors.secondaryText
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: diseaseLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: diseaseLabel.bottomAnchor, constant: 6),
        ])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
