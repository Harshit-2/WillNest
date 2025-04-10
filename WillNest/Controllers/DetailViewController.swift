//
//  DetailViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "Hello from DetailViewController!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.frame = view.bounds
        view.addSubview(label)
    }
}
