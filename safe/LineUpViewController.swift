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
        print(defaults)
        let storeId = defaults.string(forKey: "storeId") ?? ""
        let queueId = defaults.string(forKey: "queueId") ?? ""
        let storeName = defaults.string(forKey: "storeName") ?? ""
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser{
            db.collection("store").document(storeId).collection("queue").document(queueId).collection("users").document(user.uid).delete() { err in
                    if let err = err {
                        print("Error delete document: \(err)")
                    } else {
                        print("success")
                        var count = 0;
                        //Check for update or remaining
                        db.collection("store").document(storeId).collection("queue").document(queueId).collection("users").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                count = querySnapshot!.documents.count;
                                if let seat = defaults.string(forKey: "seat"){
                                    print(seat)
                                    let seatInt:Int = (seat as NSString).integerValue
                                    print(seatInt)
                                    let seatLeft = seatInt - count;
                                    defaults.set(seatLeft, forKey: "seatLeft")
                                    print("seatLeft in LineUp")
                                    print(defaults.string(forKey: "seatLeft"))
                                    db.collection("store").document(storeId).collection("queue").document(queueId).updateData([
                                        "seatLeft": String(seatLeft),
                                        ]) { err in
                                            if let err = err {
                                                print("Error adding document: \(err)")
                                            } else {
                                                print("successful Update")
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            db.collection("users").document(user.uid).collection("LineUp").document(storeId).delete(){ err in
                    if let err = err {
                        print("Error delete document: \(err)")
                    } else {
                        print("success")
                    }
                }
        
            defaults.removeObject(forKey:"Code")
            let alert = UIAlertController(title: "Line Up Cancelled", message: "You have cancelled your line up at " + storeName + ".", preferredStyle: .alert)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "doneOrCancelSegue", sender: nil)
                }
        }
        
    }
        
    
    @IBAction func doneButtonClick(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let storeId = defaults.string(forKey: "storeId") ?? ""
        let queueId = defaults.string(forKey: "queueId") ?? ""
        let storeName = defaults.string(forKey: "storeName") ?? ""
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser{
            db.collection("store").document(storeId).collection("queue").document(queueId).collection("users").document(user.uid).setData([
                    "alertMe": defaults.string(forKey: "alertMe") ?? "",
                    "numberOfGuest": defaults.string(forKey: "numberOfGuest") ?? "",
                    "firstName": defaults.string(forKey: "firstName") ?? "",
                    "lastName": defaults.string(forKey: "lastName") ?? "",
                    "phoneNumber": defaults.string(forKey: "phoneNumber") ?? "",
                    "waitCode": defaults.string(forKey: "Code") ?? ""
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("success")
                        var count = 0;
                        //Check for update or remaining
                        db.collection("store").document(storeId).collection("queue").document(queueId).collection("users").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                count = querySnapshot!.documents.count;
                                if let seat = defaults.string(forKey: "seat"){
                                    print(seat)
                                    let seatInt:Int = (seat as NSString).integerValue
                                    print(seatInt)
                                    let seatLeft = seatInt - count;
                                    
                                    db.collection("store").document(storeId).collection("queue").document(queueId).updateData([
                                        "seatLeft": String(seatLeft),
                                        ]) { err in
                                            if let err = err {
                                                print("Error adding document: \(err)")
                                            } else {
                                                print("successful Update")
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            db.collection("users").document(user.uid).collection("LineUp").document(storeId).setData([
                    "alertMe": defaults.string(forKey: "alertMe") ?? "",
                    "numberOfGuest": defaults.string(forKey: "numberOfGuest") ?? "",
                    "startTime": defaults.string(forKey: "startTime") ?? "",
                    "endTime": defaults.string(forKey: "endTime") ?? "",
                    "storeId": defaults.string(forKey: "storeId") ?? "",
                    "queueId": defaults.string(forKey: "queueId") ?? "",
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
            let alert = UIAlertController(title: "Line Up Successful!", message: "You have lined up for " + storeName + "!", preferredStyle: .alert)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "doneOrCancelSegue", sender: nil)
                }
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
