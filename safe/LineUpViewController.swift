//
//  LineUpViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase
class LineUpViewController: UIViewController{
   
    @IBAction func cancelButtonClick(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey:"Code")
        self.performSegue(withIdentifier: "doneOrCancelSegue", sender: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let storeId = defaults.string(forKey: "storeId") ?? ""
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser{
            db.collection("store").document(storeId).collection("user").document(user.uid).setData([
                    "firstName": defaults.string(forKey: "firstName") ?? "",
                    "lastName": defaults.string(forKey: "lastName") ?? "",
                    "phoneNumber": defaults.string(forKey: "phoneNumber") ?? "",
                    "waitCode": defaults.string(forKey: "Code") ?? ""
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("success")
                    }
                }
            db.collection("users").document(user.uid).collection("LineUp").document(storeId).setData([
                    "startTime": defaults.string(forKey: "startTime") ?? "",
                    "endTime": defaults.string(forKey: "endTime") ?? "",
                "storeId": defaults.string(forKey: "storeId") ?? "",
                "storeName": defaults.string(forKey: "storeName") ?? "",
                "waitCode": defaults.string(forKey: "Code") ?? ""
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("success")
                    }
                }
            defaults.removeObject(forKey:"Code")
            self.performSegue(withIdentifier: "doneOrCancelSegue", sender: nil)
        }
    }
    @IBOutlet var CodeField: UILabel!
    var Code: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let Code = defaults.string(forKey: "Code") {
            print(Code) // Some String Value
            CodeField.text = Code
        }
    }
}
