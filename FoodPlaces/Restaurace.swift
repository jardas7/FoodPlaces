//
//  Restaurace.swift
//  FoodPlaces
//
//  Created by Jaromír Hnik on 10.06.17.
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import os.log

class Restaurace: NSObject, NSCoding{
    
    struct Lokace {
        let latitude: Double
        let longtitude: Double
    }
    
    var nazev: String
    var lokace: Lokace


    struct PropertyKey {
        static let nazev = "nazev"
        static let lokace = "lokace"
    }
    
    init?(nazev: String, lokace: Lokace) {
        
        self.nazev = nazev
        self.lokace = lokace
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nazev, forKey: PropertyKey.nazev)
        aCoder.encode(lokace, forKey: PropertyKey.lokace)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let nazev = aDecoder.decodeObject(forKey: PropertyKey.nazev) as? String else {
            os_log("Nelze přečíst název", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let lokace = aDecoder.decodeObject(forKey: PropertyKey.lokace) as? Lokace else {
            os_log("Nelze načíst lokaci", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(nazev: nazev, lokace: lokace)
        
    }

    
}
