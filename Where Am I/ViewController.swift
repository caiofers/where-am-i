//
//  ViewController.swift
//  Where Am I
//
//  Created by Caio Fernandes on 24/03/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var latitudeValue: UILabel!
    @IBOutlet weak var longitudeValue: UILabel!
    @IBOutlet weak var adressValue: UILabel!
    @IBOutlet weak var speedView: UIStackView!
    @IBOutlet weak var speedValue: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            presentLocationAlertDenied()
        }
    }

    func presentLocationAlertDenied(){
        let alertDenied = UIAlertController(title: "Localization Permission", message: "We need that you allow localization service to app works fine", preferredStyle: .alert)
        
        let configurationAction = UIAlertAction(title: "Open configuration", style: .default, handler: {(UIAlertAction) -> Void in
            
            if let configuration = NSURL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(configuration as URL)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertDenied.addAction(configurationAction)
        alertDenied.addAction(cancelAction)
        
        present(alertDenied, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocalization = locations.last
        let longitude = userLocalization?.coordinate.longitude
        let latitude = userLocalization?.coordinate.latitude
        
        longitudeValue.text = String(longitude!)
        latitudeValue.text = String(latitude!)
        
        if userLocalization!.speed > 0 {
            speedView.isHidden = false
            speedValue.text = String(userLocalization!.speed)
        } else {
            speedView.isHidden = true
        }
        
        let deltaLatitude: CLLocationDegrees = 0.01
        let deltaLongitude: CLLocationDegrees = 0.01
        
        let location2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        
        let visualizationArea: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location2D, span: visualizationArea)
        
        mapView.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: nil) { (localDetails, error) in
            if error == nil {
                if let local = localDetails?.first {
                    // Rua
                    var thoroughfare = ""
                    if local.thoroughfare != nil {
                        thoroughfare = local.thoroughfare!
                    }
                    
                    // Número
                    var subThoroughfare = ""
                    if local.subThoroughfare != nil {
                        subThoroughfare = local.subThoroughfare!
                    }
                    
                    // Estado
                    var locality = ""
                    if local.locality != nil {
                        locality = local.locality!
                    }
                    
                    // Cidade
                    var subLocality = ""
                    if local.subLocality != nil {
                        subLocality = local.subLocality!
                    }
                    
                    // CEP
                    var postalCode = ""
                    if local.postalCode != nil {
                        postalCode = local.postalCode!
                    }
                    
                    // País
                    var country = ""
                    if local.country != nil {
                        country = local.country!
                    }
                    
                    // Sigla Estado
                    var administrativeArea = ""
                    if local.postalCode != nil {
                        administrativeArea = local.administrativeArea!
                    }
                    
                    var subAdministrativeArea = ""
                    if local.subAdministrativeArea != nil {
                        subAdministrativeArea = local.subAdministrativeArea!
                    }
                    
                    self.adressValue.text = (thoroughfare == "" ? "" : thoroughfare + ", ") +
                                            (subThoroughfare == "" ? "" : subThoroughfare + ", ") +
                                            (subLocality == "" ? "" : subLocality + "-") +
                                            (administrativeArea == "" ? "" : administrativeArea + ", ") +
                                            (country == "" ? "" : country) +
                                            (postalCode == "" ? "" : "\nZip Code: " + postalCode)
                }
            } else {
                // TODO: Error
                print ("ERROR")
            }
        }
        
    }

}

