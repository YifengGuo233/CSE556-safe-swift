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
    
    @IBOutlet var startTimeField: UITextField!
    
    @IBOutlet var endTimeField: UITextField!
    @IBAction func confirmChangeButtonClick(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let storeId = defaults.string(forKey: "storeId") ?? ""
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser{
            db.collection("store").document(storeId).collection("queue").document().setData([
                "startTime": startTimeField.text,
                "endTime": endTimeField.text,
                "seat":  peopleField.text,
                "seatLeft":  peopleField.text,
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
