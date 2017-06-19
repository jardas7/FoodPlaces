//
//  ShowMapDetail.swift
//  FoodPlaces
//
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import MapKit

class ShowMapDetail: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var lokaceCil: CLLocationCoordinate2D?
    var nazev: String = ""
    var adresa: String = ""
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    var selectedPin: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        centerMapOnLocation(location: lokaceCil!)
       // print(lokaceCil!)
    }
    
    func naviguj(){
        let mark = MKPlacemark(coordinate: lokaceCil!)
        let mapItem = MKMapItem(placemark: mark)
        mapItem.name = nazev
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
        
        print("Naviguj")
    }
    
    
    @IBAction func changeMapType(_ sender: AnyObject) {
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,                                                                  3500, 3500)
        mapView.setRegion(coordinateRegion, animated: true)
        annotation.coordinate = lokaceCil!
        annotation.title = nazev
        annotation.subtitle = adresa
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.blue
        pinView?.canShowCallout = true
        pinView?.animatesDrop = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "dir"), for: UIControlState())
        button.addTarget(self, action: #selector(ShowMapDetail.naviguj), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }

}
