//
//  DoctorListViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/13/25.
//

import UIKit

class DoctorListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.register(DoctorCell.self, forCellReuseIdentifier: DoctorCell.identifier)
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No doctors available"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.isHidden = true
        return label
    }()
    
    private var category: DoctorCategory?
    private var doctors: [Doctor] = []
    
    init(category: DoctorCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        // Initialize with default values when created from a storyboard
        self.category = nil
        super.init(coder: coder)
    }
    
    // Method to support configuration when using segues
    func configure(with category: DoctorCategory) {
        self.category = category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        // Use optional chaining since category might be nil when initialized from storyboard
        title = category!.title + "s"
        
        setupUI()
        
        // Only fetch doctors if the category is set
        if let category = category {
            fetchDoctors()
        } else {
            // Handle the case where no category is set
            emptyStateLabel.text = "No category selected"
            emptyStateLabel.isHidden = false
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchDoctors() {
        guard let category = category else { return }
        
        loadingIndicator.startAnimating()
        
        APIService.shared.fetchDoctors(forCategory: category.title) { [weak self] doctors, error in
            guard let self = self else { return }
            
            self.loadingIndicator.stopAnimating()
            
            if let error = error {
                print("Error fetching doctors: \(error)")
                self.showErrorAlert(message: "Failed to fetch doctors. Please try again.")
                return
            }
            
            if let doctors = doctors {
                self.doctors = doctors
                self.tableView.reloadData()
                
                if doctors.isEmpty {
                    self.emptyStateLabel.isHidden = false
                } else {
                    self.emptyStateLabel.isHidden = true
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension DoctorListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoctorCell.identifier, for: indexPath) as? DoctorCell else {
            fatalError("Failed to dequeue DoctorCell")
        }
        
        let doctor = doctors[indexPath.row]
        cell.configure(with: doctor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectItemAt indexPath: IndexPath) {
        let doctor = doctors[indexPath.row]
        let doctorDetailVC = DoctorDetailViewController(doctor: doctor)
        navigationController?.pushViewController(doctorDetailVC, animated: true)
    }
}

