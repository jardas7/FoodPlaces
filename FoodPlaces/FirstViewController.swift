//
//  FirstViewController.swift
//  FoodPlaces
//
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit
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

class FirstViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shadowSrc: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fieldPopis: UITextField!
    @IBOutlet weak var fieldCena: UITextField!
    @IBOutlet weak var labelJidlo: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var fieldNazev: UITextField!
    @IBOutlet weak var buttonUlozit: UIBarButtonItem!
    var jidlo: Jidlo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        
        if let jidlo = jidlo {
            navigationItem.title = jidlo.nazev
            fieldNazev.text   = jidlo.nazev
            fieldPopis.text   = jidlo.popis
            fieldCena.text   = jidlo.cena
            imageView.image = jidlo.foto
            ratingControl.rating = jidlo.rating
            //Dodelat lokaci
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
        print("imgPickerCancel")
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
         print("imgContrl")
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seletImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        print("Vybírá se obrázek")
        
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
    
    @IBAction func upravDetailObr(_ sender: UILongPressGestureRecognizer) {
        
        print("Edituje se obrázek")
        
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
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
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
        // dodelat restaurace
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        jidlo = Jidlo(nazev: nazevJidla, popis: popisJidla, cena: cenaJidla, foto: fotoJidla, rating: ratingJidla)
    }
    
 
    

}
