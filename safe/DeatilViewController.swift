//
//  DeatilViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase
class DetailViewController: UIViewController{
    
    @IBOutlet var CodeField: UILabel!
    @IBOutlet var SelectTimeField: UIButton!
    var Code: String = ""
    var data: String = ""

    @IBOutlet var alertMeField: UITextField!
    @IBOutlet var numberOfGuestField: UITextField!
    @IBAction func alertMeChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(alertMeField.text, forKey: "alertMe")
    }
    
    @IBAction func numberOfGuestChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(numberOfGuestField.text, forKey: "numberOfGuest")
    }
    @IBAction func lineUpButtonClick(_ sender: Any) {
        
        self.performSegue(withIdentifier: "lineupSegue", sender: nil)
        //Other thing
        
    }
    @IBAction func selectTimeSlotButtonClick(_ sender: Any) {
        
    }
    
    func random() -> String{
        let random =  NSUUID().uuidString
        let index = random.index(random.startIndex, offsetBy: 5)
        let random_kindof = random[..<index]
        return String(random_kindof)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let defaults = UserDefaults.standard
        if let Code = defaults.string(forKey: "Code") {
            print(Code) // Some String Value
            CodeField.text = Code
        }
        else{
            Code = random()
            defaults.set(Code, forKey: "Code")
            CodeField.text = Code
        }
        if let startTime = defaults.string(forKey: "startTime") {
            let endTime = defaults.string(forKey: "endTime") ?? ""
            let seat = defaults.string(forKey: "seat") ?? ""
            let conStr = startTime + " - " + endTime + " have " + String(seat) + " left"
            SelectTimeField.setTitle(conStr, for: .normal)
        }
        
        //Store
        if let stringOne = defaults.string(forKey: "storeName") {
            print(stringOne) // Some String Value
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print("willAppear")
    }
    
}
