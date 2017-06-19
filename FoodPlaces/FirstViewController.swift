//
//  FirstViewController.swift
//  FoodPlaces
//
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
import MapKit
import os.log

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(FirstViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class FirstViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet var restauraceNazev: UITextField!
    @IBOutlet weak var shadowSrc: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fieldPopis: UITextField!
    @IBOutlet weak var fieldCena: UITextField!
    @IBOutlet weak var labelJidlo: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var fieldNazev: UITextField!
    @IBOutlet weak var buttonUlozit: UIBarButtonItem!
    var jidlo: Jidlo?
    var restaurace = [Restaurace]()
    var pickerDataSource = [String]();
    @IBOutlet weak var pickerView: UIPickerView!
    var selectedRow: Int = 0
    var selectedRow2: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nejprve se musí uložit restaurace aby to chodilo, jinak to je nil a já teda načtu 3 které jsou default
        if nactiRestauraceZFile()?.count == nil{
            let restaurace1 = Restaurace(nazev: "Čínská restaurace U Bílého koníčka",longitude: 15.7794185, latitude: 50.0383195, adresa: "Pardubice Pardubický")
            
            let restaurace2 = Restaurace(nazev: "Restaurace Šatlava",longitude: 15.834752121084945, latitude: 50.210826655876538,  adresa: "Hradec Králové Královéhradecký")
            
            let restaurace3 = Restaurace(nazev: "Steak Station", longitude: 15.804130733095, latitude: 50.043211472166703, adresa: "Pardubice Pardubický")
            restaurace += [restaurace1!, restaurace2!, restaurace3!]
        }else{
            restaurace = nactiRestauraceZFile()!
        }
        
        
        for item in restaurace{
            pickerDataSource.append(item.nazev)
        }
        
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        shadowSrc.layer.shadowColor = UIColor.gray.cgColor
        shadowSrc.layer.shadowOpacity = 1
        shadowSrc.layer.shadowOffset = CGSize.zero
        shadowSrc.layer.shadowRadius = 4
        shadowSrc.layer.cornerRadius = 8
        shadowSrc.layer.shouldRasterize = true
        
        self.hideKeyboard()
        
        fieldNazev.delegate = self
        fieldCena.delegate = self
        fieldPopis.delegate = self
        fieldCena.keyboardType = UIKeyboardType.decimalPad
 
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        if let jidlo = jidlo {
            navigationItem.title = jidlo.nazev
            fieldNazev.text   = jidlo.nazev
            fieldPopis.text   = jidlo.popis
            fieldCena.text   = jidlo.cena
            imageView.image = jidlo.foto
            ratingControl.rating = jidlo.rating
        }
        
        var posuvnik: Int = 0
        if jidlo?.restaurace != nil {
            for item in restaurace {
                if item.nazev == jidlo?.restaurace.nazev {
                    print("Nastavuju pos", posuvnik)
                    selectedRow2 = posuvnik
                }
                    posuvnik += 1
                print("Posuvnik", posuvnik)
            }
            pickerView.selectRow(selectedRow2, inComponent: 0, animated: true)
        }
        updateUlozit()
    }
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            
            let isPresentingInAddMealMode = presentingViewController is UINavigationController
            
            if isPresentingInAddMealMode {
                dismiss(animated: true, completion: nil)
            }
            else if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
                print("Vracím se zpět")
            }
            else {
                fatalError("The MealViewController is not inside a navigation controller.")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        //buttonUlozit.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateUlozit()
        navigationItem.title = fieldNazev.text
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seletImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Klávesnice zajede
        fieldNazev.delegate = self
        fieldPopis.resignFirstResponder()
        fieldCena.resignFirstResponder()
        
        // Udělám dialog na vybrání zdroje
        let dialogZdroj = UIAlertController(title: "Výběr zdroje fotografie", message: "Vyberte si z jakého zdroje chcete fotografii Vámi oblíbeného jídla pořídit", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let zvolFotoaparat = UIAlertAction(title: "Fotoaparát", style: UIAlertActionStyle.default, handler: handlerFotoaparat)
        
        let zvolKnihovna = UIAlertAction(title: "Fotogalerie", style: UIAlertActionStyle.default, handler: handlerFotogalerie)
        
        let zvolZrusit = UIAlertAction(title: "Zrušit", style: UIAlertActionStyle.cancel, handler: nil)
        
        // Nacpání do dialogu
        dialogZdroj.addAction(zvolFotoaparat)
        dialogZdroj.addAction(zvolKnihovna)
        dialogZdroj.addAction(zvolZrusit)
        present(dialogZdroj, animated: true, completion: nil)
    }
    

    func handlerFotoaparat(alert: UIAlertAction){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func handlerFotogalerie(alert: UIAlertAction){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonZrusit(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("Nejsem tam kde mám být")
        }
    }
    
    private func updateUlozit() {
        // Potřebuju vyplnit nazev a cenu abych to mohl ulozit
        let text = fieldNazev.text ?? ""
        let cena = fieldCena.text ?? ""
        buttonUlozit.isEnabled = !text.isEmpty && !cena.isEmpty
    }
    
    
    // Navigace
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button == buttonUlozit else {
            os_log("Nebylo uloženo, ruším", log: OSLog.default, type: .debug)
            return
        }
        
        
        
        let nazevJidla = fieldNazev.text ?? ""
        let popisJidla = fieldPopis.text ?? ""
        let cenaJidla = fieldCena.text ?? ""
        let fotoJidla = imageView.image
        let ratingJidla = ratingControl.rating
       
        
        if jidlo?.restaurace != nil {
            if selectedRow2 != selectedRow {
                selectedRow2 = selectedRow
            }
            
            let restauraceEnd = self.restaurace[selectedRow2]
            print("jsem tu 1 - edit")
            jidlo = Jidlo(nazev: nazevJidla, popis: popisJidla, cena: cenaJidla, foto: fotoJidla, rating: ratingJidla, restaurace: restauraceEnd)
            
        } else {
             let restaurace = self.restaurace[selectedRow]
            print("jsem tu 1 - add")
         self.jidlo = Jidlo(nazev: nazevJidla, popis: popisJidla, cena: cenaJidla, foto: fotoJidla, rating: ratingJidla, restaurace: restaurace)
        }
    }
    
    private func nactiRestauraceZFile() -> [Restaurace]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Restaurace.ArchiveURL.path) as? [Restaurace]
    }
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
        
    }
    
    func vraceniRestaurace(row: Int) -> Restaurace {
        return restaurace[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        print(selectedRow)
    }
}
