//
//  businessSignUpViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase

class BusinessSignUpViewController: UIViewController{
    
    
    
    @IBOutlet var showButton: UIButton!
    var show = true
    @IBAction func showButtonClick(_ sender: Any) {
        if(show){
            show = false
            passwordField.isSecureTextEntry = false
            showButton.setTitle("hide", for: .normal)
        }else{
            show = true
            passwordField.isSecureTextEntry = true
            showButton.setTitle("show", for: .normal)
        }
    }
    
    
    @IBOutlet var firstnameField: UITextField!
    @IBOutlet var lastnameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func nextButtonClick(_ sender: Any) {
        if(emailField.text != nil && passwordField != nil){
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { [self] authResult, error in
                if(error != nil){
                    let alert = UIAlertController(title: "Invalid Format", message: "You email or password is in an invalid format. Please try again.", preferredStyle: .alert)
                    self.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            alert.dismiss(animated: true, completion: nil)
                    }
                }
                if(authResult != nil){
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = "Business"
                    changeRequest?.commitChanges { (error) in
                      print(error)
                    }
                    let db = Firestore.firestore()
                    let user = Auth.auth().currentUser
                    db.collection("store").document(user!.uid).setData([
                            "firstName": firstnameField.text ?? "",
                            "lastName": lastnameField.text ?? "",
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                self.performSegue(withIdentifier: "businessSignupSegue", sender: nil)
                            }
                        }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

