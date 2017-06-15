//
//  MapsViewController.swift
//  FoodPlaces
//
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var viewMapy: MKMapView!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func setPozice(_ sender: UIBarButtonItem) {
        
        let userLocation = viewMapy.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 3500, 3500)
        
        viewMapy.setRegion(region, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewMapy.showsUserLocation = true
        viewMapy.delegate = self
        
        

        // Do any additional setup after loading the view.
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate
        userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
