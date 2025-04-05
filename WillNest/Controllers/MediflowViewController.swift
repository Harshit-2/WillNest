//
//  MediflowViewController.swift
//  WillNest
//
//  Created by Harshit on 3/31/25.
//

import UIKit
import CoreML
import Vision

class MediflowViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var diseaseModel: DiseaseModel!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        imagePicker.delegate = self
        diseaseModel = DiseaseModel()
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK: - Send Image to ML model
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.editedImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let convertedCIImage = CIImage(image: userPickedImage) else { // Convert UI image to CI image
                fatalError("Couldn't convert UIImage to CIImage")
            }
            
            detect(image: convertedCIImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: DiseaseSymptomPredictor().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
            if let firstResult = results.first {
                DispatchQueue.main.async {
                    self.predictionLabel.text = "Predicted Disease: \(firstResult.identifier)"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image) // Which image to process is taken care by handler
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    //MARK: - Camera Tapped
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - Search Bar Delegate Methods
extension MediflowViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let userInput = searchBar.text?.lowercased() else { return }
        
        let symptomsArray = userInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        if let predictedDisease = diseaseModel.predictDisease(from: symptomsArray) {
            DispatchQueue.main.async {
                self.predictionLabel.text = "Predicted Disease: \(predictedDisease)"
            }
        } else {
            DispatchQueue.main.async {
                self.predictionLabel.text = "No prediction available."
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
