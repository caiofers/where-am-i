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
        var userLocalization = locations.last
        let longitude = userLocalization?.coordinate.longitude
        let latitude = userLocalization?.coordinate.latitude
        
        longitudeValue.text = String(longitude!)
        latitudeValue.text = String(latitude!)
        speedValue.text = String(userLocalization!.speed)
        
    }

}

