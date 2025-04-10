//
//  ViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 3/29/25.
//

//import UIKit
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//
//}

// bleeding from eye
// https://www.google.com/search?sca_esv=c558df6cbc6e058c&sxsrf=AHTn8zr1fdH0vn5wXPTwXLsSI2WjNQPWQw:1743958911407&q=how+to+use+scroll+view+ios&udm=7&fbs=ABzOT_CWdhQLP1FcmU5B0fn3xuWp6IcynRBrzjy_vjxR0KoDMp_4ut2Z3jppK72fzdIpWsBpYmR8fwcVczrRGmP-Hf4k7-2usZvH6HJKe8nDZk4522xQ3I0tFzG1g_dvqymMsA8YUNfaO6lbkMfYHmWqNFD9vIKb5wvsoDKO41uJ1CqhUSpn9tXkwtNOUAX4iL3cOtOkucJ1l-DPxBEVVhxkayn3TIM4jQ&sa=X&ved=2ahUKEwjLg6ub8cOMAxVfZfUHHV7xHDwQtKgLegQIFxAB&biw=1710&bih=988&dpr=2#fpstate=ive&vld=cid:e201c153,vid:Zvfhhud3MAc,st:0



//import UIKit
//import CoreML
//import Vision
//import Alamofire
//import SwiftyJSON
//import SDWebImage
//
//class MediflowViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//    
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var predictionLabel: UILabel!
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var readMoreButton: UIButton!
//    
//    var diseaseModel: DiseaseModel!
//    let imagePicker = UIImagePickerController()
//    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
//    
//    var isExpanded = false
//    var fullDescriptionText = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        searchBar.delegate = self
//        imagePicker.delegate = self
//        diseaseModel = DiseaseModel()
//        self.navigationItem.hidesBackButton = true
//        
//        descriptionLabel.numberOfLines = 3
//        readMoreButton.isHidden = true
//        
//        imageView.layer.cornerRadius = 50.0
//        imageView.clipsToBounds = true
//    }
//    
//    //MARK: - Image Picker Delegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let userPickedImage = info[.editedImage] as? UIImage {
//            imageView.image = userPickedImage
//            guard let convertedCIImage = CIImage(image: userPickedImage) else {
//                fatalError("Couldn't convert UIImage to CIImage")
//            }
//            detect(image: convertedCIImage)
//        }
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//    
//    func detect(image: CIImage) {
//        guard let model = try? VNCoreMLModel(for: DiseaseSymptomPredictor().model) else {
//            fatalError("Loading CoreML Model Failed.")
//        }
//        
//        let request = VNCoreMLRequest(model: model) { request, error in
//            guard let results = request.results as? [VNClassificationObservation] else {
//                fatalError("Model failed to process image.")
//            }
//            
//            if let firstResult = results.first {
//                DispatchQueue.main.async {
//                    self.predictionLabel.text = "\(firstResult.identifier)"
//                    self.requestInfo(diseaseName: firstResult.identifier)
//                }
//            }
//        }
//        
//        let handler = VNImageRequestHandler(ciImage: image)
//        do {
//            try handler.perform([request])
//        } catch {
//            print(error)
//        }
//    }
//    
//    //MARK: - Camera Tapped
//    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
//        imagePicker.sourceType = .camera
//        imagePicker.allowsEditing = true
//        present(imagePicker, animated: true, completion: nil)
//    }
//    
//    //MARK: - Wikipedia Request
//    func requestInfo(diseaseName: String) {
//        let parameters: [String: String] = [
//            "format": "json",
//            "action": "query",
//            "prop": "extracts|pageimages",
//            "exintro": "",
//            "explaintext": "",
//            "titles": diseaseName,
//            "redirects": "1",
//            "pithumbsize": "500",
//            "indexpageids": ""
//        ]
//        
//        AF.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                print("✅ Response JSON: \(value)")
//                let diseaseJSON = JSON(value)
//                let pageid = diseaseJSON["query"]["pageids"][0].stringValue
//                let diseaseDescription = diseaseJSON["query"]["pages"][pageid]["extract"].stringValue
//                let diseaseImageURL = diseaseJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
//                
//                self.imageView.sd_setImage(with: URL(string: diseaseImageURL))
//                
//                DispatchQueue.main.async {
//                    self.fullDescriptionText = diseaseDescription
//                    self.descriptionLabel.text = diseaseDescription
//                    self.descriptionLabel.numberOfLines = 6
//                    self.isExpanded = false
//                    self.readMoreButton.setTitle("Read More", for: .normal)
//                    self.readMoreButton.isHidden = diseaseDescription.count < 300
//                }
//                
//            case .failure(let error):
//                print("❌ Request failed with error: \(error)")
//            }
//        }
//    }
//    
//    //MARK: - Read More Button
//    @IBAction func readMoreTapped(_ sender: UIButton) {
//        isExpanded.toggle()
//        UIView.animate(withDuration: 0.3) {
//            self.descriptionLabel.numberOfLines = self.isExpanded ? 0 : 6
//            self.readMoreButton.setTitle(self.isExpanded ? "Read Less" : "Read More", for: .normal)
//            self.view.layoutIfNeeded()
//        } completion: { _ in
//            if !self.isExpanded {
//                var superview = self.descriptionLabel.superview
//                while superview != nil && !(superview is UIScrollView) {
//                    superview = superview?.superview
//                }
//                
//                // If we found a scroll view, scroll to the top
//                if let scrollView = superview as? UIScrollView {
//                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//                }
//            }
//        }
//    }
//}
//
//
////MARK: - UISearchBarDelegate
//extension MediflowViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        
//        guard let userInput = searchBar.text?.lowercased() else { return }
//        let symptomsArray = userInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//        
//        if let predictedDisease = diseaseModel.predictDisease(from: symptomsArray) {
//            DispatchQueue.main.async {
//                self.predictionLabel.text = "\(predictedDisease.capitalized)"
//                self.requestInfo(diseaseName: predictedDisease)
//            }
//        } else {
//            DispatchQueue.main.async {
//                self.predictionLabel.text = "No prediction available."
//                self.descriptionLabel.text = ""
//                self.readMoreButton.isHidden = true
//            }
//        }
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.isEmpty == true {
//            DispatchQueue.main.async {
//                self.predictionLabel.text = "Disease"
//                self.imageView.image = nil
//                self.descriptionLabel.text = ""
//                self.readMoreButton.isHidden = true
//                self.fullDescriptionText = ""
//                
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
