//
//  ProfileViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 3/29/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var dsplayUserId: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayEmail: UILabel!
    @IBOutlet weak var displayAge: UILabel!
    @IBOutlet weak var displayGender: UILabel!
    @IBOutlet weak var displayWeight: UILabel!
    @IBOutlet weak var displayAllergy: UILabel!
    @IBOutlet weak var displayLocation: UILabel!
    
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid
    var username = "Unknown"
    var userAge = 0
    var userGender = "Unknown"
    var userWeight = 0
    var userLocation = "Not available"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure profile image
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor(named: "BrandBlue")?.cgColor
        
        navigationItem.hidesBackButton = true
        
        loadData()
    }
    
    //MARK: - Load Data Functionality
    func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            return
        }
        
        db.collection("userData").document(userId).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("No user data found for this UID")
                return
            }
            
            let data = document.data()
            
            if let name = data?["name"] as? String,
               let age = data?["age"] as? Int,
               let gender = data?["gender"] as? String,
               let weight = data?["weight"] as? Int,
               let location = data?["city"] as? String {

                self.displayName.text = name
                self.displayAge.text = "\(age)"
                self.displayGender.text = gender
                self.displayWeight.text = "\(weight) Kg"
                self.displayLocation.text = location
                self.dsplayUserId.text = userId
                self.displayEmail.text = Auth.auth().currentUser?.email
            }
            
            if let allergies = data?["allergies"] as? String, !allergies.isEmpty {
                self.displayAllergy.text = allergies
            } else {
                self.displayAllergy.text = "No known allergies"
            }
        }
    }

    
    //MARK: - SignOut Functionality
    @IBAction func signoutPressed(_ sender: UIBarButtonItem) {
        do {
                try Auth.auth().signOut()
                
                // Load WelcomeViewController from storyboard
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
                    
                    // Embed it in a NavigationController (if it was originally)
                    let navController = UINavigationController(rootViewController: welcomeVC)
                    navController.navigationBar.isHidden = true
                    
                    // Set rootViewController
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        sceneDelegate.window?.rootViewController = navController
                        sceneDelegate.window?.makeKeyAndVisible()
                    }
                }
                
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
    }
    
}

