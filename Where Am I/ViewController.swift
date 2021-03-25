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
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speedView.layer.cornerRadius = speedView.frame.height/2
    }


}

