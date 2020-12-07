//
//  SignUpController.swift
//  safe
//
//  Created by Yifeng Guo on 11/20/20.
//

import Foundation
import UIKit
import Firebase
class SignUpController: UIViewController{
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    
    @IBAction func signupButtonClick(_ sender: Any) {
        if(email.text != nil && password != nil){
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { [self] authResult, error in
                if(error != nil){
                    let alert = UIAlertController(title: "Invalid Format", message: "You email or password is in an invalid format. Please try again.", preferredStyle: .alert)
                    self.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            alert.dismiss(animated: true, completion: nil)
                    }
                }
                if(authResult != nil){
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = "Normal"
                    changeRequest?.commitChanges { (error) in
                      print(error)
                    }
                    let db = Firestore.firestore()
                    let user = Auth.auth().currentUser
                    db.collection("users").document(user!.uid).setData([
                            "firstName": firstName.text ?? "",
                            "lastName": lastName.text ?? "",
                            "phoneNumber": phoneNumber.text ?? "",
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                self.performSegue(withIdentifier: "signupSegue", sender: nil)
                            }
                        }
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Missing information", message: "We will need the required information to contact you.", preferredStyle: .alert)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    alert.dismiss(animated: true, completion: nil)
            }
        }
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signupSegue"{
            let vc = segue.destination as! MainController
            //vc.data = "Data you want to pass"
            //Data has to be a variable name in your RandomViewController
        }
    }
}
