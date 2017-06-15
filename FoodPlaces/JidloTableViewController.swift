//
//  JidloTableViewController.swift
//  FoodPlaces
//
//  Created by Jaromír Hnik on 10.06.17.
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import os.log

class JidloTableViewController: UITableViewController {
    
    var jidla = [Jidlo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.title = "Upravit"
       
        print("Nacitam")
        
        if let ulozenaJidla = nactiJidla() {
            jidla += ulozenaJidla
        }
        else {
            // Load the sample data.
            nactiUvodni()
        }
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

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jidla.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "JidloTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JidloTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let jidlo = jidla[indexPath.row]
        
        cell.labelNazev.text = jidlo.nazev
        cell.imageViewFood.image = jidlo.foto
        cell.labelCena.text = jidlo.cena
        cell.ratingControl.rating = jidlo.rating
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            jidla.remove(at: indexPath.row)
            ulozJidla()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //Funkce storyboard
    @IBAction func ulozJidloDoListu(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? FirstViewController, let jidlo = sourceViewController.jidlo {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                jidla[selectedIndexPath.row] = jidlo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else
            {
            // Add a new meal.
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    //NACITANI
    
    private func nactiUvodni(){
        let foto1 = UIImage(named: "polevka")
        let foto2 = UIImage(named: "tatarak")
        let foto3 = UIImage(named: "gulas")
        
        guard let jidlo1 = Jidlo(nazev: "Italská polévka", popis: "Moc dobrá Minestrone, paráda!", cena: "59", foto: foto1, rating: 3)
            else { fatalError("aaa") }
        
        guard let jidlo2 = Jidlo(nazev: "Tatarský biftek", popis: "Zajímavá kombinace, s hranolkami jsem to ještě nezkoušel.", cena: "199", foto: foto2, rating: 4)
            else { fatalError("bbb") }
        
        guard let jidlo3 = Jidlo(nazev: "Dančí guláš", popis: "Miluju zvěřinu!! 🐗", cena: "89", foto: foto3, rating: 3)
            else { fatalError("ccc") }
        
        jidla += [jidlo1, jidlo2, jidlo3]
        
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
