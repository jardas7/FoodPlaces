//
//  JidloTableViewController.swift
//  FoodPlaces
//
//  Created by Jaromír Hnik on 10.06.17.
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import MapKit
import os.log

class JidloTableViewController: UITableViewController {
    
    var jidla = [Jidlo]()
    var restaurace = [Restaurace]()
    var point = Int()
    @IBOutlet weak var showButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.title = "Upravit"
        
        if let ulozenaJidla = nactiJidla() {
            jidla += ulozenaJidla
        }
        else {
            nactiUvodni()
        }
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        let pointInTable: CGPoint =         sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        point = cellIndexPath!.row
        let myVC = storyboard?.instantiateViewController(withIdentifier: "showMapDetail") as! ShowMapDetail
        myVC.lokaceCil = CLLocationCoordinate2D(latitude: CLLocationDegrees(jidla[point].restaurace.latitude), longitude: CLLocationDegrees(jidla[point].restaurace.longitude))
        myVC.nazev  = jidla[point].restaurace.nazev
        myVC.adresa = jidla[point].restaurace.adresa
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jidla.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "JidloTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JidloTableViewCell  else {
            fatalError("")
        }
        
        let jidlo = jidla[indexPath.row]
        cell.labelNazev.text = jidlo.nazev
        cell.imageViewFood.image = jidlo.foto
        cell.labelCena.text = jidlo.cena
        cell.ratingControl.rating = jidlo.rating
        cell.restauraceNazev.text = jidlo.restaurace.nazev
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            jidla.remove(at: indexPath.row)
            ulozJidla()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Funkce storyboard
    @IBAction func ulozJidloDoListu(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? FirstViewController, let jidlo = sourceViewController.jidlo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                jidla[selectedIndexPath.row] = jidlo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
            let newIndexPath = IndexPath(row: jidla.count, section: 0)
            jidla.append(jidlo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        ulozJidla()
        }
    }

    
    @IBAction func zrusProces(sender: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
            }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        
        case "PridaniJidlo":
            os_log("Přídávám nové jídlo.", log: OSLog.default, type: .debug)
            
            
        case "ZobrazeniDetail":
            guard let jidloDetailController = segue.destination as? FirstViewController else {
                fatalError("Neočekávaná lokace: \(segue.destination)")
            }
            
            guard let zvoleneJidloTab = sender as? JidloTableViewCell else {
                fatalError("Neočekávaný poskytovatel: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: zvoleneJidloTab) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let zvoleneJidlo = jidla[indexPath.row]
            jidloDetailController.jidlo = zvoleneJidlo
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //NACITANI
    
    private func nactiUvodni(){
        let foto1 = UIImage(named: "polevka")
        let foto2 = UIImage(named: "tatarak")
        let foto3 = UIImage(named: "gulas")
        
        let restaurace1 = Restaurace(nazev: "Čínská restaurace U Bílého koníčka",longitude: 15.7794185, latitude: 50.0383195, adresa: "Pardubice Pardubický")
        
        let restaurace2 = Restaurace(nazev: "Restaurace Šatlava",longitude: 15.834752121084945, latitude: 50.210826655876538,  adresa: "Hradec Králové Královéhradecký")
        
        let restaurace3 = Restaurace(nazev: "Steak Station", longitude: 15.804130733095, latitude: 50.043211472166703, adresa: "Pardubice Pardubický")
        
        guard let jidlo1 = Jidlo(nazev: "Čínská polévka", popis: "Moc dobrá Minestrone, paráda!", cena: "59", foto: foto1, rating: 3, restaurace: restaurace1!)
            else { fatalError("aaa") }
        
        guard let jidlo2 = Jidlo(nazev: "Tatarský biftek", popis: "Zajímavá kombinace, s hranolkami jsem to ještě nezkoušel.", cena: "199", foto: foto2, rating: 4, restaurace: restaurace2!)
            else { fatalError("bbb") }
        
        guard let jidlo3 = Jidlo(nazev: "Dančí guláš", popis: "Miluju zvěřinu!! 🐗", cena: "89", foto: foto3, rating: 3, restaurace: restaurace3!)
            else { fatalError("ccc") }
        
        jidla += [jidlo1, jidlo2, jidlo3]
        restaurace += [restaurace1!, restaurace2!, restaurace3!]
    }

    
    private func ulozJidla() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(jidla, toFile: Jidlo.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Jídla úspěšně uložena", log: OSLog.default, type: .debug)
        } else {
            os_log("Došlo k chybě při ukládaní...", log: OSLog.default, type: .error)
        }
    }
    
    private func nactiJidla() -> [Jidlo]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Jidlo.ArchiveURL.path) as? [Jidlo]
    }
    
    

}
