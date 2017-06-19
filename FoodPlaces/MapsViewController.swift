//
//  MapsViewController.swift
//  FoodPlaces
//
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

    

import UIKit
import MapKit
import os.log

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class MapsViewController: UIViewController {
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    let locationManager = CLLocationManager()
    var myAnno: MKAnnotation? = nil
    var restaurace = [Restaurace]()
    
    @IBOutlet var lokBut: UIBarButtonItem!
    @IBOutlet var but: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func getMojeLokace(_ sender: UIBarButtonItem) {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 4000, 4000)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func naviguj(_ sender: UIBarButtonItem) {
        getDirections()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("URL-count", Restaurace.ArchiveURL.pathComponents.count)
        self.navigationItem.rightBarButtonItem = nil
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Zadejte název restaurace"
        searchBar.setValue("Zrušit", forKey:"_cancelButtonText")
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        if let ulozeneRestaurace = nactiRestaurace(){
            restaurace += ulozeneRestaurace
        }
        else {
            nactiUvodniRestaurace()
        }
    }
    
    func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    func addRestaurace(){
        let alert = UIAlertController(title: "Varování", message: "Tato restaurace už je uložena jako oblíbená, zvolte prosím jinou.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Rozumím", style: UIAlertActionStyle.destructive, handler: nil))
        
        let OKdialog = UIAlertController(title: "Potvrzení", message: "Restaurace byla úspěšně přidána mezi oblíbené", preferredStyle: UIAlertControllerStyle.actionSheet)
        OKdialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        let restaurace1 = Restaurace(nazev: ((myAnno?.title)!)!, longitude: (myAnno?.coordinate.longitude)!, latitude: (myAnno?.coordinate.latitude)!, adresa: ((myAnno?.subtitle)!)!)
        var pole = [String]()
        
        for item in restaurace {
            pole.append(item.nazev)
        }
        
        if pole.contains(((myAnno?.title)!)!) {
            self.present(alert, animated: true, completion: nil)
        } else {
            restaurace.append(restaurace1!)
            ulozRestauraci()
            self.present(OKdialog, animated: true, completion: nil)
        }
    }
    
    func getRestaurace() -> [Restaurace]{
        return restaurace
    }
    
    func nactiUvodniRestaurace(){
    
        let restaurace1 = Restaurace(nazev: "Čínská restaurace U Bílého koníčka",longitude: 15.7794185, latitude: 50.0383195, adresa: "Pardubice Pardubický")
        
        let restaurace2 = Restaurace(nazev: "Restaurace Šatlava",longitude: 15.834752121084945, latitude: 50.210826655876538,  adresa: "Hradec Králové Královéhradecký")
        
        let restaurace3 = Restaurace(nazev: "Steak Station", longitude: 15.804130733095, latitude: 50.043211472166703, adresa: "Pardubice Pardubický")
        restaurace += [restaurace1!, restaurace2!, restaurace3!]
    }
    
    private func ulozRestauraci(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(restaurace, toFile: Restaurace.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Rest successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save rest...", log: OSLog.default, type: .error)
        }
        
    }
    
    private func nactiRestaurace() -> [Restaurace]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Restaurace.ArchiveURL.path) as? [Restaurace]
    }
}

extension MapsViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
 
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension MapsViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        mapView.selectAnnotation(annotation, animated: true)
    }
    
}

extension MapsViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        myAnno = annotation
        pinView?.pinTintColor = UIColor.blue
        pinView?.canShowCallout = true
        pinView?.animatesDrop = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "plus"), for: UIControlState())
        button.addTarget(self, action: #selector(MapsViewController.addRestaurace), for: .touchUpInside)
        pinView?.rightCalloutAccessoryView = button
        
        self.navigationItem.rightBarButtonItem = self.but
        return pinView
        
    }
}

