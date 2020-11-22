//
//  SettingViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase
class SettingViewController: UIViewController{
    
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    
    
    @IBAction func doneButtonClick(_ sender: Any) {
        
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            db.collection("users").document(user.uid).updateData([
                "firstName": firstName.text ?? firstName.placeholder!,
                "lastName": lastName.text ?? lastName.placeholder!,
                "phoneNumber": phoneNumber.text ?? phoneNumber.placeholder!
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    let alert = UIAlertController(title: "Information Update", message: "Your information is update in our database", preferredStyle: .alert)
                    self.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    //self.performSegue(withIdentifier: "afterSetting", sender: nil)
                    
                }
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let firstname = defaults.string(forKey: "firstName") {
            firstName.placeholder = firstname
        }
        if let lastname = defaults.string(forKey: "lastName") {
            lastName.placeholder = lastname
        }
        if let phonenumber = defaults.string(forKey: "phoneNumber") {
            phoneNumber.placeholder = phonenumber
        }
    }

}
