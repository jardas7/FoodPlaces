//
//  Restaurace.swift
//  FoodPlaces
//
//  Created by Jaromír Hnik on 10.06.17.
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import MapKit
import os.log

class Restaurace: NSObject, NSCoding{

    
    var nazev: String
    //var lokace: CLLocationCoordinate2D
    var longitude: Double
    var latitude: Double
    var adresa: String

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ulozisteRestaurace")
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dataRestaurace")
    struct PropertyKey {
        static let nazev = "nazev"
       // static let lokace = "lokace"
        static let longitude = "longitude"
        static let latitude = "latitude"
        static let adresa = "adresa"
    }
    
    init?(nazev: String, longitude: Double, latitude: Double, adresa: String) {
        
        self.nazev = nazev
        //self.lokace = lokace
        self.longitude = longitude
        self.latitude = latitude
        self.adresa = adresa
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nazev, forKey: PropertyKey.nazev)
        //aCoder.encode(lokace, forKey: PropertyKey.lokace)
        aCoder.encode(longitude, forKey: PropertyKey.longitude)
        aCoder.encode(latitude, forKey: PropertyKey.latitude)
        aCoder.encode(adresa, forKey: PropertyKey.adresa)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let nazev = aDecoder.decodeObject(forKey: PropertyKey.nazev) as? String else {
            os_log("Nelze přečíst název", log: OSLog.default, type: .debug)
            return nil
        }
        
        let longitude = aDecoder.decodeDouble(forKey: PropertyKey.longitude) as Double?
        
        let latitude = aDecoder.decodeDouble(forKey: PropertyKey.latitude) as Double?
        
        guard let adresa = aDecoder.decodeObject(forKey: PropertyKey.adresa) as? String else {
            os_log("Nelze načíst adresu", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(nazev: nazev, longitude: longitude!, latitude: latitude!, adresa: adresa)
        
    }

    
}
