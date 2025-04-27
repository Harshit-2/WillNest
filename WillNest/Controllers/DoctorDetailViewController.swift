//
//  DoctorDetailViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/13/25.
//


import UIKit

class DoctorDetailViewController: UIViewController {
    
    private let doctor: Doctor
    private let timeSlots = ["9:00 AM", "10:30 AM", "1:00 PM", "2:30 PM", "4:00 PM"]
    private var selectedTimeSlot: Int? = nil
    
    private let doctorDetailView = DoctorDetailView()
    
    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Doctor Profile"
        
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        view.addSubview(doctorDetailView)
        
        NSLayoutConstraint.activate([
            doctorDetailView.topAnchor.constraint(equalTo: view.topAnchor),
            doctorDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doctorDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doctorDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        doctorDetailView.timeSlotCollection.dataSource = self
        doctorDetailView.timeSlotCollection.delegate = self
        
        doctorDetailView.bookAppointmentButton.addTarget(self, action: #selector(bookAppointmentTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        doctorDetailView.configure(with: doctor)
    }
    
    @objc private func bookAppointmentTapped() {
        if let selectedTimeSlot = selectedTimeSlot {
            let timeSlot = timeSlots[selectedTimeSlot]
            
            let alert = UIAlertController(
                title: "Appointment Confirmation",
                message: "Your appointment with Dr. \(doctor.name) is scheduled for today at \(timeSlot).",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Select Time Slot",
                message: "Please select a time slot for your appointment.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension DoctorDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as? TimeSlotCell else {
            fatalError("Failed to dequeue TimeSlotCell")
        }
        
        cell.configure(with: timeSlots[indexPath.item])
        cell.isSelected = indexPath.item == selectedTimeSlot
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTimeSlot = indexPath.item
        collectionView.reloadData()
    }
}
