//
//  AddQueueController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase

class AddQueueController: UIViewController{
    
    @IBOutlet var businessNameField: UILabel!
    @IBOutlet var peopleField: UITextField!

    @IBOutlet var startTimePicker: UIDatePicker!
    @IBOutlet var endTimePicker: UIDatePicker!
    var startTime = "N/A";
    var endTime = "N/A";

    @IBAction func StartTimePickerChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: startTimePicker.date)
        print(strDate)
        startTime = strDate
    }
    
    @IBAction func EndTimePickerChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: endTimePicker.date)
        print(strDate)
        endTime = strDate
    }
    
    @IBAction func confirmChangeButtonClick(_ sender: Any) {
        if(peopleField.text != ""
            && startTime != "N/A"
            && endTime != "N/A"){
            let people:Int = Int(peopleField.text!) ?? -1
            print(people)
            if(people < 0){
                let alert = UIAlertController(title: "Format error", message: "You need to enter Non-Negative Integer~", preferredStyle: .alert)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        alert.dismiss(animated: true, completion: nil)
                }
            }
            
            let defaults = UserDefaults.standard
            let storeId = defaults.string(forKey: "storeId") ?? ""
            let db = Firestore.firestore()
            if let user = Auth.auth().currentUser{
                print(user)
                db.collection("store").document(storeId).collection("queue").document().setData([
                "startTime": startTime,
                "endTime": endTime,
                "seat":  peopleField.text!,
                "seatLeft":  peopleField.text!,
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("success")
                        self.performSegue(withIdentifier: "confirmChangeSegue", sender: nil)
                    }
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Ops.. Miss something", message: "You are enter all the information~", preferredStyle: .alert)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    alert.dismiss(animated: true, completion: nil)
            }
        }
        

    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let storeName = defaults.string(forKey: "storeName") {
            businessNameField.text = storeName
        }
        if let storeId = defaults.string(forKey: "storeId") {
            print(storeId)
        }
    }
}
