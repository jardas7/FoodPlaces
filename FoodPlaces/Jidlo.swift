//
//  Food.swift
//  FoodPlaces
//
//  Created by Jaromír Hnik on 10.06.17.
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import os.log

class Jidlo: NSObject, NSCoding{
    
    var nazev: String
    var popis: String
    var cena: String
    var foto: UIImage?
    var restaurace: Restaurace
    var rating: Int
    
    //cesta k file
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ulozisteJidla")
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dataJidlo")
    struct PropertyKey {
        static let nazev = "nazev"
        static let popis = "popis"
        static let cena = "cena"
        static let foto = "foto"
        static let rating = "rating"
        static let restaurace = "restaurace"
    }
    
    init?(nazev: String, popis: String, cena: String, foto: UIImage?, rating: Int, restaurace: Restaurace) {
        
        guard !nazev.isEmpty else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        if (nazev.isEmpty) {
            print("Nelze uložit prázdné jídlo")
            return nil
        }
        
        self.nazev = nazev
        self.popis = popis
        self.cena = cena
        self.foto = foto
        self.rating = rating
        self.restaurace = restaurace
        
       
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nazev, forKey: PropertyKey.nazev)
        aCoder.encode(popis, forKey: PropertyKey.popis)
        aCoder.encode(cena, forKey: PropertyKey.cena)
        aCoder.encode(foto, forKey: PropertyKey.foto)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(restaurace, forKey: PropertyKey.restaurace)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let nazev = aDecoder.decodeObject(forKey: PropertyKey.nazev) as? String else {
            os_log("Nelze přečíst jméno", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let cena = aDecoder.decodeObject(forKey: PropertyKey.cena) as? String else {
            os_log("Nelze načíst cenu", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let popis = aDecoder.decodeObject(forKey: PropertyKey.popis) as? String
        else {
            os_log("Nelze načíst cenu", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let foto = aDecoder.decodeObject(forKey: PropertyKey.foto) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)

        guard let restaurace = aDecoder.decodeObject(forKey: PropertyKey.restaurace) as? Restaurace
            else {
                os_log("Nelze načíst restauraci", log: OSLog.default, type: .debug)
                return nil
        }
        
        self.init(nazev: nazev, popis: popis, cena: cena, foto: foto, rating: rating, restaurace: restaurace)
        
    }
}
