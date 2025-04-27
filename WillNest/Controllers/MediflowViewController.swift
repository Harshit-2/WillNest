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
    let gradientLayer = CAGradientLayer()
    let shadowLayer = CALayer()
    
    // Constants for layout
    private let leftRightPadding: CGFloat = 16 // Safe area padding
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        configureSearchBar()
        
        diseaseModel = DiseaseModel()
        self.navigationItem.hidesBackButton = true
        
        // Add right bar button for info/help
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(showInfo))
        infoButton.tintColor = UIColor(red: 0, green: 0.8, blue: 0.95, alpha: 1.0) // Matching cyan color
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply gradient to the background
        gradientLayer.frame = view.bounds
        
        // Ensure search bar respects safe area
        if let searchBarFrame = searchBar?.frame {
            searchBar.frame = CGRect(
                x: leftRightPadding,
                y: searchBarFrame.origin.y,
                width: view.frame.width - (leftRightPadding * 2),
                height: searchBarFrame.height
            )
        }
        
        // Round search bar corners
        searchBar.layer.cornerRadius = 12
        searchBar.clipsToBounds = true
    }
    
    private func setupUI() {
        // Configure background gradient - light blue to white as shown in screenshot
        gradientLayer.colors = [
            UIColor(red: 0.94, green: 0.98, blue: 1.0, alpha: 1.0).cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add instructions label with proper padding
        let instructionsLabel = UILabel()
        instructionsLabel.text = "Enter symptoms separated by commas"
        instructionsLabel.textColor = UIColor.darkGray
        instructionsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        instructionsLabel.textAlignment = .center
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionsLabel)
        
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightPadding),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightPadding)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        // Add proper padding around the table
        tableView.contentInset = UIEdgeInsets(top: 10, left: leftRightPadding, bottom: 20, right: leftRightPadding)
        
        // Ensure table cells don't go to the edge
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Fever, headache"
        searchBar.backgroundImage = UIImage() // Remove default background
        
        // Update search bar layout to respect safe areas
        searchBar.setPositionAdjustment(UIOffset(horizontal: leftRightPadding/2, vertical: 0), for: .search)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -leftRightPadding/2, vertical: 0), for: .clear)
        
        // Apply custom styling
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            
            // Add search icon padding
            if let leftView = textField.leftView {
                leftView.frame = CGRect(
                    x: leftView.frame.origin.x + leftRightPadding/2,
                    y: leftView.frame.origin.y,
                    width: leftView.frame.width,
                    height: leftView.frame.height
                )
            }
            
            // Apply styling as shown in screenshot
            textField.layer.borderWidth = 0.5
            textField.layer.borderColor = UIColor.systemGray4.cgColor
            textField.layer.shadowColor = UIColor.black.cgColor
            textField.layer.shadowOffset = CGSize(width: 0, height: 1)
            textField.layer.shadowRadius = 2
            textField.layer.shadowOpacity = 0.1
        }
    }
    
    @objc func showInfo() {
        let alertController = UIAlertController(
            title: "How to Use",
            message: "Enter your symptoms separated by commas (e.g., 'fever, cough, headache'). The app will analyze your symptoms and provide possible medical conditions. This is for informational purposes only and not a substitute for professional medical advice.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Got it", style: .default))
        present(alertController, animated: true)
    }
}

extension MediflowViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let userInput = searchBar.text, !userInput.isEmpty else {
            showEmptyInputAlert()
            return
        }
        
        let symptomsArray = userInput
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        
        // Show loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        // Process prediction with slight delay to show activity
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.topPredictions = self.diseaseModel.predictTopDiseases(from: symptomsArray)
            
            // Animate the table view update
            UIView.transition(with: self.tableView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() },
                              completion: nil)
            
            activityIndicator.removeFromSuperview()
        }
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
    
    private func showEmptyInputAlert() {
        let alert = UIAlertController(
            title: "No Symptoms Entered",
            message: "Please enter at least one symptom to analyze",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Table View Data Source methods

extension MediflowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topPredictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prediction = topPredictions[indexPath.row]
        let percentage = Int(prediction.confidence * 100)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        // Apply styling to cell
        applyStyleToCell(cell, forRowAt: indexPath, percentage: percentage, prediction: prediction)
        
        return cell
    }
    
    private func applyStyleToCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath, percentage: Int, prediction: Prediction) {
        // Base styling
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = .clear
        
        // Color based on screenshot (all cells using green for progress)
        let confidenceColor = UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0) // Green
        
        // Different styling for top result
        if indexPath.row == 0 {
            // Light blue highlight for first cell as shown in screenshot
            cell.contentView.backgroundColor = UIColor(red: 0.85, green: 0.95, blue: 1.0, alpha: 1.0)
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor(red: 0, green: 0.8, blue: 0.95, alpha: 0.5).cgColor
            
            // Configure text styling - light blue text
            cell.textLabel?.textColor = UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1.0)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        } else {
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.systemGray4.cgColor
            
            // Configure text styling - gray text
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        
        // Create custom content layout matching screenshot
        cell.textLabel?.text = prediction.disease.capitalized
        
        // Add confidence indicator (circular progress) as shown in screenshot
        if let existingViews = cell.contentView.viewWithTag(999) {
            existingViews.removeFromSuperview()
        }
        
        let confidenceView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        confidenceView.tag = 999
        
        // Circle background
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 27, y: 20),
                                     radius: 19,
                                     startAngle: 0,
                                     endAngle: CGFloat.pi * 2,
                                     clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.systemGray5.cgColor
        circleLayer.lineWidth = 3.0
        confidenceView.layer.addSublayer(circleLayer)
        
        // Progress indicator - only partial circle on top right
        let progressLayer = CAShapeLayer()
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + (CGFloat.pi / 2) * (CGFloat(percentage) / 25.0)
        let progressPath = UIBezierPath(arcCenter: CGPoint(x: 27, y: 20),
                                       radius: 19,
                                       startAngle: startAngle,
                                       endAngle: endAngle,
                                       clockwise: true)
        progressLayer.path = progressPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = confidenceColor.cgColor
        progressLayer.lineWidth = 3.0
        progressLayer.lineCap = .round
        confidenceView.layer.addSublayer(progressLayer)
        
        // Percentage label
        let percentLabel = UILabel(frame: confidenceView.bounds)
        percentLabel.textAlignment = .center
        percentLabel.text = "\(percentage)%"
        percentLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        percentLabel.textColor = confidenceColor
        confidenceView.addSubview(percentLabel)
        
        cell.accessoryView = confidenceView
        
        // Add selection style
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.9, green: 0.97, blue: 1.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 // Match height from screenshot
    }
}

// MARK: - Table View Delegate methods

extension MediflowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !topPredictions.isEmpty else { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        // Potential Conditions label
        let titleLabel = UILabel()
        titleLabel.text = "Potential Conditions"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = UIColor(red: 0, green: 0.8, blue: 0.95, alpha: 1.0) // Bright cyan color from screenshot
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8)
        ])
        
        // Add disclaimer label
        let disclaimerLabel = UILabel()
        disclaimerLabel.text = "For informational purposes only"
        disclaimerLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        disclaimerLabel.textColor = UIColor.darkGray
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(disclaimerLabel)
        
        NSLayoutConstraint.activate([
            disclaimerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            disclaimerLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return topPredictions.isEmpty ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let prediction = topPredictions[indexPath.row]
        showDiseaseDetail(for: prediction)
    }
    
    private func showDiseaseDetail(for prediction: Prediction) {
        let alert = UIAlertController(
            title: prediction.disease.capitalized,
            message: "Confidence: \(Int(prediction.confidence * 100))%\n\nThis is a placeholder for detailed information about \(prediction.disease). In a complete implementation, this would show symptoms, treatments, and when to seek medical attention.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        alert.addAction(UIAlertAction(title: "Learn More", style: .default, handler: { _ in
            // This would typically open a web page or another view with more information
        }))
        
        present(alert, animated: true)
    }
}
