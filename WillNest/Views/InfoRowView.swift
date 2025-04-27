//
//  InfoRowView.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/27/25.
//

import UIKit

class InfoRowView: UIView {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    let valueLabel = UILabel()
    
    init(title: String, icon: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = "-"
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, valueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

