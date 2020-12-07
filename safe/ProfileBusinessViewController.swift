//
//  ProfileBusinessViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/28/20.
//

import Foundation
import UIKit
import Firebase
class ProfileBusinesViewController: UIViewController{

    
    @IBAction func logoutClick(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("logout")
        let alert = UIAlertController(title: "Logging out...", message: "You have logged out successfully!", preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "logoutBusinessSegue", sender: nil)
        }
    }
    
    @IBOutlet var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let firstname = defaults.string(forKey: "firstName"){
            if let lastName = defaults.string(forKey: "lastName"){
                username.text = "Hi, " + firstname + " " + lastName + "!"
            }
        }
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
            let db = Firestore.firestore()
            let docRef = db.collection("store").document(uid)
            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    print("b data")
                    print(data)
                    if let firstname = data?["firstName"] as? String{
                        if let lastname = data?["lastName"] as? String{
                            username.text = "Hi, " + firstname + " " + lastname + "!"
                            defaults.set(firstname, forKey: "firstName")
                            defaults.set(lastname, forKey: "lastName")
                        }
                    }
                    if let phoneNumber = data?["phoneNumber"]{
                        defaults.set(phoneNumber, forKey: "phoneNumber")
                    }
                    if let addressOne = data?["addressOne"]{
                        defaults.set(addressOne, forKey: "addressOne")
                    }
                    if let addressTwo = data?["addressTwo"]{
                        defaults.set(addressTwo, forKey: "addressTwo")
                    }
                    if let city = data?["city"]{
                        defaults.set(city, forKey: "city")
                    }
                    if let state = data?["state"]{
                        defaults.set(state, forKey: "state")
                    }
                    if let zip = data?["zip"]{
                        defaults.set(zip, forKey: "zip")
                    }
                    if let storeName = data?["storeName"]{
                        defaults.set(storeName, forKey: "storeName")
                    }
                } else {
                    print("Document does not exist")
                }
            }

        }
    }
}
