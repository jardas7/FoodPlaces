//
//  RestauraceTableViewController.swift
//  FoodPlaces
//
//  Created by Jaromír Hnik on 19.06.17.
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import os.log

class RestauraceTableViewController: UITableViewController {

    var restaurace = [Restaurace]()
    
    @IBOutlet var mujView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.title = "Upravit"
        if nactiRestaurace()?.count == nil {
            let restaurace1 = Restaurace(nazev: "Čínská restaurace U Bílého koníčka",longitude: 15.7794185, latitude: 50.0383195, adresa: "Pardubice Pardubický")
            
            let restaurace2 = Restaurace(nazev: "Restaurace Šatlava",longitude: 15.834752121084945, latitude: 50.210826655876538,  adresa: "Hradec Králové Královéhradecký")
            
            let restaurace3 = Restaurace(nazev: "Steak Station", longitude: 15.804130733095, latitude: 50.043211472166703, adresa: "Pardubice Pardubický")
            restaurace += [restaurace1!, restaurace2!, restaurace3!]

        }else{
            restaurace = nactiRestaurace()!
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if nactiRestaurace()?.count != nil {
            restaurace = nactiRestaurace()!
        }
        mujView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        super.setEditing(editing,animated:animated)
        if(self.isEditing)
        {
            self.editButtonItem.title = "Hotovo"
        }else
        {
            self.editButtonItem.title = "Upravit"
        }
    }
    
    private func ulozRestaurace() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(restaurace, toFile: Restaurace.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Jídla úspěšně uložena", log: OSLog.default, type: .debug)
        } else {
            os_log("Došlo k chybě při ukládaní...", log: OSLog.default, type: .error)
        }
    }
    
    private func nactiRestaurace() -> [Restaurace]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Restaurace.ArchiveURL.path) as? [Restaurace]
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurace.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RestauraceTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RestauraceTableViewCell  else {
            fatalError("")
        }
        
        let restaurace = self.restaurace[indexPath.row]
        cell.labelNazev.text = restaurace.nazev
        cell.labelLokace.text = restaurace.adresa
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            restaurace.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ulozRestaurace()
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
