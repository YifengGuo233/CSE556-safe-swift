//
//  SettingBusinessViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/28/20.
//

import Foundation
import UIKit
import Firebase
class SettingBusinesViewController: UIViewController{
    @IBOutlet var businessName: UITextField!
    @IBOutlet var addressOne: UITextField!
    @IBOutlet var addressTwo: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var zip: UITextField!
    @IBOutlet var phone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let businessname = defaults.string(forKey: "storeName"),
           let addressone = defaults.string(forKey: "addressOne"),
           let addresstwo = defaults.string(forKey: "addressTwo"),
           let city_ = defaults.string(forKey: "city"),
           let state_ = defaults.string(forKey: "state"),
           let zip_ = defaults.string(forKey: "zip"),
           let phone_ = defaults.string(forKey: "phoneNumber"){
            businessName.placeholder = businessname
            addressOne.placeholder = addressone
            addressTwo.placeholder = addresstwo
            city.placeholder = city_
            state.placeholder = state_
            zip.placeholder = zip_
            phone.placeholder = phone_
        }
    }
    
    
    @IBAction func finishButtonClick(_ sender: Any) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            let defaults = UserDefaults.standard
            var businessname = ""
            var addressone = ""
            var addresstwo = ""
            var city_ = ""
            var state_ = ""
            var zip_ = ""
            var phoneNumber_ = ""
            if(businessName.text != "" && businessName.text != nil){
                businessname = businessName.text!
            }
            else{
                businessname = defaults.string(forKey: "storeName") ?? "";
            }
            if(addressOne.text != "" && addressOne.text != nil){
                addressone = addressOne.text!
            }
            else{
                addressone = defaults.string(forKey: "addressOne") ?? "";
            }
            if(addressTwo.text != "" && addressTwo.text != nil){
                addresstwo = addressTwo.text!
            }
            else{
                addresstwo = defaults.string(forKey: "addressTwo") ?? "";
            }
            if(city.text != "" && city.text != nil){
                city_ = city.text!
            }
            else{
                city_ = defaults.string(forKey: "city") ?? "";
            }
            if(state.text != "" && state.text != nil){
                state_ = state.text!
            }
            else{
                state_ = defaults.string(forKey: "state") ?? "";
            }
            if(zip.text != "" && zip.text != nil){
                zip_ = zip.text!
            }
            else{
                zip_ = defaults.string(forKey: "zip") ?? "";
            }
            if(phone.text != "" && phone.text != nil){
                phoneNumber_ = phone.text!
            }
            else{
                phoneNumber_ = defaults.string(forKey: "phoneNumber") ?? "";
            }
            db.collection("store").document(user.uid).updateData([
                "storeName": businessname,
                "addressOne": addressone,
                "addressTwo": addresstwo,
                "city": city_,
                "state": state_,
                "zip": zip_,
                "phoneNumber": phoneNumber_,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    let alert = UIAlertController(title: "Information Updated", message: "Your information was updated in our database.", preferredStyle: .alert)
                    self.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            alert.dismiss(animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "afterBusinessSettingSegue", sender: nil)
                        }
                    
                    
                }
            }
        }
    }
    
}

    
