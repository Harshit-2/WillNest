//
//  DoctorDetailViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/13/25.
//

import UIKit

class DoctorDetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .systemGray5
        imageView.tintColor = .systemGray
        imageView.image = UIImage(systemName: "person.circle.fill")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let specialtyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private let ratingView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let experienceView = InfoRowView(title: "Experience", icon: "clock.fill")
    private let locationView = InfoRowView(title: "Location", icon: "location.fill")
    private let availabilityView = InfoRowView(title: "Available", icon: "calendar")
    
    private let appointmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Available Appointments"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let timeSlotCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 44)
        layout.minimumLineSpacing = 10
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(TimeSlotCell.self, forCellWithReuseIdentifier: "TimeSlotCell")
        return collection
    }()
    
    private let bookAppointmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Book Appointment", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let doctor: Doctor
    private let timeSlots = ["9:00 AM", "10:30 AM", "1:00 PM", "2:30 PM", "4:00 PM"]
    private var selectedTimeSlot: Int? = nil
    
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(specialtyLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(appointmentLabel)
        contentView.addSubview(timeSlotCollection)
        view.addSubview(bookAppointmentButton)
        
        setupRatingView()
        
        infoStackView.addArrangedSubview(experienceView)
        infoStackView.addArrangedSubview(locationView)
        infoStackView.addArrangedSubview(availabilityView)
        
        timeSlotCollection.dataSource = self
        timeSlotCollection.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
            
            bookAppointmentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bookAppointmentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bookAppointmentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bookAppointmentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        bookAppointmentButton.addTarget(self, action: #selector(bookAppointmentTapped), for: .touchUpInside)
    }
    
    private func setupRatingView() {
        // Add star image
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
        starImageView.tintColor = .systemYellow
        starImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ratingView.addArrangedSubview(starImageView)
        
        ratingView.addArrangedSubview(ratingLabel)
    }
    
    private func configureUI() {
        nameLabel.text = doctor.name
        specialtyLabel.text = "\(doctor.category) • \(doctor.degree)"
        ratingLabel.text = String(format: "%.1f", doctor.rating)
        
        // Configure info rows
        experienceView.valueLabel.text = doctor.experience
        locationView.valueLabel.text = doctor.location
        availabilityView.valueLabel.text = "Today"
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

// Helper view for information rows
class InfoRowView: UIView {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .right
        return label
    }()
    
    init(title: String, icon: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: icon)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12)
        ])
        
        // Set a minimum height for the row
        heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
}

// Time slot cell for appointment selection
class TimeSlotCell: UICollectionViewCell {
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .systemBlue : .systemGray6
            timeLabel.textColor = isSelected ? .white : .darkText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with time: String) {
        timeLabel.text = time
    }
}

