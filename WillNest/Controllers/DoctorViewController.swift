//
//  DoctorViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit

class DoctorViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DoctorCategoryCell.self, forCellWithReuseIdentifier: DoctorCategoryCell.identifier)
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Specialists"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose specialist to see doctors"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private var categories: [DoctorCategory] = []
    
    // Properties for segue implementation
    private let showDoctorListSegueIdentifier = "ShowDoctorList"
    private var selectedCategory: DoctorCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupCategories()
        setupUI()
        setupCollectionView()
    }
    
    private func setupCategories() {
        categories = [
            DoctorCategory(id: "cardio", title: "Cardiologist", icon: "heart.fill", description: "Heart specialists for cardiovascular care", color: UIColor.systemRed.withAlphaComponent(0.8)),
            DoctorCategory(id: "derma", title: "Dermatologist", icon: "bandage.fill", description: "Skin, hair, and nail specialists", color: UIColor.systemGreen.withAlphaComponent(0.8)),
            DoctorCategory(id: "neuro", title: "Neurologist", icon: "brain.head.profile", description: "Brain and nervous system specialists", color: UIColor.systemPurple.withAlphaComponent(0.8)),
            DoctorCategory(id: "onco", title: "Oncologist", icon: "cross.case.fill", description: "Cancer specialists for diagnosis and treatment", color: UIColor.systemBlue.withAlphaComponent(0.8)),
            DoctorCategory(id: "fm", title: "Family Medicine", icon: "person.2.fill", description: "General healthcare for individuals and families", color: UIColor.systemTeal.withAlphaComponent(0.8)),
            DoctorCategory(id: "gastro", title: "Gastroenterologist", icon: "stomach", description: "Digestive system specialists", color: UIColor.systemOrange.withAlphaComponent(0.8)),
            DoctorCategory(id: "obgyn", title: "Obstetrics and Gynaecology", icon: "figure.dress", description: "Women's health and pregnancy specialists", color: UIColor.systemPink.withAlphaComponent(0.8)),
            DoctorCategory(id: "ophth", title: "Ophthalmologist", icon: "eye.fill", description: "Eye care and vision specialists", color: UIColor.systemIndigo.withAlphaComponent(0.8)),
            DoctorCategory(id: "psych", title: "Psychiatrist", icon: "brain", description: "Mental health specialists", color: UIColor.systemYellow.withAlphaComponent(0.8)),
            DoctorCategory(id: "endo", title: "Endocrinologist", icon: "flowchart", description: "Hormone and metabolism specialists", color: UIColor.systemBrown.withAlphaComponent(0.8)),
            DoctorCategory(id: "em", title: "Emergency Medicine", icon: "bolt.fill", description: "Acute care and emergency specialists", color: UIColor.systemRed.withAlphaComponent(0.9)),
            DoctorCategory(id: "pedi", title: "Pediatrician", icon: "figure.wave.circle", description: "Children's health specialists", color: UIColor.systemCyan.withAlphaComponent(0.8)),
            DoctorCategory(id: "anes", title: "Anesthesiologist", icon: "waveform.path.ecg", description: "Pain management and surgical anesthesia specialists", color: UIColor.darkGray.withAlphaComponent(0.8)),
            DoctorCategory(id: "geri", title: "Geriatrics", icon: "figure.walk", description: "Elderly care specialists", color: UIColor.systemGray.withAlphaComponent(0.8)),
            DoctorCategory(id: "radio", title: "Radiologist", icon: "rays", description: "Medical imaging specialists", color: UIColor.systemIndigo.withAlphaComponent(0.7)),
            DoctorCategory(id: "hema", title: "Hematologist", icon: "drop.fill", description: "Blood disorders specialists", color: UIColor.systemRed.withAlphaComponent(0.7)),
            DoctorCategory(id: "infect", title: "Infectious Disease Physician", icon: "binoculars.fill", description: "Infection and communicable disease specialists", color: UIColor.systemGreen.withAlphaComponent(0.7)),
            DoctorCategory(id: "surg", title: "Surgeon", icon: "scissors", description: "Surgical procedure specialists", color: UIColor.systemBlue.withAlphaComponent(0.7)),
            DoctorCategory(id: "im", title: "Internal Medicine", icon: "heart.text.square.fill", description: "Adult disease diagnosis and treatment specialists", color: UIColor.systemPurple.withAlphaComponent(0.7)),
            DoctorCategory(id: "neph", title: "Nephrologist", icon: "kidney", description: "Kidney specialists", color: UIColor.systemOrange.withAlphaComponent(0.7)),
            DoctorCategory(id: "ortho", title: "Orthopaedist", icon: "figure.walk.motion", description: "Bone, joint, and muscle specialists", color: UIColor.systemTeal.withAlphaComponent(0.7)),
            DoctorCategory(id: "path", title: "Pathologist", icon: "microscope.fill", description: "Disease diagnosis specialists", color: UIColor.systemGray2.withAlphaComponent(0.8)),
            DoctorCategory(id: "allergy", title: "Allergist", icon: "wind", description: "Allergy and immunology specialists", color: UIColor.systemYellow.withAlphaComponent(0.7))
        ]
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // Prepare for segue to pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDoctorListSegueIdentifier {
            guard let destinationVC = segue.destination as? DoctorListViewController,
                  let category = selectedCategory else {
                return
            }
            
            destinationVC.configure(with: category)
        }
    }
}

extension DoctorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorCategoryCell.identifier, for: indexPath) as? DoctorCategoryCell else {
            fatalError("Failed to dequeue DoctorCategoryCell")
        }
        
        let category = categories[indexPath.item]
        cell.configure(with: category)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 60) / 2 // Two columns with spacing
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: showDoctorListSegueIdentifier, sender: self)
    }
}

