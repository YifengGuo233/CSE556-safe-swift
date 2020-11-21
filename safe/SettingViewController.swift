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
                "firstName": firstName.text ?? firstName.placeholder,
                "lastName": lastName.text ?? lastName.placeholder,
                "phoneNumber": phoneNumber.text ?? phoneNumber.placeholder
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
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    if((document.data()?["firstName"]) != nil){
                        firstName.placeholder = document.data()?["firstName"] as! String
                    }
                    else{
                        firstName.placeholder = "Please type your FirstName"
                    }
                    if((document.data()?["lastName"]) != nil){
                        lastName.placeholder = document.data()?["lastName"] as! String
                    }
                    else{
                        lastName.placeholder = "Please type your LastName"
                    }
                    if((document.data()?["phoneNumber"]) != nil){
                        phoneNumber.placeholder = document.data()?["phoneNumber"] as! String
                    }
                    else{
                        phoneNumber.placeholder = "Please type your Phone Number"
                    }
                } else {
                    print("Document does not exist")
                }
            }

        }
    }


//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "afterSetting"{
//            let vc = segue.destination as! ProfileViewController
//        }
//    }

}
