//
//  ProfileViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase
class ProfileViewController: UIViewController{
    @IBOutlet var username: UILabel!
    @IBOutlet var userProfileImage: UIImageView!

    @IBAction func myLineUpButtonClick(_ sender: Any) {
    }
    
    @IBAction func settingButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func SignOutButtonClick(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("logout")
        let alert = UIAlertController(title: "Logging out..", message: "You have logged out successfully!", preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let firstname = defaults.string(forKey: "firstName"){
            if let lastname = defaults.string(forKey: "lastName"){
                username.text = "Hi, " + firstname + " " + lastname + "!"
            }
        }
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
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
                } else {
                    print("Document does not exist")
                }
            }

        }
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutSegue"{
            let vc = segue.destination as! LoginViewController
            //Data has to be a variable name in your RandomViewController
        }
    }
}
