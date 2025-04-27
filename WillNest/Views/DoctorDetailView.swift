//
//  DoctorDetailView.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/27/25.
//

import UIKit

class DoctorDetailView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let specialtyLabel = UILabel()
    let ratingView = UIStackView()
    let ratingLabel = UILabel()
    
    let infoStackView = UIStackView()
    let experienceView = InfoRowView(title: "Experience", icon: "clock.fill")
    let locationView = InfoRowView(title: "Location", icon: "location.fill")
    let availabilityView = InfoRowView(title: "Available", icon: "calendar")
    
    let appointmentLabel = UILabel()
    let timeSlotCollection: UICollectionView
    
    let bookAppointmentButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 44)
        layout.minimumLineSpacing = 10
        timeSlotCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        profileImageView.backgroundColor = .systemGray5
        profileImageView.tintColor = .systemGray
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        
        specialtyLabel.translatesAutoresizingMaskIntoConstraints = false
        specialtyLabel.font = UIFont.systemFont(ofSize: 18)
        specialtyLabel.textColor = .systemBlue
        specialtyLabel.textAlignment = .center
        
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.axis = .horizontal
        ratingView.spacing = 4
        ratingView.alignment = .center
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 16
        
        appointmentLabel.translatesAutoresizingMaskIntoConstraints = false
        appointmentLabel.text = "Available Appointments"
        appointmentLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        timeSlotCollection.translatesAutoresizingMaskIntoConstraints = false
        timeSlotCollection.backgroundColor = .clear
        timeSlotCollection.showsHorizontalScrollIndicator = false
        timeSlotCollection.register(TimeSlotCell.self, forCellWithReuseIdentifier: "TimeSlotCell")
        
        bookAppointmentButton.translatesAutoresizingMaskIntoConstraints = false
        bookAppointmentButton.setTitle("Book Appointment", for: .normal)
        bookAppointmentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        bookAppointmentButton.backgroundColor = .systemBlue
        bookAppointmentButton.setTitleColor(.white, for: .normal)
        bookAppointmentButton.layer.cornerRadius = 10
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(specialtyLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(appointmentLabel)
        contentView.addSubview(timeSlotCollection)
        
        ratingView.addArrangedSubview(UIImageView(image: UIImage(systemName: "star.fill")))
        ratingView.addArrangedSubview(ratingLabel)
        (ratingView.arrangedSubviews.first as? UIImageView)?.tintColor = .systemYellow
        
        infoStackView.addArrangedSubview(experienceView)
        infoStackView.addArrangedSubview(locationView)
        infoStackView.addArrangedSubview(availabilityView)
        
        addSubview(bookAppointmentButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bookAppointmentButton.topAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            specialtyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            specialtyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            specialtyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ratingView.topAnchor.constraint(equalTo: specialtyLabel.bottomAnchor, constant: 12),
            ratingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 24),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            appointmentLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 24),
            appointmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            appointmentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            timeSlotCollection.topAnchor.constraint(equalTo: appointmentLabel.bottomAnchor, constant: 16),
            timeSlotCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeSlotCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeSlotCollection.heightAnchor.constraint(equalToConstant: 50),
            timeSlotCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            bookAppointmentButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bookAppointmentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bookAppointmentButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bookAppointmentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(with doctor: Doctor) {
        nameLabel.text = doctor.name
        specialtyLabel.text = "\(doctor.category) • \(doctor.degree)"
        ratingLabel.text = String(format: "%.1f", doctor.rating)
        
        experienceView.valueLabel.text = doctor.experience
        locationView.valueLabel.text = doctor.location
        availabilityView.valueLabel.text = "Today"
    }
}
