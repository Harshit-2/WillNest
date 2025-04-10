//
//  LocationViewController.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    let locationManager = CLLocationManager()
    var currentUserLocation: CLLocationCoordinate2D?
    var searchDebounceWorkItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }

        currentUserLocation = userLocation.coordinate

        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                        latitudinalMeters: 10000,
                                        longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
        let initialDistance = Int(distanceSlider.value)
        distanceLabel.text = "\(initialDistance) km"
        searchForHospitals(near: userLocation.coordinate, radiusInKm: initialDistance)
    }
    
    func searchForHospitals(near coordinate: CLLocationCoordinate2D, radiusInKm: Int) {
        mapView.removeAnnotations(mapView.annotations)
        
        let meters = Double(radiusInKm) * 1000

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Hospital"
        request.region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: meters,
                                            longitudinalMeters: meters)

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else { return }

            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.subtitle = item.placemark.title
                annotation.coordinate = item.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let distance = Int(sender.value)
        distanceLabel.text = "\(distance) km"
        
        if let location = currentUserLocation {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: Double(distance) * 1000,
                                            longitudinalMeters: Double(distance) * 1000)
            mapView.setRegion(region, animated: true)
        }

        searchDebounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if let location = self.currentUserLocation {
                self.searchForHospitals(near: location, radiusInKm: distance)
            }
        }
        
        searchDebounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        let identifier = "HospitalPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .systemRed

            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = view.annotation?.coordinate else { return }

        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = view.annotation?.title ?? "Hospital"
        mapItem.openInMaps(launchOptions: nil)
    }
}
