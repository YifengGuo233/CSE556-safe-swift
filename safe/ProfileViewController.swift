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
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    print(document.data())
                    print(document.data()?["firstName"])
                    if(document.data()?["firstName"] != nil){
                        username.text = document.data()?["firstName"] as? String
                    }
                    else{
                        username.text = "Dear User"
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
