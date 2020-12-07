//
//  EditQueueController.swift
//  safe
//
//  Created by Yifeng Guo on 12/5/20.
//

import Foundation
import UIKit
import Firebase

class EditQueueController: UIViewController{

    @IBOutlet var maxPeople: UITextField!
    @IBOutlet var startPicker: UIDatePicker!
    @IBOutlet var endPicker: UIDatePicker!
    @IBOutlet var businessName: UILabel!
    var startTime = "N/A";
    var endTime = "N/A";
    @IBAction func deleteClick(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        print(defaults)
        let storeId = defaults.string(forKey: "storeId") ?? ""
        let queueId = defaults.string(forKey: "queueId") ?? ""
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser{
                        var count = 0;
                        //Check for update or remaining
                        db.collection("store").document(storeId).collection("queue").document(queueId).collection("users").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                if let documents = querySnapshot?.documents{
                                for document in documents {
                                    let userId = document.documentID
                                    db.collection("users").document(userId).collection("LineUp").document(storeId).delete(){ err in
                                                if let err = err {
                                                    print("Error delete document: \(err)")
                                                } else {
                                                    print("successful Update")
                                                }
                                    }
                                }
                            }
                                
                            }
                        }
                print("queueId")
                print(queueId)
                print("storeId")
                print(storeId)
            db.collection("store").document(storeId).collection("queue").document(queueId).delete(){ err in
                        if let err = err {
                            print("Error delete document: \(err)")
                        } else {
                            print("successful delete queue")
                            self.performSegue(withIdentifier: "deleteSegue", sender: nil)
                        }
            }
            
            
                }
            defaults.removeObject(forKey:"Code")
            
            
        }
        
    
    @IBAction func confirmChangeClick(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startstrDate = dateFormatter.string(from: startPicker.date)
        let endstrDate = dateFormatter.string(from: endPicker.date)
        startTime = startstrDate;
        endTime = endstrDate;
        if(maxPeople.text != ""){
            let people:Int = Int(maxPeople.text!) ?? -1
            print(people)
            if(people < 0){
                let alert = UIAlertController(title: "Format error", message: "You must enter a non-negative integer.", preferredStyle: .alert)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        alert.dismiss(animated: true, completion: nil)
                }
            }
            
            let defaults = UserDefaults.standard
            let storeId = defaults.string(forKey: "storeId") ?? ""
            let queueId = defaults.string(forKey: "queueId") ?? ""
            let db = Firestore.firestore()
            if let user = Auth.auth().currentUser{
                print(user)
                db.collection("store").document(storeId).collection("queue").document(queueId).updateData([
                "startTime": startTime,
                "endTime": endTime,
                "seat":  maxPeople.text!,
                "seatLeft":  maxPeople.text!,
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("success")
                        self.performSegue(withIdentifier: "editconfirmChangeSegue", sender: nil)
                    }
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Oops..You are missing something!", message: "You must enter all the required information.", preferredStyle: .alert)
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
            businessName.text = storeName
        }
        if let storeId = defaults.string(forKey: "storeId") {
            //print(storeId)
        }
        if let people = defaults.string(forKey: "seat") {
            maxPeople.placeholder = people
        }
        if let starttime = defaults.string(forKey: "startTime") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
           
            startPicker.setDate(dateFormatter.date(from: starttime)!, animated: false)
        }
        if let endtime = defaults.string(forKey: "endTime") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            endPicker.setDate(dateFormatter.date(from: endtime)!, animated: false)
            //print(storeId)
        }
    }
    
}
