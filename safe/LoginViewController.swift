//
//  ViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/14/20.
//

import UIKit
import Firebase
import Foundation
class LoginViewController: UIViewController {

    var handle: AuthStateDidChangeListenerHandle?
    @IBOutlet weak var InputEmailTextField: UITextField!

    @IBOutlet weak var InputPasswordTextField: UITextField!
    
    @IBAction func LoginButtonClick(_ sender: Any) {
        let email:String = InputEmailTextField.text ?? ""
        let password:String = InputPasswordTextField.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if(authResult != nil){
                if let user = Auth.auth().currentUser{
                    if(user.displayName == "Normal"){
                        let alert = UIAlertController(title: "Login", message: "You are logged in!", preferredStyle: .alert)
                        self!.present(alert, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                alert.dismiss(animated: true, completion: nil)
                            self!.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    }
                    else{
                        let alert = UIAlertController(title: "Login", message: "Welcome back, Business Owner!", preferredStyle: .alert)
                        self!.present(alert, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                alert.dismiss(animated: true, completion: nil)
                            self!.performSegue(withIdentifier: "businessLoginSegue", sender: nil)
                        }
                    }
                }
            }
            else{
                let alert = UIAlertController(title: "Auth Failed", message: "The combination of your password and username is wrong. Please try again.", preferredStyle: .alert)
                self!.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        alert.dismiss(animated: true, completion: nil)
                    }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue"{
            let vc = segue.destination as! MainController
            //vc.data = "Data you want to pass"
            //Data has to be a variable name in your RandomViewController
        }
    }
    
}

