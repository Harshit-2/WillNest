//
//  EditViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 3/30/25.
//

import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

class EditViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var maleSelected: UIButton!
    @IBOutlet weak var femaleSelected: UIButton!
    @IBOutlet weak var weightPicker: UIPickerView!
    
    let db = Firestore.firestore()
    var userAge = 1
    var userGender = "Select"
    var userWeight = 3
    var userCity: String = "Unknown"
    var weightArray: [Int] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        weightPicker.dataSource = self
        weightPicker.delegate = self
        ageTextField.text = "0"
        
        for i in 1...130 {
            weightArray.append(i)
        }
    }
    
    @IBAction func getGender(_ sender: UIButton) {
        maleSelected.isSelected = false
        femaleSelected.isSelected = false
        sender.isSelected = true
        
        userGender = sender.currentTitle!
        print(userGender)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        ageTextField.text = String(Int(sender.value))
        userAge = Int(sender.value)
        print(userAge)
    }
    
    @IBAction func getLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }
        
        let userID = user.uid  // Use Firebase Auth UID as document ID
        
        guard let userName = nameTextField.text, !userName.isEmpty else {
            print("Name cannot be empty")
            return
        }
        
        let userRef = db.collection("userData").document(userID)  // Use UID-based document reference
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // If document exists, update it
                userRef.updateData([
                    "name": userName,
                    "age": self.userAge,
                    "gender": self.userGender,
                    "weight": self.userWeight,
                    "city": self.userCity
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Done 😊", message: "Profile updated successfully!", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Great", style: .default) { _ in
                                // Navigate back to ProfileViewController
                                if let navigationController = self.navigationController {
                                    navigationController.popViewController(animated: true)
                                } else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }                    }
                }
            } else {
                // If document does not exist, create a new one
                userRef.setData([
                    "name": userName,
                    "age": self.userAge,
                    "gender": self.userGender,
                    "weight": self.userWeight,
                    "city": self.userCity
                ]) { error in
                    if let error = error {
                        print("Error creating document: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Done 😊", message: "Profile created successfully!", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Great", style: .default) { _ in
                                // Navigate back to ProfileViewController
                                if let navigationController = self.navigationController {
                                    navigationController.popViewController(animated: true)
                                } else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
}

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(weightArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userWeight = weightArray[row]
        print(userWeight)
    }
}

extension EditViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Geocoding failed: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        self.userCity = city
                        print("City: \(city)")
                    } else {
                        print("City name not available")
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}
