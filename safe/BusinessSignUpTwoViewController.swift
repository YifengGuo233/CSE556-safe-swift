//
//  BusinessSignUpTwoViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase

class BusinessSignUpTwoViewController: UIViewController{
    
    @IBOutlet var businessNameField: UITextField!
    @IBOutlet var addressOneField: UITextField!
    @IBOutlet var addressTwoField: UITextField!
    @IBOutlet var cityField: UITextField!
    
    @IBOutlet var stateField: UITextField!
    @IBOutlet var zipField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    
    @IBAction func finishButtonClick(_ sender: Any) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection("store").document(user!.uid).updateData([
                "storeName": businessNameField.text ?? "",
                "addressOne": addressOneField.text ?? "",
            "addressTwo": addressTwoField.text ?? "",
            "city": cityField.text ?? "",
            "state":stateField.text ?? "",
            "zip":zipField.text ?? "",
            "phoneNumber": phoneNumberField.text ?? "",
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    self.performSegue(withIdentifier: "businessSignUpFinishSegue", sender: nil)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
