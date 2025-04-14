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
    @IBOutlet weak var ageTextArea: UITextView!
    @IBOutlet weak var maleSelected: UIButton!
    @IBOutlet weak var femaleSelected: UIButton!
    @IBOutlet weak var weightPicker: UIPickerView!
    @IBOutlet weak var allergyTextArea: UITextView!
    
    let db = Firestore.firestore()
    var userAge = 0
    var userGender = "Not Selected"
    var userWeight = 0
    var userCity: String = "Unknown"
    var weightArray: [Int] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        weightPicker.dataSource = self
        weightPicker.delegate = self
        ageTextArea.text = "0"
        allergyTextArea.layer.borderWidth = 1
        allergyTextArea.layer.borderColor = UIColor.gray.cgColor
        allergyTextArea.layer.cornerRadius = 5
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.cornerRadius = 5
        
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
        ageTextArea.text = String(Int(sender.value))
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

        let userID = user.uid

        guard let userName = nameTextField.text, !userName.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter your name.")
            return
        }

        guard userAge > 0 else {
            showAlert(title: "Invalid Age", message: "Please select your age.")
            return
        }

        guard userGender != "Not Selected" else {
            showAlert(title: "Gender Required", message: "Please select your gender.")
            return
        }

        guard userWeight > 0 else {
            showAlert(title: "Select Weight", message: "Please select your weight.")
            return
        }

        guard userCity != "Unknown" else {
            showAlert(title: "Location Missing", message: "Please fetch your location.")
            return
        }

        let allergies = allergyTextArea.text ?? ""

        let userRef = db.collection("userData").document(userID)

        let userData: [String: Any] = [
            "name": userName,
            "age": userAge,
            "gender": userGender,
            "weight": userWeight,
            "city": userCity,
            "allergies": allergies
        ]

        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                userRef.updateData(userData) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        self.showSuccessAlert(message: "Profile updated successfully!")
                    }
                }
            } else {
                userRef.setData(userData) { error in
                    if let error = error {
                        print("Error creating document: \(error.localizedDescription)")
                    } else {
                        self.showSuccessAlert(message: "Profile created successfully!")
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let brandBlue = UIColor(named: "BrandBlue") ?? UIColor.systemGreen

        let titleAttr = [NSAttributedString.Key.foregroundColor: brandBlue]
        alert.setValue(NSAttributedString(string: title, attributes: titleAttr), forKey: "attributedTitle")
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(brandBlue, forKey: "titleTextColor")
        alert.addAction(okAction)

        present(alert, animated: true)
    }

    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let brandBlue = UIColor(named: "BrandBlue") ?? UIColor.systemGreen

        let titleAttr = [NSAttributedString.Key.foregroundColor: brandBlue]
        alert.setValue(NSAttributedString(string: "Done 😊", attributes: titleAttr), forKey: "attributedTitle")

        let action = UIAlertAction(title: "Great", style: .default) { _ in
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        action.setValue(brandBlue, forKey: "titleTextColor")
        alert.addAction(action)

        present(alert, animated: true)
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
